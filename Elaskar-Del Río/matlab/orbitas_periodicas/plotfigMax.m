function plotfigMax

datanum  = importdata('Lambda_max-solo.txt');
datateor = importdata('A_max-solo.txt');
dataser  = importdata('Lambda_min-solo.txt');
dataine = importdata('A_min-solo.txt');

filename = 'Atractor1_maximos-minimos.pdf';

Xjnum = datanum(:,1); RPDnum = datanum(:,2);
Xjteor = datateor(:,1); RPDteor = datateor(:,2);
Xjser = dataser(:,1); RPDser = dataser(:,2);
Xjine = dataine(:,1); RPDine = dataine(:,2);

figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.75;    % LineWidth
mk = 3.0;    % MarkerSize

xleft = 5; xright = 30;
ydown = -4; yup = 4;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
plot(Xjnum,RPDnum,'-r','LineWidth',lw); hold on
plot(Xjteor,RPDteor,'-b','LineWidth',lw); hold on;
plot(Xjser,RPDser,'-r','LineWidth',lw); hold on
plot(Xjine,RPDine,'-b','LineWidth',lw); hold on
    
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$a_0$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$a_{max-min} \, \lambda_{max-min}$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
