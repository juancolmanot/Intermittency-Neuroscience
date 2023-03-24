function F=f(t,x)

  global N  p 
  %Se pone a cero la funcion con la dimension N adecuada
  F = zeros(N,1);


  %Ecuaciones diferenciales del sistema

  if x(1) < 0
 
     fun = @f; 
     x0a = 0;
     bzs = fzero(fun,x0a);
         
     F(1) = x(2);

     F(2) = -x(2)*(x(3)*(1-x(2)^2)/(1+x(3)^2))*((1+x(2))*bzs+2*p(1)*sin(x(1)-t))-((1-x(2)^2)^(1.5))*(x(3)*bzs*sqrt(1-x(2)^2))/(1+x(3)^2);

     F(3) = (1+x(2))*bzs + 2*p(1)*sin(x(1)-t);

%     F(4) = 1;

  end


  if x(1) >= 0

     bzs = -sign(x(3))*sqrt(2*p(2))*sqrt((1+x(3)^2)^(1.5)-(1+x(3)^2));

     F(1) = x(2);

     F(2) = -x(2)*(x(3)*(1-x(2)^2)/(1+x(3)^2))*((1+x(2))*bzs+2*p(1)*sin(x(1)-t))-((1-x(2)^2)^(1.5))*(x(3)*bzs*sqrt(1-x(2)^2)+p(2)*x(1)*sqrt(1+x(3)^2))/(1+x(3)^2);

     F(3) = (1+x(2))*bzs + 2*p(1)*sin(x(1)-t);

%     F(4) = 1;

  end


  function y = f(z)
    y = (z/sqrt(1+x(3)^2))*cosh((-z*x(1)/sqrt(1+x(3)^2))+asinh(x(3)))+sign(sinh((-z*x(1)/sqrt(1+x(3)^2))+asinh(x(3))))*sqrt(2*p(2))*((1+sinh((-z*x(1)/sqrt(1+x(3)^2))+asinh(x(3)))^2)^(3/2)-(1+sinh((-z*x(1)/sqrt(1+x(3)^2))+asinh(x(3)))^2));
  end

end


