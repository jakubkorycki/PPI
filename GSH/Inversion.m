% Model 1: Bouguer Inversion
D_ref = 35e3; % Reference crustal thickness in meters
deltaR1 = bouguer_anomaly/(2*pi*G*rho_crust);
crustal_thickness_model1 = D_ref + deltaR1;

figure
imagesc(lonT, latT, crustal_thickness_model1./1e3); cc=colorbar;
title('Model 1: Bouguer Inversion')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% Model 2: Airy Isostasy
rho_mantle = 3350;
deltaR2 = resized_topo_map * rho_crust / (rho_mantle - rho_crust);
crustal_thickness_model2 = D_ref + deltaR2;

figure
imagesc(lonT, latT, crustal_thickness_model2./1e3); cc=colorbar;
title('Model 2: Airy Isostasy')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Crustal thickness (km)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% Flexure Model
cs3 = GSHA(resized_topo_map, 160);
sc3 = cs2sc(cs3);
Te_ref = 31e3; % Reference elastic thickness in meters
n = 1:size(sc,1);

D = 200e9 * (Te_ref)^3 / (12 * (1 - 0.5^2));
PHI = (1 + D / (500 * 2 / g_ref) .* (2 .* (n + 1) / (2 * R_ref)).^4).^-1;

sc_flex = zeros(size(sc3));
for m = 1:size(sc3,2)
    sc_flex(:,m) = sc3(:,m) .* PHI';
end

mapf = GSHS(sc_flex, lonT, 90-latT, 160);

figure
imagesc(lonT, latT, mapf); cc=colorbar;
title('Flexure Model Correction')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Flexure Correction (units?)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

figure
imagesc(lonT, latT, (resized_topo_map - mapf)./1e3); cc=colorbar;
title('Topography with Flexure Correction Subtracted')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Topography (km)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% Cross-section at middle latitude
middle_lat_index = round(length(latT) / 2);

figure
plot(lonT, crustal_thickness_model1(middle_lat_index, :) ./ 1e3, 'r', 'DisplayName', 'Bouguer Inversion');
hold on;
plot(lonT, crustal_thickness_model2(middle_lat_index, :) ./ 1e3, 'g', 'DisplayName', 'Airy Isostasy');
plot(lonT, (D_ref + resized_topo_map(middle_lat_index, :) * rho_crust / (rho_mantle - rho_crust)) ./ 1e3, 'b', 'DisplayName', 'Topography with Flexure');
hold off;
title('Cross-section of Crustal Thickness at Middle Latitude')
xlabel('Longitude (\circ)')
ylabel('Crustal Thickness (km)')
legend
grid on
set(gca, 'Fontsize', aa)