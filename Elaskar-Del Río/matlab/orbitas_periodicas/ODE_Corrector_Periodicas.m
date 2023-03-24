function [X,T,Error,Floquet]=ODE_Corrector_Periodicas(X0,T0,Itmax)    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Programa perteneciente al libro "Mec�nica Anal�tica: lagrangiana, hamiltoniana y sistemas din�micos" %%
%% Autores  -> Javier Sanz Recio y Gonzalo S�nchez Arriaga                                              %%
%% Nombre   -> ODE_Corrector_Periodicas.m                                                               %%
%% Objetivo -> Corrige �rbitas peri�dicas de sistemas aut�nomos                                         %%
%% Entradas -> Fun_DF:        funci�n F = Fun(t,x) con las ecuaciones diferenciales                     %%
%              X0:            vector de estado tentativo en t=0 para iniciar el algoritmo               %%
%              T0:            periodo tentativo para iniciar el algoritmo (si AUTO=0 es periodo es el   %%
%                             de la �rbitaperi�dica  )                                                  %%
%              Itmax, Tol:    n�mero m�ximo de iteraciones y tolerancia de la �rbita per�dica           %%
%              TolRel,TolAbs: Tolerancias relativas y absolutas del integrador                          %%
%              dh:            incremento para calcular el jacobiano con diferencias finitas             %%
%% Salidas  -> X0:            Vector de estado de la �rbita peri�dica en t = 0                          %%
%              T0:            Periodo de la �rbita peri�dica                                            %%
%              Error          Error de la �rbita peri�dica                                              %%
%              Floquet        Autovalores dela matriz de monodrom�a                                     %%
%              EXITO          1-> Orbita Ok, 0-> El algoritmo no converge                               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
%% Ejemplo %%%%
%%%%%%%%%%%%%%%
% Para el sistema  
% x' = x*y
% y' = 2x-y^2
% si se hace una llamada 
% [X0,T0,Error,Floquet]=Corrector_Autonomous(Fun_DF,X0,T0,Itmax,Tol,TolRel,TolAbs, 2)
% el programa trata de encontrar una �rbita peri�dica que en t=0 satisfiace y(t=0) = X0(2)

directorio51  = 'Proceso_iterativo.txt';
directorio200 = 'Error.txt';

global N  p

% Inicializa variables de salida
Error   = 0;
Floquet = 0;
EXITO   = 0;
M = zeros(N,N);
E = zeros(Itmax,5);
X0a = zeros(1,N);

Tol       = 1e-5;     % Tolerancia del algoritmo  
TolRel    = 1e-8;     % Tolerancia relativa del integrador 
TolAbs    = 1e-9;     % Tolerancia absoluta del integrador 
Max_Step  = 0.001;    % Paso máximo
dh        = 1e-4;     % Incremento para el calculo del jacobiano con diferencias finitas 

% Dimension del sistema y matriz identidad
Iden     = eye(N);

% Opciones de los integradores
options11  = odeset('RelTol',TolRel,'AbsTol',ones(1,N*(1+N))*TolAbs);
%options12 = odeset('RelTol',TolRel,'AbsTol',ones(1,N)*TolAbs);
options12   = odeset('RelTol',TolRel,'AbsTol',TolAbs,'Refine',1,'MaxStep',Max_Step);

% Prepara primera condicion inicial con el vector de estado ampliado
Xvar = [];
Xvar(1,1:N) = X0; % Ecuaciones diferenciales 
for j=1:1:N
    Xvar(1,N+(j-1)*N+1:N+j*N) = Iden(j,:); % Ecuaciones variacionales
end

for i=1:1:Itmax % Bucle para corregir la orbita
                
%   Compute the Initial Error
    [T X]       = ode45(@f,[0 T0],X0,options12);  % Integra la orbita
%    [T,X]       = ode45(@f,[0 T0],Xvar(1,1:N),options12);
    XF          = X(end,:)';
    
    E(i,1) = p(1);
    E(i,2) = i;
    E(i,3) = X0(1)-X(end,1);
    E(i,4) = X0(2)-X(end,2);
    E(i,5) = X0(3)-X(end,3);
    
    save(directorio200,'E','-ascii','-double')
               
    Error = max(abs(X0-XF')); 
        
    %   Muestra el resultado del disparo
    display(['Corrector: iteracion = ' num2str(i) '  Error = ' num2str(Error)])

    Xvar(1,1:N) = X0';
    
    [T1 X1]    = ode45(@FUNvariationalDF,[0 T0],Xvar,options11);
    for j=1:1:N
       for k=1:1:N
           M(j,k)   = X1(end,N+(j-1)*N+k); 
       end
    end
    M=M'; %Matriz de Monodromia
    
%    if Error<Tol % La orbita tiene calidad suficiente      
%       [Vec Val] = eig(M);    
%       for j=1:1:N
%            Floquet(1,j)  = Val(j,j); % Multiplicadores de Floquet
%       end  
%       EXITO = 1;     
%       break % Salir del bucle
%    end 

    if Error<Tol % La orbita tiene calidad suficiente      
       [Vec Val] = eig(M);    
%       for j=1:1:N
%            Floquet(1,j)  = Val(j,j) % Multiplicadores de Floquet
%       end  
       XF1     = X(end,:);
       xfinal  = X1(end,:);
       Jac1    = Jacob(@f,T(end),X(end,:),dh)                          % Calcula el Jacobiano
       Mon     = M
       Floquet = Val
       EXITO = 1;     
       break % Salir del bucle
    end 

    
    % Aceleracion de convergencia
%    min = -1000;
%    km = 0;
%    if Error>Tol
%        for k = 3:1:5
%           if E(i,k) > min
%              min = E(i,k); 
%              km = k;
%           end   
%        end
%    end   
%    kml = km-2;
    
    % Prepara la ecuacion  A * [DeltT X1 X2... XN ] = b (sin X(Index))
    A            = M-eye(N);
    B            = -(XF(1:N)-X0(1,1:N)');
    Correc       = A\B; % Correccion
    % Nota: hacer A\B es igual a hacer inv(A)*B

    for j=1:1:N
          X0(j) = X0(j) + Correc(j); % Corrige la condicion inicial
    end
    
    xiter(i,1) = i;
    xiter(i,2) = X0(1);
    xiter(i,3) = X0(2);
    xiter(i,4) = X0(3);
    
    save(directorio51,'xiter','-ascii','-double')   

    
%    we = 0.2;
%    for j=1:1:N
%        if j == kml
%            X0(j) = X0(j) + we*Correc(j);
%        else    
%            X0(j) = X0(j) + Correc(j); % Corrige la condicion inicial
%        end   
%    end
    
              
end  % for i=1:1:Itmax 



  function  DF = FUNvariationalDF(t,YV)
        
        Jac       = Jacob(@f,t,YV(1:N,1),dh);                          % Calcula el Jacobiano
        
                
        DF(1:N,1) = feval(@f,t,YV(1:N,1));                             % Lado derecho de las ecuaciones diferenciales  
        for cont1 = 1:1:N                                              % Bucle variables variacional 
            for cont2 = 1:1:N                                          % Bucle variable variacional 
               DF(N + (cont1-1)*N + cont2) = 0;
               for cont3 = 1:1:N                                       % Bucle para sumar
                 DF(N + (cont1-1)*N + cont2) = DF(N + (cont1-1)*N + cont2) + Jac(cont2,cont3)*YV(N + N*(cont1-1) + cont3);
               end
            end
        end
   end

end
