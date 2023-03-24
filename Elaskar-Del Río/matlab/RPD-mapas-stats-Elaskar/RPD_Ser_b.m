function [X,PHI] = RPD_Ser_b(Xj,xjmax,lbrn)

% Calcula la RPD numerica (distribucion de probabilidad de reinyeccion)

% Datos Iniciales

Nint = min([1000,round(max(size(Xj))/10)]);   %Numero de intervalos
%Nint = min([1000,round(max(size(Xj))/1)]);   %Numero de intervalos

% Definiciones
%limsup = xjmax;
%liminf = xjmin;
% c = (limsup - liminf)/2;
delta = (xjmax-lbrn)/Nint;

dimmax = max(size(Xj));

Xjint = zeros(Nint+1,1); 
X = zeros(Nint,1); 
PHI = zeros(Nint,1);
Xjint(1) = lbrn;

for i = 2:Nint+1
    Xjint(i) = lbrn + delta*(i-1);
%    Xjint(i) = delta*(i-1);
%    PHI(i-1) = 0;
    X(i-1) = delta/2 + Xjint(i-1); 
end

if dimmax > Nint
    for i = 1:dimmax
        for j = 1:Nint
            if (Xj(i) >= Xjint(j) && Xj(i) < Xjint(j+1))
                PHI(j) = PHI(j) + 1;                
            end
        end
    end    
else    
    for j = 1:Nint
        for i = 1:dimmax
            if (Xj(i) >= Xjint(j) && Xj(i) < Xjint(j+1))
                PHI(j) = PHI(j) + 1;
            end
        end
    end    
end

integral = 0;
for i = 1:Nint
    integral = integral + PHI(i)*delta;
end

PHI = (1/integral)*PHI;
