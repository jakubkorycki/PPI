function [crustal_thickness_3] = InversionM3(D_ref, Te,whether_to_plot,aa,ITR)
    % Load RefModel (which loads PlanetaryModel)
    WTP = whether_to_plot;
    whether_to_plot = false;
    RefModel
    
    crustal_thickness_2 = InversionM2(D_ref,whether_to_plot,aa,ITR)/1000;

    whether_to_plot = WTP;
    

%     cs3 = GSHA(topo_map, L);

    root = rho_crust/(rho_mantle-rho_crust)*topo_map;
    
    cs3 = GSHA(root, L);
    sc3 =  cs2sc(cs3);
    n = 1:size(sc3,1);
    
%     D = 200e9*(Te)^3/(12*(1-0.5^2));
    D = 200e9*(Te)^3/(12*(1-0.5^2));
    PHI = (1 + D/((rho_mantle-rho_crust)*g_ref).*((2.*n+1)./(2*Model.Re)).^4).^(-1);
%     PHI = (1 + D.*n.^4/((rho_mantle-rho_crust)*g_ref)).^(-1);
    sc_flex = zeros(size(sc3));
    for m = 1:size(sc3,2)
        sc_flex(:,m) = sc3(:,m).*PHI';
    end

    mapf = GSHS(sc_flex,lonT,90-latT,L);
    crustal_thickness_3 = (mapf+D_ref)/1e3;

    gmt3 = matrix2gmt(-crustal_thickness_3./1e3, LonT, LatT);
    filename = [HOME '\Data\Model3\crust_lower_bd_3.gmt'];
    writematrix(gmt3, filename, 'FileType', 'text');

    if whether_to_plot
        % Plot Airy model crustal thickness
        figure
        imagesc(lonT, latT, crustal_thickness_3); cc=colorbar;
        title(['Model 3: Airy Isostasy with Flexure Correction at iteration ' num2str(ITR)])
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)       
    end
end