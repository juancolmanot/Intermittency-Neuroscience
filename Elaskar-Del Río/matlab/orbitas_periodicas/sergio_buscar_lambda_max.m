function [lambda_max,vlm]=sergio_buscar_lambda_max(t,x,j,a0,MT,Ll)

%N = 3;

min1 = -1000;
tlm = 0;
vlm = zeros(3);


for i=1:1:Ll
  if x(i,1) > min1
    min1 = x(i,1);  
    tlm = t(i);
%    ilm = i+Min-1;
  end
end

%imax = im;
lambda_max = min1;

vlm(1) = a0;
vlm(2) = tlm;
vlm(3) = min1;

end


