function Comparacion_Poincare_z

%datanum  = importdata('Poincare_z_r=166,5-lineal.dat');
datateor = importdata('Poincare_z_r=166,5-cuadratica.dat');
dataprox = importdata('Poincare_z_r=166,5-Henon.dat');

filename = 'Comparacion_Poincare_z-r=166,5.pdf';

%Xjnum = datanum(:,1); RPDnum = datanum(:,2);
Xjteor = datateor(:,1); RPDteor = datateor(:,2);
Xjprox = dataprox(:,1); RPDprox = dataprox(:,2);

figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk1 = 5.0;    % MarkerSize
mk2 = 4.0;
mk3 = 2.0;

xleft = 100; xright = 165;
ydown = 100; yup = 165;

for li = 100:165    
    rex(li) = li;
    rey(li) = li;
end 

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
%plot(Xjnum,RPDnum,'.g','MarkerSize',mk1); hold on
plot(Xjteor,RPDteor,'.r','MarkerSize',mk2); hold on;
plot(Xjprox,RPDprox,'.b','MarkerSize',mk2); hold on;
plot(rex,rey,'-k','LineWidth',lw); hold on
 
% Propiedades del gráfico
set(gca,'XLimMode','manual'); set(gca,'YLimMode','manual')
set(gca,'XLim',[xleft xright])
set(gca,'YLim',[ydown yup])

%set(gca,'XTick',[xjmin yjmin Xj(Nj)])
%set(gca,'YTick',[M(1)])

%SetXTickLabel('$x_l$||$F\left(x_l\right)$||$x_l + 2c$')
%SetYTickLabel('$x_l$')

xlabel('$z(i)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
ylabel('$z(i+1)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
