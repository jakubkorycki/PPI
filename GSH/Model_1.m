HOME = pwd;
Model = struct();

Model.number_of_layers = 2;
Model.name = 'Model_1';

G = 6.6743e-11;
M_p = 0.330103e24; %+-0.000021e24
R_p = 2439.4e3; %+-0.1

% Additional variables
Model.GM = G*M_p;
Model.Re_analyse = R_p;
Model.Re = R_p;
Model.geoid = 'none';
Model.nmax = 160;     
Model.correct_depth = 0;

% % Topo layer
Model.l1.bound = 'GSH\Data\crust_bd_zero.gmt';
Model.l1.dens  = 2540;
% visual_gmtfile(Model.l1.bound,'km','block');

% Bath layer
Model.l2.bound = 'GSH\Data\Model1\crust_lower_bd_1.gmt';
Model.l2.dens  = 3350;
% visual_gmtfile(Model.l2.bound,'km','block');

% % Bottom
Model.l3.bound  = -100000;
% visual_gmtfile(Model.l3.bound,'km','block');

% Save Model in .mat file for use of the new software

save([HOME '/GSH/Results/' Model.name '.mat'],'Model')