function D = ElasticTensor(E,nu)

D = E/((1+nu)*(1-2*nu))* ...
   [1-nu nu nu 0 0 0;
    nu 1-nu nu 0 0 0;
    nu nu 1-nu 0 0 0;
    0 0 0 (1-2*nu)/2 0 0;
    0 0 0 0 (1-2*nu)/2 0;
    0 0 0 0 0 (1-2*nu)/2];

end