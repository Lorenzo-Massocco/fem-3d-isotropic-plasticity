function [K,R] = Impose_BoundaryConditions(K,R,dir_dofs)

for i = 1 : size(dir_dofs,1)

    dof = dir_dofs(i,1);
    
    K(:,dof) = 0;
    K(dof,:) = 0;
    K(dof,dof) = 1;
    R(dof) = 0;

end

end