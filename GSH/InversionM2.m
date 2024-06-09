function [CM_interface] = InversionM2(D_ref,whether_to_plot,aa)
    % Load RefModel (which loads PlanetaryModel)
    WTP = whether_to_plot;
    whether_to_plot = false;
    RefModel
    Model.D_c = D_ref;
    whether_to_plot = WTP;
    
    [CM_interface, lon_CM, lat_CM] = topo2crust(topo_map, Model.nmax,'Airy', Model);
%     deltaR2 = topo_map*rho_crust/(rho_mantle-rho_crust)/1000;
%     crustal_thickness_2 = topo_map + D_ref + deltaR2;    
% 
%     gmt2 = matrix2gmt(-CM_interface./1e3, LonT, LatT);
%     filename = [HOME '\Data\Model2\crust_lower_bd_2.gmt'];
%     writematrix(gmt2, filename, 'FileType', 'text');

    if whether_to_plot
        % Plot Airy model crustal thickness
        figure
        imagesc(lon_CM, lat_CM, CM_interface./1e3); cc=colorbar;
        title('Model 2: Airy Isostasy')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)       
    end
end