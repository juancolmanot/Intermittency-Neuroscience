
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                        %%%%   
%%%%            Integra las ecuaciones de Lorenz            %%%%
%%%%                                                        %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Se borran todas las variables del workspace antes de empezar
clear all
%% Se define dos variables globales: N: orden del sistema
global p  N 

% Orden del sistema
N           = 3;

%% Parametros de la integracion

Rel_Tol     = 1e-10;        % Tolerancia relativa
Abs_Tol     = 1e-12;        % Tolerancia absoluta
Max_Step    = 0.004;         % Paso maximo

%% Todos los parametros se define en la variable option. El Matlab define todos
%% estos parametros por defecto y son todos opcionales para optimizar el
%% calculo.

%options     = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Refine',1,'MaxStep ',Max_Step,'Events','events');
options     = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Refine',1,'MaxStep',Max_Step);

%% La opcion Events permite controlar la integracion de manera intermedia.
%% Por ejemplo, mi funcion event controla que la variable a_1 no sea mayor
%% que 50, cortando la integracion en caso contrario. La opcion tambien
%% puede ser usada para hacer secciones de Poincare.

%% Directorios de trabajo
%directorio1  = 'D:\Caos_5D_1\Polarizacion izquierda\Integracion ecuaciones';
%directorio2  = 'D:\Caos_5D_1\Polarizacion izquierda\Integracion ecuaciones';
%%  

%% Banderas para seleccionar las opciones del programa: 1-> activa, 0->desactiva
flag_Bifurcacion = 1;      % Calcular un diagrama de bifurcacion (DB)
ver_bifurcacion  = 1;      % Ver el diagrama de bifurcacion del directorio 2

arrancar_archivo = 0;      % Calcular el DB arrancando desde el ?ltimo punto del archivo 1
arrancar_manual  = 1;      % Calcular el DB arrancando con cond inicial y parametros dados por el usuario

PI               = 3.14159265359;

%Delta_ra         = 0.1;    % Incremento del parametro nu
T1               = 500;     % Tiempo de eliminacion de transitorio
T2               = 40;      % Tiempo de integracion
sp               = 0;      % Define el plano de la sección de Poincaré        
  
if arrancar_manual==1
%     disp('Arrancando Manualmente')
%%     Se definen los parametros del sistema

    ra    = 166.04;
    ba     = 8/3;
    sigma  = 10.0; 
            
    p    = [ra  ba  sigma];
       
    X0     = [2.0   -1.0   150.0]; 
    M      = 1;
end
   

% Primer ciclo de integracion

disp(['                                                     '])  
disp(['-----------------------------------------------------']) 
disp(['-----------------------------------------------------']) 
disp(['                                                     ']) 
%disp(['Haciendo Primera integracion del punto ',num2str(j)']) 
disp(['Eliminando Transitorio un tiempo   ', num2str(T1),'  Parametro de control (ra) ',num2str(ra)])
disp(['                                                     ']) 

%  [t,x,TE,YE,IE]  = ode45(@f,[0 T1],X0,options);
[t,x]  = ode45(@f,[0 T1],X0,options);

X0 = [x(length(t),1)  x(length(t),2)  x(length(t),3)];
          
clear x t Resto    

disp(['Integracion de tiempo  ',num2str(T2),'  Parametro de control (ra) ',num2str(ra)])

%  [t,x,TE,YE,IE]  = ode45(@f,[0 T2],X0,options);
[t,x] = ode45(@f,[0 T2],X0,options);
      

tj = t(:);
xj = x(:,1);   
yj = x(:,2);   
zj = x(:,3);   
                                   
%paso = 1
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
          tc_z(ih) = tj(i);
          ty(ih,1) = tj(i);
          ty(ih,2) = y12(ih);
       end
    end  
end
   
paso = 2;

yp = sort(y12);
tco_z = sort(tc_z);

tlen_z = length(tco_z);
tmax_z = tc_z(tlen_z);

ipp_z = length(yp); % Numero de puntos en el mapa

ypf = yp(ipp_z);
ypi = yp(1);

mp_z = zeros(ipp_z-1,2);

for j = 2:ipp_z
    mp_z(j,1) = y12(j-1);
    mp_z(j,2) = y12(j);
    yx(j) = y12(j-1);
    yy(j) = y12(j);
end


for li = 1:800
    rex(li) = li;
    rey(li) = li;
end    
  
save('Poincare_y_r=166,04-delta=0,004-cuadratica.dat', '-ascii', '-double', 'mp_z');
save('y-vs-t-Poincare_r=166,04-delta=0,004-cuadratica.dat', '-ascii', '-double', 'ty');



filename1 = 'Poincare_y_r=166,04-delta=0,004-cuadratica.pdf';
filename2 = 'y-vs-t-Poincare_r=166,04-delta=0,004-cuadratica.pdf';
%filename6 = 'y-vs-x-r=166,04-delta=0,004.pdf';
%filename3 = 'z-vs-x-r=166,04-delta=0,004.pdf';
%filename5 = 'z-vs-y-r=166,04-delta=0,004.pdf';
%filename4 = 'x-vs-y-vs-z-r=166,04-delta=0,004.pdf';

%figure;
% Establecer propiedades del papel
%[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk = 6.0;    % MarkerSize
%mk2 = 3.0;    % MarkerSize

xleft1 = ypi; xright1 = ypf;
ydown1 = ypi; yup1 = ypf;

%ttotal = tmax

xleft2 = 0; xright2 = tmax_z;
ydown2 = ypi; yup2 = ypf;

% Realizar los gráficos
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);

figure(1);
orient(figure(1),'landscape');
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
plot(yx,yy,'.r','MarkerSize',mk); hold on
%plot(yx,yy,'-r','LineWidth',lw); hold on
plot(rex,rey,'-k','LineWidth',lw); hold on
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft1 xright1])
set(gca,'YLim',[ydown1 yup1])

