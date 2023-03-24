function [m,alpha,Lmedn] = interm_I_Log3e(Nj,c,rq)
                       
% Esta funcion obtiene Nj puntos de reinyección y calcula los resultados
% estadisticos correspondientes
                       
    %% Mapa  
%      si x < sxra: y = x (1+eps) + a1 x^p  (mapa local)
%      si sxra < x < 1: y = (sin(x-sxra))/(sin(pi*(1-sxra)))

%      si sxra < x < 1: y = xjmin + (1-xjmin)*((x-sxra)/(1.d0-sxra))^gamma   OJO: No usada
    
    % lbr:               Lower bound of reinjection
    % gamma > 0:         Exponente para la rama derecha del mapa
    % p:                 Exponente del mapa local
    % c:                 Longitud del intervalo laminar
    % xjmin = x0 + lbr:  Mínimo punto de reinyección  
    % xjmax = x0 + c:    Máximo punto de reinyección
    % sxra:              Punto en el cual el mapa local vale 1
    % Nj:                Cantidad de puntos de reinyección
   


%% PARAMETROS PARA GRAFICAR    
opplot = 1;   % = 1 para graficar el mapa
              % = 2 para visualizar las iteraciones 
              
%% VALORES

Rcritico = 1.0 + 8^0.5;
Rusado = rq;

x0 = 0.5143552770619905;   %Pto fijo real para Rcritico

lbrt = -c; %Lbr calculado teóricamente con Mathematica

eps = 0.0018777607518555284;
q = 0.9965049762708632;
aa = 34.02521965341578;


%% FUNCION MAPA

function y = evalmapa(x,rq,x0)       
    
    y = -x0 + (rq^3)*(1-(x+x0))*(x+x0)*(1+rq*(-1+(x+x0))*(x+x0))*(1+rq^2*(-1+(x+x0))*(x+x0)*(1+rq*(-1+(x+x0))*(x+x0)));            
    
end

               
%% **** CALCULO DEL PROCESO SIN RUIDO ****
%% ***************************************
%% ***************************************
%% ***************************************

xjmin = -c;
xjmax = +c;

epsr = Rcritico-Rusado;

% Vectores para graficar el mapa
np = 2000;
deltax = 1/(np-1);
x = zeros(np,1); y = zeros(np,1); % r = zeros(np);
Fig = zeros(np,2);

for i = 1:np
    x(i) = -x0 + deltax*(i-1);
    y(i) = evalmapa(x(i),rq,x0);
    r(i) = x(i);
%    z(i) = evalmapaz(x(i),eps,a1,p,sxra,gamma);
%    if x(i) > sxra
%      z(i) = xjmin + (1-xjmin)*((x(i)-sxra)/(1.d0-sxra))^gamma;
%    end  
    Fig(i,1) = x(i);
    Fig(i,2) = y(i); 
end


% Graficar el mapa
% mk = 5;
if opplot > 0
%    figure(10); plot(x,z,'-r','Linewidth',2)
%    hold on
    figure(10); plot(x,y,'-b','Linewidth',1)
    hold on; plot(x,r,'-k','Linewidth',1) 
    %plot([min(x) max(y)],[min(x) max(y)],'-k')
%    hold on; plot(x,z,'-r','Linewidth',1.5)
end


%% PUNTOS DE REINYECCION
% Inicializacion

Xprev = xjmin + 2.5*c; % debe ser mayor que xjmax o menor que xjmin
   
long = 0; flag = 0;
xj = zeros(Nj,1); dimXj = 0; L = zeros(Nj,1);
porc = round(Nj/10); j = 0; prints = 0;
xjr = zeros(Nj,1);

while flag < 1
    
    X = evalmapa(Xprev,rq,x0);
      
    if X >= xjmin && X <= xjmax
        long = 1 + long;  %indica el numero de iteraciones en la fase laminar
        if Xprev < xjmin || Xprev > xjmax
            dimXj = 1 + dimXj;
            xj(dimXj,1) = X;
            xjr(dimXj,1) = Xprev;
        end
    end
    
    if X > xjmax || X < xjmin
        if Xprev >= xjmin && Xprev <= xjmax
           L(dimXj,1) = long;  %longitud laminar relacionada con el punto de reinyeccion dimXj
           long = 0;             
        end  
        if dimXj == Nj;
           flag = 2;
        end   
    end
    
    Xprev = X;
    
    if dimXj > prints
        j = j+1;
        jk = (j-1)*10;
        str = sprintf('%d %% its. completadas, %d puntos Xj', jk, dimXj);
        clc
        disp(str)
        prints = prints + porc;
    end
end

xj1 = zeros(dimXj,1);
xj1 = xj;

Xj = zeros(dimXj,1);
[Xj(:,1),idi] = sort(xj(:,1)); % ordena de menor a mayor los puntos reinyectados
Ls = L(idi); % longitudes laminares numericas o experimentales

V = sqrt(4*aa*eps-(q-1)^2);

ida = 11;

if ida == 1
    
   Mv = Nj;
   Ll1 = zeros(Mv,1);
   Ll2 = zeros(Mv,1);
   xg = zeros(Mv,1);

