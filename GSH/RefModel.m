HOME = pwd;

% Load Model, constants and grid from PlanetaryModel.m
PlanetaryModel

% Read Gravity Spherical Harmonics
SC_data = readmatrix([HOME '/Data/MercuryGrav/cleaned_gsh.csv'], OutputType='double');
L = Model.nmax;
clm = SC_data(:, 1:4);
V_ref = sortrows([0 0 1 0; clm],1);

% Convert to /S|C\ Triangle format
sc = clm2sc(clm);

% Calculate gravitational acceleration
gravity_map_norm = GSHS(sc, lonT, 90-latT, L);
gravity_map = (1+gravity_map_norm) * g_ref;
gravity_anomaly_map = gravity_map_norm * g_ref;

% Load topography (rename your .tif file to mercurytopo.tif for ease of use)
filename = [HOME '/Data/MercuryTopo/mercurytopo.tif'];
topo_map = imread(filename);

% Resize first for speed
topo_map = imresize(topo_map, [length(latT), length(lonT)]);
topo_map = double(topo_map);

if exist('whether_to_plot')
    if whether_to_plot
        % Plot gravitational acceleration and anomaly
        figure
        imagesc(lonT,latT,gravity_map);cc=colorbar;
        title('Gravity')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Gravitational acceleration (m/s^2)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)
        
        figure
        imagesc(lonT,latT,gravity_anomaly_map*1e5);cc=colorbar;
        title('Gravity Anomaly w.r.t. g_0')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Gravitational acceleration (mGal)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)
        
        % Plot topography
        figure
        imagesc(lonT,latT,topo_map./1e3);cc=colorbar;
        topolims = [min(topo_map./1e3) max(topo_map./1e3)];
        demcmap(topolims);
        title('Topography')
        xlabel('Longitude (\circ)','Fontsize',aa)
        ylabel('Latitude (\circ)','Fontsize',aa)
        ylabel(cc,'Topography (km)','Fontsize',aa)
        set(gca,'YDir','normal','Fontsize',aa)
    end
   
end