xlabel('$z\left(i\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$z\left(i+1\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename1);


figure(2)
orient(figure(2),'landscape')
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
plot(tc_z,y12,'.r','LineWidth',mk); hold on
plot(rex,rey,'.k','LineWidth',lw); hold on

% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft2 xright2])
set(gca,'YLim',[ydown2 yup2])

xlabel('$t$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$y\left(i\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename2);


xp = [0, 0, 0];
yp = [0, 0, 0];


ifi = length(t);
ih = 0;           

for i = 2:ifi
    if xj(i) > sp
       if xj(i-1) < sp
          ih = ih +1;
          xp(1) = xj(i-1); 
          xp(2) = xj(i);
          xp(3) = xj(i+1);
          yp(1) = zj(i-1); 
          yp(2) = zj(i);
          yp(3) = zj(i+1);            
          pa = polyfit(xp,yp,2);
          ap = pa(1);
          bp = pa(2);
          cp = pa(3);
          z12(ih) = ap*sp^2+bp*sp+cp;
          tc_y(ih) = tj(i);
          tz(ih,1) = tj(i);
          tz(ih,2) = z12(ih);
       end
    end  
end
   
paso = 2;

zp = sort(z12);
tco_y = sort(tc_y);

tlen_y = length(tco_y);
tmax_y = tc_y(tlen_y);

ipp_y = length(zp); % Numero de puntos en el mapa

zpf = zp(ipp_y);
zpi = zp(1);

%mp = zeros(ipp-1,2);

for j = 2:ipp_y
    mp_y(j,1) = z12(j-1);
    mp_y(j,2) = z12(j);
    zx(j) = z12(j-1);
    zz(j) = z12(j);
end


for li = 1:800
    rex(li) = li;
    rey(li) = li;
end    
  
save('Poincare_z_r=166,04-delta=0,004-cuadratica.dat', '-ascii', '-double', 'mp_y');
save('z-vs-t-Poincare_r=166,04-delta=0,004-cuadratica.dat', '-ascii', '-double', 'tz');



filename3 = 'Poincare_z_r=166,04-delta=0,004-cuadratica.pdf';
filename4 = 'z-vs-t-Poincare_r=166,04-delta=0,004-cuadratica.pdf';
%filename6 = 'y-vs-x-r=166,04-delta=0,004.pdf';
%filename3 = 'z-vs-x-r=166,04-delta=0,004.pdf';
%filename5 = 'z-vs-y-r=166,04-delta=0,004.pdf';
%filename4 = 'x-vs-y-vs-z-r=166,04-delta=0,004.pdf';

%figure;
% Establecer propiedades del papel
%[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk = 6.0;    % MarkerSize
%mk2 = 3.0;    % MarkerSize

xleft1 = zpi; xright1 = zpf;
zdown1 = zpi; zup1 = zpf;

%ttotal = tmax

xleft2 = 0; xright2 = tmax_y;
zdown2 = zpi; zup2 = zpf;

% Realizar los gráficos
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);

figure(3)
%orient(figure(1),'landscape')
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
plot(zx,zz,'.r','MarkerSize',mk); hold on
%plot(yx,yy,'-r','LineWidth',lw); hold on
plot(rex,rey,'-k','LineWidth',lw); hold on
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft1 xright1])
set(gca,'YLim',[zdown1 zup1])

xlabel('$y\left(i\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$y\left(i+1\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

%set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename3);


figure(4)
%orient(figure(2),'landscape')
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
plot(tc_y,z12,'.r','LineWidth',mk); hold on
%plot(rex,rey,'.k','LineWidth',lw); hold on
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft2 xright2])
set(gca,'YLim',[zdown2 zup2])

xlabel('$t$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$z\left(i\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename4);

%mk = 1;
%lw = 0.5;


%figure(3)
%orient(figure(3),'landscape')
%[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
%plot(xj,zj,'-b','LineWidth',lw); hold on
% Propiedades del gráfico
%set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
%set(gca,'XLim',[-50 50])
%set(gca,'YLim',[50 250])
%xlabel('$x_1$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%ylabel('$x_3$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%set(gca,'FontSize',fontsize,'FontName',fontname)
%set(gcf, 'renderer', 'painters');
%print(gcf, '-dpdf', filename3);

%figure(4)
%orient(figure(4),'landscape')
%[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
%plot3(xj,yj,zj,'.b','MarkerSize',mk)
%xlabel('$x_1$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%ylabel('$x_2$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%zlabel('$x_3$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%set(gca,'FontSize',fontsize,'FontName',fontname)
%print(gcf, '-dpdf', filename4);

%liq = 1;

%if liq == 2

%figure(5)  
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
%plot(yj,zj,'-b','LineWidth',lw); hold on
% Propiedades del gráfico
%set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
%set(gca,'XLim',[xleft1 xright1])
%set(gca,'YLim',[ydown1 yup1])
%xlabel('$x_2$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%ylabel('$x_3$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%set(gca,'FontSize',fontsize,'FontName',fontname)
%set(gcf, 'renderer', 'painters');
%print(gcf, '-dpdf', filename5);

%figure(6)
%axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
%plot(xj,yj,'.b','MarkerSize',mk); hold on
% Propiedades del gráfico
%set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
%set(gca,'XLim',[xleft1 xright1])
%set(gca,'YLim',[ydown1 yup1])
%xlabel('$x_1$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%ylabel('$x_2$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
%set(gca,'FontSize',fontsize,'FontName',fontname)
%set(gcf, 'renderer', 'painters');
%print(gcf, '-dpdf', filename6);

%end   