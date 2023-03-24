function plotfigMapa

datanum  = importdata('Figura_mapa.dat');
%datateor = importdata('Figura_mapa.dat');

filename = 'Mapa_eps=0,00189649.pdf';

Xjnum = datanum(:,1); RPDnum = datanum(:,2);
%Xjteor = datateor(:,1); RPDteor = datateor(:,2);

Xjteor = zeros(100,1);
RPDteor = zeros(100,1);


delta = 1/100;
for i = 1:100
    Xjteor(i) = (i-1)*delta;
    RPDteor(i) = (i-1)*delta;
end

figure;
% Establecer propiedades del papel
[wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1;

lw = 0.5;    % LineWidth
mk = 2.0;    % MarkerSize

xleft = 0; xright = 1;
ydown = 0; yup = 1;

% Realizar los gráficos
axes('Units','centimeters','Position',[xpos ypos wbox hbox]);
    
plot(Xjnum,RPDnum,'.r','MarkerSize',mk); hold on
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
ylabel('$F(x)$','FontSize',fontsize,'FontName',fontname,'Interpreter',interpr)
set(gca,'FontSize',fontsize,'FontName',fontname)

set(gcf, 'renderer', 'painters');

print(gcf, '-dpdf', filename);
