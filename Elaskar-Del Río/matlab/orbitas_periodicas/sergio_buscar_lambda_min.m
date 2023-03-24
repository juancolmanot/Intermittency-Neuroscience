function [lambda_min,vlmi]=sergio_buscar_lambda_min(t,x,j,a0,MT,Ll)

%N = 3;

max1 = 1000;
tlm = 0;
vlmi = zeros(3);

for i=1:1:Ll
  if x(i,1) < max1
    max1 = x(i,1);  
    tlm = t(i);
  end
end

lambda_min = max1;
vlmi(1) = a0;
vlmi(2) = tlm;
vlmi(3) = max1;

end


