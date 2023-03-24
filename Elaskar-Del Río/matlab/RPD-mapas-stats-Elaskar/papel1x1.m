function [wp,hp,xpos,ypos,wbox,hbox,fontsize,fontname,interpr] = papel1x1

% Establecer las propiedades del papel para graficar

    
wp = 8.0 ; hp = 5.5;        % Dimensiones del papel: wp ancho, hp alto
xpos = 1.5; ypos = 1.0;     % Posición del box
wbox = 6.0; hbox = 4.0;     % Dimensiones del box

fontsize = 9;
fontname = 'Times';
interpr  = 'latex';


set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [wp hp]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 wp hp]);
