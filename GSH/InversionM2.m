function [crustal_thickness_2] = InversionM2(D_ref,whether_to_plot,aa,ITR)
    % Load RefModel (which loads PlanetaryModel)
    WTP = whether_to_plot;
    whether_to_plot = false;
    RefModel
    whether_to_plot = WTP;
    
    deltaR2 = topo_map*rho_crust/(rho_mantle-rho_crust)/1000;
    crustal_thickness_2 = (topo_map + D_ref + deltaR2)/1000;    

    gmt2 = matrix2gmt(-crustal_thickness_2./1e3, LonT, LatT);
    filename = [HOME '\Data\Model2\crust_lower_bd_2.gmt'];
    writematrix(gmt2, filename, 'FileType', 'text');

    if whether_to_plot
        % Plot Airy model crustal thickness
        figure
        imagesc(lonT, latT, crustal_thickness_2./1e3); cc=colorbar;
        title(['Model 2: Airy Isostasy at iteration', num2str(ITR)])
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)       
    end
end