clc; clear all; close;

%% mesh generation via PDE Toolbox
% model = createpde('structural','static-solid');
% gm = multicuboid(100,100,100);
% model.Geometry = gm;
% mesh = generateMesh(model,'GeometricOrder','linear','Hmax',20);
% 
% nodes = mesh.Nodes';        
% elem  = mesh.Elements';   
% 
% num_nodes = size(nodes,1);
% num_elem  = size(elem,1);
% num_dofs = num_nodes * 3;
% 
% TR = triangulation(elem,nodes);
% F = freeBoundary(TR);
% 
% dir_dofs = Compute_DirichletVector(nodes);
% neu_dofs = Compute_NeumannVector(nodes,elem);

%% mesh generation via .inp file
nodes = Read_Nodes('cube.inp');
elem = Read_Elements('cube.inp');

TR = triangulation(elem,nodes);
F = freeBoundary(TR);

num_nodes = size(nodes,1);
num_elem  = size(elem,1);
num_dofs = num_nodes * 3;

% dir_dofs = Read_Dirichlet('cube.inp');
neu_dofs = Compute_NeumannVector(nodes,elem);
dir_dofs = Compute_DirichletVector(nodes);

%% material properties
mat.E = 210000;   
mat.H = 1000;
mat.nu = 0.3;     
mat.sigmay = 250;     
mat.D = ElasticTensor(mat.E,mat.nu);

%% initializing the internal variables
eps_p = zeros(6,num_elem);
alpha = zeros(num_elem,1);

%% incremental load steps
num_steps = 20;
dir_dofs_step = dir_dofs;
neu_dofs_step = neu_dofs;
u = zeros(num_dofs,1);

for step = 1 : num_steps
    
    fprintf(['-------------- Load Step: %d ---------------\n'], step);
    dir_dofs_step(:,2) = (step/num_steps) * dir_dofs(:,2);
    neu_dofs_step = (step/num_steps) * neu_dofs;

    [u,sigma,eps_p,alpha] = NewtonRaphson_Equilibrium(u,elem,nodes,mat,eps_p,alpha,dir_dofs_step,neu_dofs_step);

end

%% post processing

ux = u(1:3:end);
uy = u(2:3:end);
uz = u(3:3:end);

scale = 1; 
Xdef = nodes(:,1) + scale*ux;
Ydef = nodes(:,2) + scale*uy;
Zdef = nodes(:,3) + scale*uz;

Umag = sqrt(ux.^2 + uy.^2 + uz.^2);

figure(1);
trisurf(F,Xdef,Ydef,Zdef,Umag,'EdgeColor','k','FaceColor','interp');
colorbar;
title('Deformed shape with displacement magnitude');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3); axis equal;

sigma_vm = Compute_NodalStress(u,sigma,elem,nodes);

figure(2);
trisurf(F,Xdef,Ydef,Zdef,sigma_vm,'EdgeColor','k','FaceColor','interp');
colorbar;
title('Deformed shape with nodal Von Mises stress');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3); axis equal;