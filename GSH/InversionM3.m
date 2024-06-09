function [crustal_thickness_3] = InversionM3(D_ref, Te,whether_to_plot,aa)
    % Load RefModel (which loads PlanetaryModel)
    RefModel
    crustal_thickness_2 = InversionM2(D_ref,whether_to_plot,aa);
    
    cs3 = GSHA(topo_map, L);
    sc3 =  cs2sc(cs3);
    n = 1:size(sc3,1);
    
    D = 200e9*(Te)^3/(12*(1-0.5^2));
    PHI = (1 + D/(500*2/g_ref).*(2.*(n+1)./(2*Model.Re)).^4).^(-1);
    
    sc_flex = zeros(size(sc3));
    for m = 1:size(sc3,2)
        sc_flex(:,m) = sc3(:,m).*PHI';
    end

    mapf = GSHS(sc_flex,lonT,90-latT,L);
    crustal_thickness_3 = crustal_thickness_2 - mapf;

    gmt3 = matrix2gmt(-crustal_thickness_3./1e3, LonT, LatT);
    filename = [HOME '\Data\Model3\crust_lower_bd_3.gmt'];
    writematrix(gmt3, filename, 'FileType', 'text');

    if whether_to_plot
        % Plot Airy model crustal thickness
        figure
        imagesc(lonT, latT, crustal_thickness_3./1e3); cc=colorbar;
        title('Model 3: Airy Isostasy with Flexure Correction')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)       
    end
end