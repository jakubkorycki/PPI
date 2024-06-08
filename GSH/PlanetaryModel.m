HOME = pwd;
Model = struct();

ModelFit_bd = 0; % TEST ONLY

% SETUP MODEL FOR MERCURY
Model.number_of_layers = 2;
Model.name = 'Mercury_Crust_2L';

% Additional variables
G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1

R_ref = R_p;
M_mercury = M_p;
g_ref = G*M_mercury/R_ref^2;

rho_crust = 3103.89205;
rho_mantle = 3239.352643;

Model.GM = G * M_p;
Model.Re_analyse = R_p;
Model.Re = R_p;
Model.geoid = 'none';
Model.nmax = 160; %160
Model.correct_depth = 0;

% Create lat/lon grid
resolution = 1;
latLimT = [-90+(1/resolution/2) 90-(1/resolution/2) 1/resolution];
lonLimT = [1/resolution/2  360-(1/resolution/2) 1/resolution];
% lonLimT = [-180+1/resolution/2  180-(1/resolution/2) 1/resolution];

lonT = lonLimT(1):lonLimT(3):lonLimT(2);
latT = fliplr(latLimT(1):latLimT(3):latLimT(2));
LonT = repmat(lonT,length(latT),1);
LatT = repmat(latT',1,length(lonT));

% Read Gravity Spherical Harmonics
SC_data = readmatrix('cleaned_gsh.csv', OutputType='double');

L = max(SC_data(:,1));
clm = SC_data(:, 1:4);
clm = [0 0 0 0; clm];

[n, DV] = degreeVariance(clm);
figure
semilogy(DV)


% Convert to /S|C\ Triangle format
sc = clm2sc(clm);

% Plot gravitational potential
gravity_map_norm = GSHS(sc, lonT, 90-latT, 160);

gravity_map = (1+gravity_map_norm) * g_ref;

gravity_anomaly_map = gravity_map_norm * g_ref;

figure
imagesc(lonT,latT,gravity_map);cc=colorbar;
title('Gravity')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Gravitational acceleration (m/s^2)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% figure
% axesm('mollweid', 'Frame', 'off', 'Grid', 'off', 'MeridianLabel', 'off', 'ParallelLabel', 'off')
% % setm(gca, 'MLabelParallel', 3)
% geoshow(LatT, LonT, gravity_anomaly_map, 'DisplayType', 'surface')
% title('Gravity Anomaly w.r.t. Geoid')
% colorbar;
% xlabel('Longitude (\circ)')
% ylabel('Latitude (\circ)')
% ylabel(cc,'Gravitational acceleration (m/s^2)')
% set(gca, 'YDir', 'normal')

figure
imagesc(lonT,latT,gravity_anomaly_map*1e5);cc=colorbar;
title('Gravity Anomaly w.r.t. g_0')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Gravitational acceleration (mGal)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% light
% material(0.6*[1 1 1])
% axis normal
% view(3)

% IMPORT AND VERIFY
% % Topo layer
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd.gmt'];
Model.l1.dens  = [HOME '/GSH/Data/MercuryCrust/crust_rho.gmt'];
% %Model.l1.alpha = 
%visual_gmtfile(Model.l1.bound,'km','block');

% Bath layer
Model.l2.bound = [HOME '/GSH/Data/MercuryCrust/mantle_bd.gmt'];
Model.l2.dens  = [HOME '/GSH/Data/MercuryCrust/mantle_rho.gmt'];
% %Model.l2.alpha = 
%visual_gmtfile(Model.l2.bound,'km','block');

% % Bottom
Model.l3.bound = [HOME '/GSH/Data/MercuryCrust/outercore_rho.gmt'];

