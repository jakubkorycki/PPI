clear;
close all;
clc;

HOME = pwd;
filename = 'Data/MercuryTopo/MSGR_DEM_USG_SC_I_V02.IMG';
resolution = 64;

% Read in the file.
f = fopen(filename,'r','ieee-be');
el4 = fread(f,[360*resolution Inf],'int16')';
fclose(f); 

%%

latLimT = [-90+(1/resolution/2) 90-(1/resolution/2) 1/resolution]; 
lonLimT = [1/resolution/2  360-(1/resolution/2) 1/resolution]; 

lonT = lonLimT(1):lonLimT(3):lonLimT(2);
latT = fliplr(latLimT(1):latLimT(3):latLimT(2));
LonT = repmat(lonT,length(latT),1);
LatT = repmat(latT',1,length(lonT));

%load('vik.mat')
cmap = colormap("turbo");
aa = 18;

figure
imagesc(lonT,latT,el4./1e3);cc=colorbar;colormap(cmap);
xlabel('Longitude (\circ)','Fontsize',aa)
ylabel('Latitude (\circ)','Fontsize',aa)
ylabel(cc,'topography (km)','Fontsize',aa)
set(gca,'YDir','normal','Fontsize',aa)
title("Digital Elevation Map (DEM), USGS global 665m v2");

