function [a_min,vami]=sergio_buscar_a_min(t,x,j,a0,MT,Ll)

max3 = 1000;
tam = 0;
vami = zeros(3);

for i=1:1:Ll
  if x(i,3) < max3
    max3 = x(i,3);  
    tam = t(i);
  end
end

a_min = max3;
vami(1) = a0;
vami(2) = tam;
vami(3) = max3;

end


