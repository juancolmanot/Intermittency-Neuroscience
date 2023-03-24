function [wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1

% Establecer las propiedades del papel para graficar

    
wp = 15.0 ; hp = 10.5;        % Dimensiones del papel: wp ancho, hp alto
xpos = 2.2; ypos = 2.;     % Posición del box
wbox = 12.; hbox = 8.5;     % Dimensiones del box

fontsize = 11;
fontname = 'Times';
interpr  = 'latex';


set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [wp hp]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 wp hp]);
