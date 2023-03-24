function [a_max,vam]=sergio_buscar_a_max(t,x,j,a0,MT,Ll)

min3 = -1000;
tam = 0;
vam = zeros(3);

for i=1:1:Ll
  
  if x(i,3) > min3
    min3 = x(i,3);  
    tam = t(i);
%    iam = i+Min-1;
  end

end

a_max = min3;
vam(1) = a0;
vam(2) = tam;
vam(3) = min3;

end


