function [Ke,Fint_e,eps_p_new,alpha_new,sigma] = ReturnMapping(u_e,coord_e,mat,eps_p,alpha);

[B,V] = Compute_MatrixB(coord_e);
eps = B*u_e;

D = mat.D;
sigma_tr = D * (eps - eps_p);
m = mean(sigma_tr(1:3));
s = sigma_tr - [m;m;m;0;0;0];
W = diag([1,1,1,2,2,2]);
sigma_vm = sqrt((3/2)*(s'*W*s));
f = sigma_vm - (mat.sigmay + mat.H * alpha);

if f <= 0

    sigma = sigma_tr;
    eps_p_new = eps_p;
    alpha_new = alpha;
    Dep = D;

else

    n = (3/2)*W*s/sigma_vm;
    gamma = f / (n'*D*n + mat.H);
    sigma = sigma_tr - gamma*D*n;
    alpha_new = alpha + gamma;
    eps_p_new = eps_p + gamma*n;
    Dep = D - ((D*n)*(D*n)')/((n'*D*n)+mat.H);

end

Ke = V*(B'*Dep*B);
Fint_e = V*(B'*sigma);

end

