function [K,Fint,eps_p_new,alpha_new,sigma] = GlobalAssemble(u,elem,nodes,mat,eps_p,alpha)

num_dofs = size(u,1);
num_elem = size(elem,1);
K = sparse(num_dofs,num_dofs);
Fint = zeros(num_dofs,1);
sigma = zeros(6,num_elem);
eps_p_new = eps_p;
alpha_new = alpha;

for e = 1 : num_elem
    
    nodes_e = elem(e,:);
    coord_e = nodes(nodes_e,:);
    dofs = reshape([3*nodes_e-2;3*nodes_e-1;3*nodes_e],[],1);
    u_e = u(dofs);

    [Ke,Fint_e,eps_p_new(:,e),alpha_new(e),sigma_e] = ReturnMapping(u_e,coord_e,mat,eps_p(:,e),alpha(e));
    
    K(dofs,dofs) = K(dofs,dofs) + Ke;
    Fint(dofs) = Fint(dofs) + Fint_e;
    sigma(:,e) = sigma_e;

end

end