HOME = pwd;
Model = struct();

Model.number_of_layers = 2;
Model.name = 'Earth_Crust_Test';

% Additional variables
Model.GM = 3.9860004415E14;
Model.Re_analyse = 6378136.30;
Model.Re = 6378136.30;
Model.geoid = 'none';
Model.nmax = 179;     
Model.correct_depth = 0;

% % Topo layer
Model.l1.bound = [HOME '/GSH/Data/MarsCrust/crust1.bd1.gmt'];
Model.l1.dens  = [HOME '/GSH/Data/MarsCrust/crust1.rho1.gmt'];
visual_gmtfile(Model.l1.bound,'km','block');
% %Model.l1.alpha = 

% Bath layer
Model.l2.bound = [HOME '/GSH/Data/MarsCrust/crust1.bd2.gmt'];
Model.l2.dens  = [HOME '/GSH/Data/MarsCrust/crust1.rho2.gmt'];
visual_gmtfile(Model.l2.bound,'km','block');
% %Model.l2.alpha = 

% % Bottom
Model.l3.bound  = [HOME '/GSH/Data/MarsCrust/crust1.bd3.gmt'];
visual_gmtfile(Model.l3.bound,'km','block');

% Save model in .mat file for use of the new software

save([HOME '/GSH/Results/' Model.name '.mat'],'Model')