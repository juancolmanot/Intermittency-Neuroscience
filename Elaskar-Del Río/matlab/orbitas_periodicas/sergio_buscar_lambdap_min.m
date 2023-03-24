function [lambdap_min,vlpmi]=sergio_buscar_lambdap_min(t,x,j,a0,MT,Ll)

%N = 3;

max2 = 1000;
tlm = 0;
vlpmi = zeros(3);


for i=1:1:Ll
  if x(i,2) < max2
    max2 = x(i,2);  
    tlm = t(i);
  end
end


lambdap_min = max2;
vlpmi(1) = a0;
vlpmi(2) = tlm;
vlpmi(3) = max2;

end


