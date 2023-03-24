function plotfigL

datanum  = importdata('Long_laminar.dat');
%datateor = importdata('Funcion_M_teorica.dat');

filename = 'Long_laminar.pdf';

Xjnum = datanum(:,1); RPDnum = datanum(:,2);
%Xjteor = datateor(:,1); RPDteor = datateor(:,2);

Mv = 100;
Ll1 = zeros(Mv,1);
Ll2 = zeros(Mv,1);
xg = zeros(Mv,1);

lbrt = -0.005151124514407322;
c = 0.02;
eps = 0.00500217;
q = 0.932021;
aa = 88.1427;

V = sqrt(4*aa*eps-(q-1)^2);

for k = 1:Mv
     xg(k) = lbrt + (k-1)*(c-lbrt)/Mv;
     Ll1(k) = (2/V)*(atan((-1+q+2*aa*c)/V)-atan((-1+q+2*aa*xg(k))/V));
     Ll2(k) = (1/sqrt(aa*eps))*(atan(c*sqrt(aa/eps))-atan(xg(k)*sqrt(aa/eps)));
end    

figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk = 2.0;    % MarkerSize

xleft = lbrt; xright = c;
ydown = 0.0; yup = 3;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
plot(Xjnum,RPDnum,'.r','MarkerSize',mk); hold on
plot(xg,Ll1,'.b','MarkerSize',mk); hold on;   
plot(xg,Ll2,'.g','MarkerSize',mk); hold on;   
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$x_{i-1}$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$x_i$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
