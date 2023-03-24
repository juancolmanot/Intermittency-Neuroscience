function plotfigRPL

datanum  = importdata('Funcion_RPDL_numerica.dat');
datateor = importdata('Funcion_RPDL_teorica.dat');
datateors = importdata('Funcion_RPDL1_teorica.dat');

filename = 'RPDL.pdf';

Xjnum = datanum(:,1); RPDnum = datanum(:,2);
Xjteor = datateor(:,1); RPDteor = datateor(:,2);
Xjteors = datateors(:,1); RPDteors = datateors(:,2);


figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk = 3.0;    % MarkerSize

xleft = 0; xright = 15;
ydown = 0; yup = 0.4;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
plot(Xjnum,RPDnum,'.r','MarkerSize',mk); hold on
plot(Xjteor,RPDteor,'.b','MarkerSize',mk); hold on;
plot(Xjteors,RPDteors,'.g','MarkerSize',mk); hold on;
   
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$l$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$\psi\left(l\right)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
