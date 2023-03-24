function plotfigFloquet

%datanum  = importdata('Variables_funcion-del-tiempo_1.txt');
datateor = importdata('Floquet.txt');

filename = 'Atractor1_Floquet.pdf';

%Xjnum = datanum(:,1); RPDnum = datanum(:,2);
FmE1 = datateor(:,1); 
FmE2 = datateor(:,2);
FmE3 = datateor(:,3);
FmE4 = datateor(:,4);
FmE5 = datateor(:,5);
FmE6 = datateor(:,6);
FmE7 = datateor(:,7);

figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.75;    % LineWidth
mk = 3.0;    % MarkerSize

xleft = -0.00005; xright = 0.005;
ydown = -0.00000000000000000001; yup = 0.00000000000000000001;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
%plot(Xjnum,RPDnum,'.r','MarkerSize',mk); hold on
%plot(Xjteor,RPDteor,'-b','LineWidth',lw); hold on;

%plot(cos([0:0.01:2*pi]),sin([0:0.01:2*pi]),'k')
hold on
plot(FmE2,FmE3,'.b','MarkerSize',4)
hold on
plot(FmE4,FmE5,'.r','MarkerSize',4)   
hold on
plot(FmE6,FmE7,'.g','MarkerSize',4)  
hold on
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$\delta_r$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$\delta_i$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
