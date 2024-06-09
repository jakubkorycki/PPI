Model = struct();

% SETUP MODEL FOR MERCURY
Model.number_of_layers = 2;
Model.name = 'Mercury_Crust_2L';

% Additional variables
G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1 As defined for topography map

R_ref_grav = 2440e3; % As defined in spherical gravity file
g_ref = G*M_p/(R_ref_grav)^2;

% Define densities
rho_crust = 3103.89205;
rho_mantle = 3239.352643;

Model.GM = G * M_p;
Model.Re_analyse = R_p;
Model.Re = R_p;
Model.geoid = 'none';
Model.nmax = 160; 
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

% Crust layer
Model.l1.bound = [HOME '/Data/MercuryCrust/crust_bd.gmt'];
Model.l1.dens  = [HOME '/Data/MercuryCrust/crust_rho.gmt'];
% Model.l1.dens = rho_crust./1e3;
%visual_gmtfile(Model.l1.bound,'km','block');

% Mantle layer
Model.l2.bound = [HOME '/Data/MercuryCrust/mantle_bd.gmt'];
Model.l2.dens  = [HOME '/Data/MercuryCrust/mantle_rho.gmt'];
% Model.l2.dens = rho_mantle./1e3;
%visual_gmtfile(Model.l2.bound,'km','block');

% % Bottom
Model.l3.bound = [HOME '/Data/MercuryCrust/outercore_rho.gmt'];

% make gmt bound editable
d = load(Model.l2.bound);
[A,Lon,Lat] = gmt2matrix(d);
