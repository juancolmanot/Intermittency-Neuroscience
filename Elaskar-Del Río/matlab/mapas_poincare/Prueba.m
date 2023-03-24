%% Se define dos variables globales: N: orden del sistema
global p  N 

% Orden del sistema
N           = 3;

Rel_Tol     = 1e-10;        % Tolerancia relativa
Abs_Tol     = 1e-12;        % Tolerancia absoluta
Max_Step    = 0.004;         % Paso maximo

options     = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Refine',1,'MaxStep',Max_Step);

T1               = 20000;     % Tiempo de eliminacion de transitorio
T2               = 50;      % Tiempo de integracion
sp               = 0;      % Define el plano de la sección de Poincaré 

ra    = 166.04;
ba     = 8/3;
sigma  = 10.0; 

p    = [ra  ba  sigma];

X0     = [2.0   -1.0   150.0]; 
M      = 1;

[t,x]  = ode45(@f,[0 T1],X0,options);

X0 = [x(length(t),1)  x(length(t),2)  x(length(t),3)];
          
clear x t Resto    

[t,x] = ode45(@f,[0 T2],X0,options);

tj = t(:);
xj = x(:,1);   
yj = x(:,2);   
zj = x(:,3);   
                                   
%paso = 1|
ifi = length(t);
ih = 0;           

for i = 2:ifi
    if xj(i) > sp
       if xj(i-1) < sp
          ih = ih +1;
          xp(1) = xj(i-1); 
          xp(2) = xj(i);
          xp(3) = xj(i+1);
          zp(1) = yj(i-1); 
          zp(2) = yj(i);
          zp(3) = yj(i+1);            
          pa = polyfit(xp,zp,2);
          ap = pa(1);
          bp = pa(2);
          cp = pa(3);
          y12(ih) = ap*sp^2+bp*sp+cp;
          tc(ih) = tj(i);
          ty(ih,1) = tj(i);
          ty(ih,2) = y12(ih);
       end
    end  
end
   
paso = 2

yp = sort(y12);
tco = sort(tc);

tlen = length(tco)
tmax = tc(tlen)

ipp = length(yp) % Numero de puntos en el mapa

ypf = yp(ipp)
ypi = yp(1)

%mp = zeros(ipp-1,2);

for j = 2:ipp
    mp(j,1) = y12(j-1);
    mp(j,2) = y12(j);
    yx(j) = y12(j-1);
    yy(j) = y12(j);
end


for li = 1:800
    rex(li) = li;
    rey(li) = li;
end


lw = 0.5;    % LineWidth
mk = 1.0;    % MarkerSize
%mk2 = 3.0;    % MarkerSize

xleft1 = ypi; xright1 = ypf;
ydown1 = ypi; yup1 = ypf;

%ttotal = tmax

xleft2 = 0; xright2 = tmax;
ydown2 = ypi; yup2 = ypf;

% Realizar los gráficos
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);

figure(1)
%orient(figure(1),'landscape')
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
plot(yx,yy,'.r','MarkerSize',lw); hold on
%plot(yx,yy,'-r','LineWidth',lw); hold on
plot(rex,rey,'-k','LineWidth',lw); hold on

