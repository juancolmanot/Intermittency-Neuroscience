function ver_atractor_final(ti,X_Periodica)
                
     figure(1)
     plot(ti,X_Periodica(:,1),'r.','MarkerSize',1)
     xlabel('t')
     ylabel('lambda')
     hold on
     
     figure(2)
     plot(ti,X_Periodica(:,2),'r.','MarkerSize',1)
     xlabel('t')
     ylabel('lambdap')
     hold on
     
     figure(3)
     plot(ti,X_Periodica(:,3),'r.','MarkerSize',1)
     xlabel('t')
     ylabel('as')
     hold on
          
     figure(4)
     plot(X_Periodica(:,2),X_Periodica(:,1),'r.','MarkerSize',1)
     xlabel('lambdap')
     ylabel('lambda')
     hold on
     
     figure(5)
     plot(X_Periodica(:,3),X_Periodica(:,1),'r.','MarkerSize',1)
     xlabel('as')
     ylabel('lambda')
     hold on
     
     figure(101)
     plot3(X_Periodica(:,1),X_Periodica(:,2),X_Periodica(:,3),'r.','MarkerSize',1)
     xlabel('lambda')
     ylabel('lambdap')
     zlabel('as')
     hold on    
             
end


