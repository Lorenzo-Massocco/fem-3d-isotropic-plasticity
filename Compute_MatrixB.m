function [B,V] = Compute_MatrixB(coord)

coeff = zeros(4,4);
A = [coord(1,:), 1;
     coord(2,:), 1;
     coord(3,:), 1;
     coord(4,:), 1;];

for i = 1 : 4
    rhs = zeros(4,1);
    rhs(i) = 1;
    coeff(:,i) = A\rhs;
end

B = zeros(6,12);

for i = 1 : 4
    a = coeff(1,i);
    b = coeff(2,i);
    c = coeff(3,i);

    Bi = [a 0 0;
          0 b 0;
          0 0 c;
          b a 0;
          0 c b;
          c 0 a];

    B(:,(3*(i-1)+1):(3*i)) = Bi;
end

x = coord(:,1);
y = coord(:,2);
z = coord(:,3);
V = (1/6)*abs(det([x(1)-x(4) y(1)-y(4) z(1)-z(4); 
                   x(2)-x(4) y(2)-y(4) z(2)-z(4); 
                   x(3)-x(4) y(3)-y(4) z(3)-z(4)]));

end
