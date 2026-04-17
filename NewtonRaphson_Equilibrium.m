function [u,sigma,eps_p,alpha] = NewtonRaphson_Equilibrium(u,elem,nodes,mat,eps_p,alpha,dir_dofs,Fext)

tol = 1e-6;
maxit = 20;
u(dir_dofs(:,1)) = dir_dofs(:,2);
res = 1;
it = 0;

while res > tol

    it = it + 1;
    
    if it > maxit
        fprintf('Newton Raphson failed with a final residual of %f\n', res);
        error('Newton Raphson has not converged to the mechanical equilibrium');
    end
    
    [K,Fint,eps_p_new,alpha_new,sigma] = GlobalAssemble(u,elem,nodes,mat,eps_p,alpha);
    R = Fint - Fext;
    [K,R] = Impose_BoundaryConditions(K,R,dir_dofs);
    du = - K\R;
    u = u + du;
    res = norm(R);

end

eps_p = eps_p_new;
alpha = alpha_new;
fprintf('Newton Raphson has converged in %d iterations\n', it);

end
    
