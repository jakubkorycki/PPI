% This is an input file for the GSHA procedure
%
% It should contain a list of names and location of geometry boundaries followed by a
% list of names for density values
% 
% Single values for density files are allowed.
HOME = pwd;
Model = struct();

Model.number_of_layers = 2;
Model.name = 'Mercury_Crust_2L';

% Additional variables
G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1

Model.GM = G * M_p;
Model.Re_analyse = R_p;
Model.Re = R_p;
Model.geoid = 'none';
Model.nmax = 49;     
Model.correct_depth = 0;

% % Topo layer
Model.l1.bound = [HOME 'GSH/Data/MercuryCrust/crust_bd.gmt'];
Model.l1.dens  = [HOME 'GSH/Data/MercuryCrust/crust_rho.gmt'];
% %Model.l1.alpha = 

% Bath layer
Model.l2.bound = [HOME 'GSH/Data/MercuryCrust/mantle_bd.gmt'];
Model.l2.dens  = [HOME 'GSH/Data/MercuryCrust/mantle_rho.gmt'];
% %Model.l2.alpha = 

% % Bottom
Model.l3.bound = [HOME 'GSH/Data/MercuryCrust/outercore_rho.gmt'];

% Save model in .mat file for use of the new software

save([HOME '/GSH/Results/' Model.name '.mat'],'Model')