%   xg(1) = lbrt;
%   Ll1(1) = (2/V)*(atan((-1+q+2*aa*c)/V)-atan((-1+q+2*aa*lbrt)/V));

   for k = 1:Mv
       xg(k) = lbrt + (k-1)*(c-lbrt)/Mv;
%       Ll1(k) = (2/V)*(atan((-1+q+2*aa*c)/V)-atan((-1+q+2*aa*xg(k))/V))+1;
       Ll2(k) = (1/sqrt(aa*eps))*(atan(c*sqrt(aa/eps))-atan(xg(k)*sqrt(aa/eps)))+1;
   end    

   figure(3); hold on;
   plot(Xj,Ls,'.b'); 
%   plot(xg,Ll1,'.k'); 
   plot(xg,Ll2,'.r');
   xlabel('x')
   ylabel('L(x)')

end   
   

Ltot = 0;

for jl = 1:Nj
    Ltot = Ltot + L(jl);
end

Lmedn = Ltot/Nj


%% OBTENER LA FUNCION M(x)

M = zeros(Nj,1); 
y = 0;

lbrn = Xj(1,1)
%lbrt = lbrn;

for ll = 1:Nj
    y = y + Xj(ll,1);
    M(ll,1) = y/ll;
end

%% OBTENCION DE LA RPD NUMERICA

[Xn,PHIn] = RPD_Ser_b(Xj,xjmax,lbrn);  %RPD Numerica


%% OBTENCION DE LA RPD TEORICA

pa = polyfit(Xj,M,1);
m = pa(1);
alpha = (2*m-1)/(1-m);

Xt = zeros(Nj,1); 
Mt = zeros(Nj,1);
PHIt = zeros(Nj,1);
PHIts = zeros(Nj,1);

b = (alpha+1)/((c-lbrn)^(alpha+1));
    
for i = 1:Nj
    Mt(i) = pa(1)*Xj(i,1)+pa(2);
    PHIt(i,1) = b*(Xj(i,1)-lbrn)^alpha;
end


%% CALCULO DE LA PROBABILIDAD DE LAS LONGITUDES LAMINARES NUMERICA

[Ln,PHILn] = RPL_Ser(Ls);

Lmax = max(Ls) %Longitud laminar máxima numérica


Mx = Lmax;
PHILt = zeros(Lmax,1);
xe1 = zeros(Lmax,1);
xe = zeros(Lmax,1);
PHILt1 = zeros(Lmax,1);
Lt = zeros(Mx,1);

%Lln = (1/sqrt(aa*eps))*(atan(c*sqrt(aa/eps))-atan(lbrn*sqrt(aa/eps))); %long. laminar para el lbrn
%Lq = (1/sqrt(aa*eps))*(atan(c*sqrt(aa/eps)))

%long. laminar para el lbrn:
Lln = 1+(2*atan((-1+q+2*aa*c)/V)-2*atan((-1+q+2*aa*lbrn)/V))/V
Llt = 1+(2*atan((-1+q+2*aa*c)/V)-2*atan((-1+q+2*aa*lbrt)/V))/V
Llt1 = 1+(1/sqrt(aa*eps))*(atan(c*sqrt(aa/eps))-atan(lbrt*sqrt(aa/eps)))

bt = (alpha+1)/((c-lbrt)^(alpha+1));

for i = 1:Mx
    Lt(i) = i;
    
    xe(i) = (1-q+V*tan(atan((q-1+2*aa*c)/V)-0.5*(i-1)*V))/(2*aa);
    xe1(i) = (sqrt(eps/aa))*tan(atan(c*sqrt(aa/eps))-(i-1)*sqrt(aa*eps));
    
    PHILt(i,1) = (b*(xe(i)-lbrn)^alpha)*abs(eps+(q-1)*xe(i)+aa*xe(i)^2);
    PHILt1(i,1) = (b*(xe1(i)-lbrn)^alpha)*abs(eps+aa*xe1(i)^2);
    
    if xe(i) <= lbrn
       PHILt(i,1) = 0;
    end    
    if xe1(i) <= lbrn
       PHILt1(i,1) = 0;
    end    
end

prol = 0;
prol1 = 0;
proln = 0;

for kh = 1:Lmax
    proln = proln+PHILn(kh,1);
end    

for iu = 1:Mx
    prol = prol+PHILt(iu,1);
    prol1 = prol1+PHILt1(iu,1);    
end    

prol
prol1
proln

PHILta = zeros(Lmax,1);
PHILt1a = zeros(Lmax,1);

icor = 1;

if icor == 1

  PHILt1a = PHILt1/prol1;
%  PHILt1(Mx) = PHILt1(Mx)/(prol1);

  PHILta = PHILt/prol;
%  PHILt(Mx) = PHILt(Mx)/(prol);

  prola = 0;
  prol1a = 0;

  for iu = 1:Mx
      prola = prola+PHILt(iu,1);
      prol1a = prol1a+PHILt1(iu,1);    
  end    

  prola
  prol1a
  proln
  
