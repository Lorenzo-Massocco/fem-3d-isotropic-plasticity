function neu_dofs = Compute_NeumannVector(nodes,elem)

x = nodes(:,1);
y = nodes(:,2);
z = nodes(:,3);
zmin = min(z);
zmax = max(z);
xmax = max(x);
num_dofs = size(nodes,1)*3;
neu_dofs = zeros(num_dofs,1);

tol = 20;

bottom_nodes = find(abs(z - zmin) < tol);
top_nodes = find(abs(z - zmax) < tol);

%% nodal load in the z-direction
% fz_total = 100000.0;  
% fz = fz_total / length(top_nodes);
%  
% for n = top_nodes'
% 
%     neu_dofs(3*n) = fz;
% 
% end

%% surface traction on the whole top face of the body

% fz = -4000; % [N]
% 
% TR = triangulation(elem,nodes);
% F = freeBoundary(TR);
% z_top = max(nodes(:,3));
% top_faces = [];
% num_nodes = size(nodes,1);
% 
% 
% for f = 1 : size(F,1)
%
%     face_nodes = F(f,:);       
%     z_face = nodes(face_nodes,3); 
%     x_face = nodes(face_nodes,1);
%
%     if all(abs(z_face - z_top) < tol)   
%         top_faces = [top_faces; face_nodes];
%     end
%
% end
% 
% top_node_area = zeros(num_nodes,1);
% 
% for f = 1 : size(top_faces,1)
% 
%     face_nodes = top_faces(f,:);
% 
%     x = nodes(face_nodes,1); 
%     y = nodes(face_nodes,2); 
%     z = nodes(face_nodes,3);
%     area = 0.5*norm(cross([x(2)-x(1), y(2)-y(1), 0], [x(3)-x(1), y(3)-y(1), 0]));
% 
%     top_node_area(face_nodes) = top_node_area(face_nodes) + area/3;
% 
% end
% 
% for n = top_nodes'
% 
%     neu_dofs(3*n) = neu_dofs(3*n) + fz * top_node_area(n)/sum(top_node_area(top_nodes));
% 
% end

%% surface traction on a portion of the upper face of the body 
%
% fz = -4000; % [N]
%
% load_nodes = find(x - 60 > 0 & abs(z - zmax) < tol);
% TR = triangulation(elem,nodes);
% F = freeBoundary(TR);
% z_top = max(nodes(:,3));
% load_faces = [];
% num_nodes = size(nodes,1);
% 
% for f = 1 : size(F,1)
%
%     face_nodes = F(f,:);       
%     z_face = nodes(face_nodes,3); 
%     x_face = nodes(face_nodes,1); 
%
%     if all(abs(z_face - z_top) < tol) && all(x_face - 60 > 0)
%         load_faces = [load_faces; face_nodes];
%     end
%
% end
% 
% top_node_area = zeros(num_nodes,1);
% 
% for f = 1 : size(load_faces,1)
%
%     face_nodes = load_faces(f,:);
% 
%     % triangle area
%     x = nodes(face_nodes,1); 
%     y = nodes(face_nodes,2); 
%     z = nodes(face_nodes,3);
%     area = 0.5*norm(cross([x(2)-x(1), y(2)-y(1), 0], [x(3)-x(1), y(3)-y(1), 0]));
% 
%     % distribute traction equally to nodes
%     top_node_area(face_nodes) = top_node_area(face_nodes) + area/3;
%
% end
% 
% for n = load_nodes'
%
%     neu_dofs(3*n) = neu_dofs(3*n) + fz * top_node_area(n)/sum(top_node_area(load_nodes));
%
% end
% 

%% surface traction on the lateral face of the body (curved pipe)

fz = -0; % [N]

load_nodes = find(abs(x - xmax) < tol);
TR = triangulation(elem,nodes);
F = freeBoundary(TR);
load_faces = [];
num_nodes = size(nodes,1);

for f = 1 : size(F,1)

    face_nodes = F(f,:);        
    x_face = nodes(face_nodes,1); 

    if all(abs(x_face - xmax) < tol)
        load_faces = [load_faces; face_nodes];
    end

end

top_node_area = zeros(num_nodes,1);

for f = 1 : size(load_faces,1)

    face_nodes = load_faces(f,:);

    % triangle area
    x = nodes(face_nodes,1); 
    y = nodes(face_nodes,2); 
    z = nodes(face_nodes,3);
    area = 0.5*norm(cross([x(2)-x(1), y(2)-y(1), 0], [x(3)-x(1), y(3)-y(1), 0]));

    % distribute traction equally to nodes
    top_node_area(face_nodes) = top_node_area(face_nodes) + area/3;

end

for n = load_nodes'

    neu_dofs(3*n-2) = neu_dofs(3*n-2) + fz * top_node_area(n)/sum(top_node_area(load_nodes));

end

end
