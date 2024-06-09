function [crustal_thickness_1] = InversionM1(D_ref,whether_to_plot,aa,ITR)
    % Load RefModel (which loads PlanetaryModel)
    WTP = whether_to_plot;
    whether_to_plot = false;
    RefModel
    whether_to_plot = WTP;
    
    bouguer_correction = 2*pi*G*rho_crust*topo_map;
%     bouguer_anomaly = gravity_anomaly_map - bouguer_correction;
    free_air_correction = 2*g_ref*topo_map/Model.Re;
    free_air_gravity_anomaly = gravity_anomaly_map + free_air_correction;
    bouguer_anomaly = free_air_gravity_anomaly-bouguer_correction;

    deltaR1 = bouguer_anomaly/(2*pi*G*rho_crust);

    crustal_thickness_1 = (D_ref + deltaR1)/1000;

    gmt1 = matrix2gmt(-crustal_thickness_1./1e3, LonT, LatT);
    filename = [HOME '\Data\Model1\crust_lower_bd_1.gmt'];
    writematrix(gmt1, filename, 'FileType', 'text');
    
    if whether_to_plot
%         % Plot Bouguer Correction
%         figure
%         imagesc(lonT,latT,bouguer_correction*1e5);cc=colorbar;
%         title('Bouguer Correction')
%         xlabel('Longitude (\circ)','Fontsize',aa)
%         ylabel('Latitude (\circ)','Fontsize',aa)
%         ylabel(cc,'Bouguer Correction (mGal)','Fontsize',aa)
%         set(gca,'YDir','normal','Fontsize',aa)
%         
        % Plot Bouguer Anomaly
        figure
        imagesc(lonT,latT,bouguer_anomaly*1e5); cc=colorbar;
        title('Bouguer Anomaly')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Bouguer Anomaly (mGal)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)
        
        % Plot Crustal thickness
        figure
        imagesc(lonT, latT,crustal_thickness_1./1e3); cc=colorbar;
        title(['Model 1: Bouguer Inversion at iteration ' ITR])
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)

    end
end