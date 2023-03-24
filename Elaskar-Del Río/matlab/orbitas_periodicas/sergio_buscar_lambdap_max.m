function [lambdap_max,vlpm]=sergio_buscar_lambdap_max(t,x,j,a0,MT,Ll)

%[M  N] = size(x);

min2 = -1000;
tlpm = 0;
vlpm = zeros(3);

for i=1:1:Ll

  if x(i,2) > min2
    min2 = x(i,2);  
    tlpm = t(i);
%    ilpm = i+Min-1;
  end
  
end

lambdap_max = min2;
vlpm(1) = a0;
vlpm(2) = tlpm;
vlpm(3) = min2;

end


