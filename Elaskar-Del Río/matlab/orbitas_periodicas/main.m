%%% Ejemplo integra las ecuaciones 4D paper 2014 de onda plana
%%% Cambia la condicion inicial sin modificar los parametros de control

%% Se borran todas las variables del workspace antes de empezar 
clear all
%% Se definen 15 decimales
% format long  
%% Se define dos variables globales: N: orden del sistema
global N  p  

%% Orden del sistema
N           = 3;

%% Parametros de la integracion
Rel_Tol     = 1e-09;        % Tolerancia relativa
Abs_Tol     = 1e-10;        % Tolerancia absoluta
Max_Step    = 0.001;        % Paso máximo

%% Todos los parametros se define en la variable option. El Matlab define todos
%% estos parametros por defecto y son todos opcionales para optimizar el cálculo.

options     = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Refine',1,'MaxStep',Max_Step);
% options     = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Refine',1,'MaxStep',Max_Step);


%% Directorios de trabajo
directorio1   = 'Lambda_max.txt';
directorio2   = 'Lambdap_max.txt';
directorio3   = 'A_max.txt';

directorio4   = 'Lambda_min.txt';
directorio5   = 'Lambdap_min.txt';
directorio6   = 'A_min.txt';

directorio8   = 'Evolucion_de_maximos.txt';
directorio9   = 'Floquet.txt';
directorio10  = 'Evolucion_de_minimos.txt';

directorio101 = 'Variables_funcion-del-tiempo_1.txt';
directorio102 = 'Variables_funcion-del-tiempo_2.txt';
directorio103 = 'Variables_funcion-del-tiempo_3.txt';
directorio104 = 'Variables_funcion-del-tiempo_4.txt';
directorio105 = 'Variables_funcion-del-tiempo_5.txt';
directorio106 = 'Variables_funcion-del-tiempo_6.txt';
directorio107 = 'Variables_funcion-del-tiempo_7.txt';
directorio108 = 'Variables_funcion-del-tiempo_8.txt';
directorio109 = 'Variables_funcion-del-tiempo_9.txt';
directorio110 = 'Variables_funcion-del-tiempo_10.txt';

directorio301 = 'Lambda_funcion-tiempo_ultima-iteracion.txt';
directorio302 = 'Lambdap_funcion-tiempo_ultima-iteracion.txt';
directorio303 = 'A_funcion-tiempo_ultima-iteracion.txt';

%% Banderas para seleccionar las opciones del programa: 
%% 1-> arranque manual, 0-> arranque desde un archivo

arrancar_archivo = 0;  % Calcular el DB arrancando desde el último punto del archivo 1
arrancar_manual  = 1;  % Calcular el DB arrancando con cond inicial y parametros dados por el usuario

Delta_a0 = 1;                     % Incremento del parametro a0
MT       = 26;                     % Numero total de puntos del parametro a0
PI       = 3.14159265358979323846;
Itmax    = 50;                     % Número máximo de Iteraciones 

x = zeros(N,1);
X0p = zeros(N);

T0 = 2*PI;       % Periodo del sistema
T1 = 10*T0;      % Tiempo de eliminacion de transitorio
Ta = T1;

%% Comienza el cálculo

if arrancar_archivo==1
   Archivo    = load(directorio1);
   disp('Arrancando desde Archivo')
   [MT N0]  = size(Archivo);
   a0  = Archivo(M,1); 
   n0  = Archivo(M,2); 
   X0  = [Archivo(M,3) Archivo(M,4) Archivo(M,5)];      
end
  
if arrancar_manual==1
   disp('Arrancando Manualmente')
%% Se definen los parametros de control del sistema
   a0 = 4;  % amplitud del láser 
   n0 = 100; % densidad del plasma
   
%% Se dan las condiciones iniciales
   Xi = [0.0035    0.0026    0.2246]; % para atractor A1
%   Xi = [-0.6     0.1     0.0]; % para atractor A2 inestable
%   Xi = [-0.4923    0.3309    0.1140]; % para atractor A2 inestable
end

vg = zeros(MT,4);
vi = zeros(MT,4);
       
for j=1:1:MT
            
    % Se incrementa el parametro a0
    a0 = a0 + Delta_a0
    vg(j,1) = a0;
    vi(j,1) = a0;
            
    % Se actualiza el vector de parámetros
    p    = [a0 n0];

%    if j > 1
%        T1 = Ta/2;
%    end    
        
    idan = 71;
    if idan == 1
       if j == 1
          disp(['Haciendo Primera integracion del punto ',num2str(j),'  de un total de ',num2str(MT)]) 
          disp(['Eliminando Transitorio un tiempo   ', num2str(T1),'  Parametro de control  ',num2str(a0)])
          [t,x]  = ode45(@f,[0 T1],Xi,options);
          Xi = [x(length(t),1) x(length(t),2) x(length(t),3)];
       end   
    end
           
    % Calculo de la estabilidad de la órbita
    disp('Búsqueda y estabilidad de la órbita')
    clear X  T 
    [X,T,Error,Floquet] = ODE_Corrector_Periodicas(Xi,T0,Itmax); 

