function F=f(t,x)

	global N p
	%Se pone a cero la funcion con la dimension N adecuada
	
	F = zeros(N,1);

	% Definir los parametros

	ra    = p(1);
	ba    = p(2);
	sigma = p(3);

	%Ecuaciones diferenciales del sistema
	F(1) = sigma*(x(2)-x(1));
	F(2) = (ra-x(3))*x(1)-x(2);
	F(3) = x(1)*x(2)-ba*x(3);

end