end  


Lmedt = 0;
Lmedt1 = 0;
Lmedn1 = 0;

An = zeros(Lmax,1);
At = zeros(Lmax,1);
At1 = zeros(Lmax,1);

for kr = 1:Lmax
    An(kr) = Ln(kr)*PHILn(kr);
    At(kr) = Lt(kr)*PHILt(kr);
    At1(kr) = Lt(kr)*PHILt1(kr);
end

Lmedn1 = trapz(Ln,An)
Lmedt = trapz(Lt,At)
Lmedt1 = trapz(Lt,At1)

aLmn = 0;
aLmt = 0;
aLmt1 = 0;

for ix = 1:Lmax
    aLmn = aLmn+Ln(ix)*PHILn(ix);
    aLmt = aLmt+Lt(ix)*PHILt(ix);   
    aLmt1 = aLmt1+Lt(ix)*PHILt1(ix);   
end   

aLmn
aLmt
aLmt1

%pause

%% GRAFICOS

if opplot > 0
    figure(20); hold on;
    plot(Xj,M,'-r');
    plot(Xj,Mt,'-b');
    xlabel('x')
    ylabel('M(x)')
         
    figure(30); hold on;
    plot(Xn,PHIn,'.g'); 
    plot(Xj,PHIt,'-b','Linewidth',0.5);
%    plot(Xt,PHIts,'-r','Linewidth',1.0);
    xlabel('x')
    ylabel('RPD(x)')
    
    figure(40); hold on;
    plot(Ln,PHILn,'.r'); %,'MarkerSize',3);
    plot(Lt,PHILt,'.k'); %,'MarkerSize',3);
    plot(Lt,PHILt1,'.b'); %,'MarkerSize',3);
    xlabel('l')
    ylabel('RPDL(l)')
    
    figure(50); hold on;
    plot(Ln,PHILn,'.r'); %,'MarkerSize',3);
    plot(Lt,PHILta,'.k'); %,'MarkerSize',3);
    plot(Lt,PHILt1a,'.b'); %,'MarkerSize',3);
    xlabel('l')
    ylabel('RPDL(l)')

end

Nint = min([1000,round(max(size(Xj))/10)]);

FMn = zeros(Nj,2);
FMt = zeros(Nj,2);
RPDn = zeros(Nint,2);
RPDt = zeros(Nj,2);
Rey = zeros(Nj,2);
Tar = zeros(Nj,2);
RPDLn = zeros(Lmax,2);
RPDLt = zeros(Lmax,2); 
RPDLt1 = zeros(Lmax,2);
for i = 1:Nj
    FMn(i,1) = Xj(i);
    FMn(i,2) = M(i);
    FMt(i,1) = Xj(i);
    FMt(i,2) = Mt(i);
    Rey(i,1) = xjr(i);
    Rey(i,2) = xj1(i);
%    RPDn(i,1) = Xn(i);
%    RPDn(i,2) = PHIn(i);
    RPDt(i,1) = Xj(i);
    RPDt(i,2) = PHIt(i);
    RPDts(i,1) = Xt(i);
    RPDts(i,2) = PHIts(i);
    Tar(i,1) = Xj(i);
    Tar(i,2) = Ls(i);
end    

for i = 1:Nint
    RPDn(i,1) = Xn(i);
    RPDn(i,2) = PHIn(i); 
end    

for i = 1:Lmax
    RPDLn(i,1) = Ln(i);
    RPDLn(i,2) = PHILn(i); 
    RPDLt(i,1) = Lt(i);
    RPDLt(i,2) = PHILt(i); 
    RPDLt1(i,1) = Lt(i);
    RPDLt1(i,2) = PHILt1(i); 
end

save('Figura_mapa.dat', '-ascii', '-double', 'Fig');
save('Funcion_M_numerica.dat', '-ascii', '-double', 'FMn');
save('Funcion_M_teorica.dat', '-ascii', '-double', 'FMt'); 
save('Funcion_RPD_numerica.dat', '-ascii', '-double', 'RPDn');
save('Funcion_RPD_teorica.dat', '-ascii', '-double', 'RPDt'); 
save('Funcion_RPDs_teorica.dat', '-ascii', '-double', 'RPDts');
save('Funcion_RPDL_numerica.dat', '-ascii', '-double', 'RPDLn');
save('Funcion_RPDL_teorica.dat', '-ascii', '-double', 'RPDLt'); 
save('Funcion_RPDL1_teorica.dat', '-ascii', '-double', 'RPDLt1');
save('Puntos-reinyectados.dat', '-ascii', '-double', 'Rey'); 
save('Long_laminar.dat', '-ascii', '-double', 'Tar'); 
save('Datos.dat', '-ascii', '-double', 'alpha','m','lbrt','lbrn','aa','q','eps','epsr','Nj','c','Lmax'); 
save('Long_medias.dat', '-ascii', '-double', 'Lmedn','Lmedn1','aLmn','Lmedt','aLmt','Lmedt1','aLmt1'); 

disp('Fin programa') 

end
