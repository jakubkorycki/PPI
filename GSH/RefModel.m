addpath('GSH\Tools\')
addpath('data\')

HOME = pwd;

% Mercury Data
G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1

% Crust Data
rho_crust = 3100;
rho_mantle = 3307.6;
D_ref = 125e3; % Reference crustal thickness in meters

% others
R_ref = R_p;
M_mercury = M_p;
g_ref = G*M_mercury/R_ref^2;

% Create lat/lon grid
resolution = 10;
latLimT = [-90+(1/resolution/2) 90-(1/resolution/2) 1/resolution];
lonLimT = [1/resolution/2  360-(1/resolution/2) 1/resolution];
% lonLimT = [-180+1/resolution/2  180-(1/resolution/2) 1/resolution];

lonT = lonLimT(1):lonLimT(3):lonLimT(2);
latT = fliplr(latLimT(1):latLimT(3):latLimT(2));
LonT = repmat(lonT,length(latT),1);
LatT = repmat(latT',1,length(lonT));

% Read Gravity Spherical Harmonics
SC_data = readmatrix([HOME '/GSH/Data/MercuryGrav/data.csv'], OutputType='double');
L = Model.nmax;
clm = SC_data(:, 1:4);
V_ref = sortrows([0 0 1 0; clm],1);

% Convert to /S|C\ Triangle format
sc = clm2sc(clm);

% Plot gravitational potential
gravity_map_norm = GSHS(sc, lonT, 90-latT, 160);
gravity_map = (1+gravity_map_norm) * G*M_mercury/(R_ref^2);
gravity_anomaly_map = gravity_map_norm * G*M_mercury/(R_ref^2);

aa=12;
figure
imagesc(lonT,latT,gravity_map);cc=colorbar;
title('Gravity')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Gravitational acceleration (m/s^2)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

figure
axesm('mollweid', 'Frame', 'on', 'Grid', 'on', 'MeridianLabel', 'on', 'ParallelLabel', 'on')
setm(gca, 'MLabelParallel', 3)
geoshow(LatT, LonT, gravity_anomaly_map, 'DisplayType', 'surface')
title('Gravity Anomaly w.r.t. Geoid')
colorbar;
xlabel('Longitude (\circ)')
ylabel('Latitude (\circ)')
set(gca, 'YDir', 'normal')

% Load topography
filename = [HOME '/GSH/Data/MercuryTopo/Mercury_Messenger_USGS_DEM_Global_665m_v2.tif'];
topo_map = imread(filename);
resized_topo_map = imresize(topo_map, [size(gravity_map, 1), size(gravity_map, 2)]);
resized_topo_map = double(resized_topo_map);

% Plot topography
figure
imagesc(lonT,latT,resized_topo_map./1e3);cc=colorbar;
title('Topography')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Topography (km)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)

% Calculate Bouguer anomaly
bouguer_correction = 2*pi*G*rho_crust*resized_topo_map;
bouguer_anomaly = -(gravity_anomaly_map - bouguer_correction);

% Plot Bouguer anomaly
figure
imagesc(lonT,latT,bouguer_anomaly);cc=colorbar;
title('Bouguer Anomaly')
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'Bouguer Anomaly (m/s^2)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)