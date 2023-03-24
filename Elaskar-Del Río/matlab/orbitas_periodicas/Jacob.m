function Jnum = Jacob(funcion,t,X,dh)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Programa perteneciente al libro "Mec�nica Anal�tica: lagrangiana, hamiltoniana y sistemas din�micos" %%
%% Autores  -> Javier Sanz Recio y Gonzalo S�nchez Arriaga                                              %%
%% Nombre   -> Jacob.m                                                                                  %%
%% Objetivo -> C�lculo de la matriz jacobiana num�ricamente                                             %%
%% Entradas -> funcion(t,x): campo vectorial                                                            %%
%%          -> t:            instante temporal                                                          %%
%%          -> X:            vector de estado                                                           %%
%%          -> dh:           incremento en las f�rmulas de diferencias finitas                          %% 
%% Salidas  -> Jnum:         Aproximaci�n de la matriz jacobiana                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:1:length(X) % Bucle para recorrer las columnas de la matrix
    
    % Funcion en X(i)+dh
    XM    = X;
    XM(i) = XM(i)+dh;
    fM    = feval(funcion,t,XM);
    
    %% Funcion en X(i)-dh
    Xm    = X;
    Xm(i) = Xm(i)-dh;
    fm    = feval(funcion,t,Xm);
    
    %% Columna de la matriz jacobiana
    Jnum(:,i)=(fM-fm)/(2*dh);    
end

