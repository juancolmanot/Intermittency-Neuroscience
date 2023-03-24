function [wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x2

% Establecer las propiedades del papel para graficar

    
wp = 18.0 ; hp = 14;        % Dimensiones del papel: wp ancho, hp alto
xpos = 2.0; ypos = 1.5;     % Posición del box
wbox = 12.0; hbox = 08;     % Dimensiones del box

fontsize = 13;
fontname = 'Times';
interpr  = 'latex';


set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [wp hp]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 wp hp]);