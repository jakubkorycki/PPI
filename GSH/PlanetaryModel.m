HOME = pwd;
Model = struct();

ModelFit_bd = 0; % TEST ONLY

% SETUP MODEL FOR MERCURY
Model.number_of_layers = 2;
Model.name = 'Mercury_Crust_2L';
delta_bd = 1000;

% Additional variables
G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1

Model.GM = G * M_p;
Model.Re_analyse = R_p;
Model.Re = R_p;
Model.geoid = 'none';
Model.nmax = 160; %160
Model.correct_depth = 0;

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

resized_topo_map = imresize(topo_map, [size(gravity_map, 1)/10, size(gravity_map, 2)/10]);
resized_topo_map = double(resized_topo_map);

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

% MODIFY BOUNDARY HEIGHT
% file structure
file_type = 'block';
d = load(Model.l1.bound);

% make gmt editable
if strcmp(file_type,'block')
    [A,Lon,Lat] = gmt2matrix(d);
elseif strcmp(file_type,'gauss')
    [A,Lon,Lat] = gmt2matrix_gauss(d);
else
    error('File type must be string: block or gauss')
end
% create delta vector from scalar
%Delta_bd = zeros(size(A),'like',A) + delta_bd;

% create test layers for +- delta
%bound_low = matrix2gmt(A - Delta_bd,Lon,Lat);
%bound_high = matrix2gmt(A + Delta_bd,Lon,Lat);

% update layer with new fit
%if exist('ModelFit_bd','var') % handle initial case
%    bound_new = matrix2gmt(A,Lon,Lat);
%else
%    bound_new = matrix2gmt(A + ModelFit_bd,Lon,Lat);
%end

bound_new = matrix2gmt(A + resized_topo_map,Lon,Lat);

% save
%save([HOME '/GSH/Data/MercuryCrust/crust_bd_low.gmt'],'bound_low',"-ascii");
%save([HOME '/GSH/Data/MercuryCrust/crust_bd_high.gmt'],'bound_high',"-ascii");
save([HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'],'bound_new',"-ascii");

% check change
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'];
save([HOME '/GSH/Results/' Model.name '_new.mat'],'Model');
visual_gmtfile(Model.l1.bound,'km','block');