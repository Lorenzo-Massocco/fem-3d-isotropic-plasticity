function sigma_vm = Compute_NodalStress(u,sigma,elem,nodes);

num_nodes = size(nodes,1);
num_elem = size(elem,1);
stress_nodal = zeros(6,num_nodes);
counter = zeros(1,num_nodes);
sigma_vm = zeros(num_nodes,1);

for i = 1 : num_elem
    for j = 1 : 4

        node_id = elem(i,j);
        stress_nodal(:,node_id) = stress_nodal(:,node_id) + sigma(:,i);
        counter(node_id) = counter(node_id) + 1;

    end
end

stress_nodal = stress_nodal./counter;

for i = 1 : num_nodes

    m = mean(stress_nodal(1:3,i));
    s = stress_nodal(:,i) - [m;m;m;0;0;0];
    W = diag([1,1,1,2,2,2]);
    sigma_vm(i) = sqrt((3/2)*(s'*W*s));
    
end

end








