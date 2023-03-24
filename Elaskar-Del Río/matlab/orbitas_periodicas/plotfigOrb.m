function plotfigOrb

%datanum  = importdata('Variables_funcion-del-tiempo_1.txt');
datateor = importdata('Orbita_periodica.txt');

filename = 'Orbita_periodo-3_Xi=-0,5_0,64_eps=0,22-gamma=0,3-omega=1.pdf';

%Xjnum = datanum(:,1); RPDnum = datanum(:,2);
Xjteor = datateor(:,1); RPDteor = datateor(:,2);


figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.75;    % LineWidth
mk = 3.0;    % MarkerSize

xleft = -2; xright = 2;
ydown = -2; yup = 2;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
%plot(Xjnum,RPDnum,'.r','MarkerSize',mk); hold on
plot(Xjteor,RPDteor,'-b','LineWidth',lw); hold on;
    
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$x$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$y$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
