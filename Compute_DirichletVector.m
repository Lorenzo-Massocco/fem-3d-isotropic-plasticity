function dir_dofs = Compute_DirichletVector(nodes)

x = nodes(:,1);
y = nodes(:,2);
z = nodes(:,3);
zmin = min(z);
zmax = max(z);
num_dofs = size(nodes,1)*3;

tol = 1e-1;

bottom_nodes = find(abs(z - zmin) < tol);
top_nodes = find(abs(z - zmax) < tol);


%% zero displacement at the bottom face

dir_dofs = [];

for n = bottom_nodes'

    dir_dofs = [dir_dofs;
                3*n-2 0 ;
                3*n-1 0 ;
                3*n 0 ];

end

%% prescribed displacement at the upper face

for n = top_nodes'

    dir_dofs = [dir_dofs;
                3*n-2 0;
                3*n-1 0.1;
                3*n 0];

end


%% zero displacement at the lateral face

% x = nodes(:,1);
% xmin = min(x);
% xmax = max(x);
% wall_nodes = find(abs(x - xmin) < tol);
% dir_dofs = [];
% 
% for n = wall_nodes'
% 
%     dir_dofs = [dir_dofs;
%                 3*n-2 0 ;
%                 3*n-1 0 ;
%                 3*n 0 ];
% 
% end

end