%    XF = X(end,:)';
%    Xi = XF';
    
    Ll = length(T);

    if j == 1
      for k = 1:1:Ll
        v1(k,1) = T(k);
        v1(k,2) = X(k,1);
        v1(k,3) = X(k,2);
        v1(k,4) = X(k,3);
      end
      save(directorio101,'v1','-ascii','-double')  
    end 
    
    js = 2;

    if js == 1

      if j == 2
        for k = 1:1:Ll
          v2(k,1) = T(k);
          v2(k,2) = X(k,1);
          v2(k,3) = X(k,2);
          v2(k,4) = X(k,3);
        end
        save(directorio102,'v2','-ascii','-double')        
      end 
     
      if j == 3
        for k = 1:1:Ll
          v3(k,1) = T(k);
          v3(k,2) = X(k,1);
          v3(k,3) = X(k,2);
          v3(k,4) = X(k,3);
        end
        save(directorio103,'v3','-ascii','-double')
      end 
    
      if j == 4
        for k = 1:1:Ll
          v4(k,1) = T(k);
          v4(k,2) = X(k,1);
          v4(k,3) = X(k,2);
          v4(k,4) = X(k,3);
        end
        save(directorio104,'v4','-ascii','-double')
      end 
    
      if j == 5
        for k = 1:1:Ll
          v5(k,1) = T(k);
          v5(k,2) = X(k,1);
          v5(k,3) = X(k,2);
          v5(k,4) = X(k,3);
        end
        save(directorio105,'v5','-ascii','-double')
      end 
    
      if j == 6
        for k = 1:1:Ll
          v6(k,1) = T(k);
          v6(k,2) = X(k,1);
          v6(k,3) = X(k,2);
          v6(k,4) = X(k,3);
        end
        save(directorio106,'v6','-ascii','-double')
      end 
    
      if j == 7
        for k = 1:1:Ll
          v7(k,1) = T(k);
          v7(k,2) = X(k,1);
          v7(k,3) = X(k,2);
          v7(k,4) = X(k,3);
        end
        save(directorio107,'v7','-ascii','-double')
      end 
    
      if j == 8
        for k = 1:1:Ll
          v8(k,1) = T(k);
          v8(k,2) = X(k,1);
          v8(k,3) = X(k,2);
          v8(k,4) = X(k,3);
        end
        save(directorio108,'v8','-ascii','-double')
      end 
    
      if j == 9
        for k = 1:1:Ll
          v9(k,1) = T(k);
          v9(k,2) = X(k,1);
          v9(k,3) = X(k,2);
          v9(k,4) = X(k,3);
        end
        save(directorio109,'v9','-ascii','-double')
      end 
    
      if j == 10
        for k = 1:1:Ll
          v10(k,1) = T(k);
          v10(k,2) = X(k,1);
          v10(k,3) = X(k,2);
          v10(k,4) = X(k,3);
        end
        save(directorio110,'v10','-ascii','-double')
      end 
 
    end   % if js == 1


    for k = 1:1:Ll
      vf1(k,1) = T(k);
      vf2(k,1) = T(k);
      vf3(k,1) = T(k);
      vf1(k,2) = X(k,1);
      vf2(k,2) = X(k,2);
      vf3(k,2) = X(k,3);
    end
  
    for k = 1:1:Ll
      vr(k,1) = T(k);
      vr(k,2) = X(k,1);
      vr(k,3) = X(k,2);
      vr(k,4) = X(k,3);
    end

    save(directorio301,'vf1','-ascii','-double')
    save(directorio302,'vf2','-ascii','-double')
    save(directorio303,'vf3','-ascii','-double')

    
    figure(1)
    plot(vr(:,1),vr(:,2),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('t')
    ylabel('\lambda')
    hold on
    
    figure(2)
    plot(vr(:,1),vr(:,3),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('t')
    ylabel('\lambda_p')
    hold on
    
    figure(3)
    plot(vr(:,1),vr(:,4),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('t')
    ylabel('a')
    hold on
    
    figure(4)
    plot(vr(:,2),vr(:,3),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('\lambda')
    ylabel('\lambda_p')
    hold on
    
    figure(5)
    plot(vr(:,2),vr(:,4),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('\lambda')
    ylabel('a')
    hold on
    
    figure(6)
    plot(vr(:,3),vr(:,4),'r.','MarkerSize',1)
    %plot(corx,cory,'-b','LineWidth',3)
    xlabel('\lambda_p')
    ylabel('a')
    hold on
    
    figure(7)
    plot3(vr(:,2),vr(:,3),vr(:,4),'r.','MarkerSize',1)
    xlabel('\lambda')
    ylabel('\lambda_p')
    zlabel('a')
    hold on    
    
   
    FmE(j,1) = a0;
    FmE(j,2) = real(Floquet(1,1));
    FmE(j,3) = imag(Floquet(1,1));
    FmE(j,4) = real(Floquet(2,2));
    FmE(j,5) = imag(Floquet(2,2));
    FmE(j,6) = real(Floquet(3,3));
    FmE(j,7) = imag(Floquet(3,3));
%    FmE(j,8) = Error;
    
    save(directorio9,'FmE','-ascii','-double')  
    
    [lambda_max,vlm] = sergio_buscar_lambda_max(T,X,j,a0,MT,Ll);
    [a_max,vam] = sergio_buscar_a_max(T,X,j,a0,MT,Ll);
    [lambdap_max,vlpm] = sergio_buscar_lambdap_max(T,X,j,a0,MT,Ll);
    
    plm(j,1) = vlm(1);
    plm(j,2) = vlm(2);
    plm(j,3) = vlm(3);

    plpm(j,1) = vlpm(1);
    plpm(j,2) = vlpm(2);
    plpm(j,3) = vlpm(3);

    pam(j,1) = vam(1);
    pam(j,2) = vam(2);
    pam(j,3) = vam(3);
    
    save(directorio1,'plm','-ascii','-double')  
    save(directorio2,'plpm','-ascii','-double')   
    save(directorio3,'pam','-ascii','-double')   
    
    vg(j,2) = lambda_max;
    vg(j,3) = lambdap_max;
    vg(j,4) = a_max;
    
    save(directorio8,'vg','-ascii','-double')   
    
    [lambda_min,vlmi] = sergio_buscar_lambda_min(T,X,j,a0,MT,Ll);
    [a_min,vami] = sergio_buscar_a_min(T,X,j,a0,MT,Ll);
    [lambdap_min,vlpmi] = sergio_buscar_lambdap_min(T,X,j,a0,MT,Ll);

    plmi(j,1) = vlmi(1);
    plmi(j,2) = vlmi(2);
    plmi(j,3) = vlmi(3);

    plpmi(j,1) = vlpmi(1);
    plpmi(j,2) = vlpmi(2);
    plpmi(j,3) = vlpmi(3);

    pami(j,1) = vami(1);
    pami(j,2) = vami(2);
    pami(j,3) = vami(3);

   
    save(directorio4,'plmi','-ascii','-double')  
    save(directorio5,'plpmi','-ascii','-double')   
    save(directorio6,'pami','-ascii','-double')   
    
    vi(j,2) = lambda_min;
    vi(j,3) = lambdap_min;
    vi(j,4) = a_min;
    
    save(directorio10,'vi','-ascii','-double')   
    
    Xi = X(end,:)
    
end  % fin del ciclo for j=1:1:MT

%corx = a0v(:,1)
%cory = a0v(:,2)

disp('Graficación')

if MT > 1

  figure(200)
  plot(vg(:,1),vg(:,2),'-r','LineWidth',1)
  hold on
  plot(vi(:,1),vi(:,2),'-b','LineWidth',1)
  hold on
  xlabel('a_0')
  ylabel('\lambda_{max}')
  
  figure(300)
  plot(vg(:,1),vg(:,3),'-r','LineWidth',1)
  hold on
  plot(vi(:,1),vi(:,3),'-b','LineWidth',1)
  hold on
  xlabel('a_0')
  ylabel('\lambdap_{max}')
  hold on

  figure(400)
  plot(vg(:,1),vg(:,4),'-r','LineWidth',1)
  hold on
  plot(vi(:,1),vi(:,4),'-b','LineWidth',1)
  hold on
  xlabel('a_0')
  ylabel('a_{max}')
  
  figure(500)
  plot(cos([0:0.01:2*pi]),sin([0:0.01:2*pi]),'k')
  hold on
  plot(FmE(:,2),FmE(:,3),'-b','LineWidth',2)
  hold on
  plot(FmE(:,4),FmE(:,5),'-r','LineWidth',2)   
  hold on
  plot(FmE(:,6),FmE(:,7),'-g','LineWidth',2)  
  hold on
  
end 


filename1 = '1.pdf';
filename2 = '2.pdf';
filename3 = '3.pdf';
filename4 = '4.pdf';
filename5 = '5.pdf';
filename6 = '6.pdf';
filename7 = '7.pdf';
filename200 = '200.pdf';
filename300 = '300.pdf';
filename400 = '400.pdf';
filename500 = '500.pdf';


print(figure(1),'-dpdf',filename1);
print(figure(2),'-dpdf',filename2);
print(figure(3),'-dpdf',filename3);
print(figure(4),'-dpdf',filename4);
print(figure(5),'-dpdf',filename5);
print(figure(6),'-dpdf',filename6);
print(figure(7),'-dpdf',filename7);
print(figure(200),'-dpdf',filename200);
print(figure(300),'-dpdf',filename300);
print(figure(400),'-dpdf',filename400);
print(figure(500),'-dpdf',filename500);


disp(' ')
disp('-----------------')
disp('------ FIN ------')
disp('-----------------')
disp(' ')




            






