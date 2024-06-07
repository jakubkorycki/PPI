function PlanetaryModel(Delta_bd)

    Delta_bd = 'NA';
    close all;

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
    Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd.gmt'];
    %Model.l1.bound = [HOME '/GSH/Data/MarsCrust/crust1.bd1.gmt'];
    %visual_gmtfile(Model.l1.bound,'km','block');
    Model.l1.dens  = [HOME '/GSH/Data/MercuryCrust/crust_rho.gmt'];
    %Model.l1.dens  = [HOME '/GSH/Data/MarsCrust/crust1.rho1.gmt'];
    %visual_gmtfile(Model.l1.dens,'kg/m3','block');
    % %Model.l1.alpha = 

    % Bath layer
    Model.l2.bound = [HOME '/GSH/Data/MercuryCrust/mantle_bd.gmt'];
    %Model.l2.bound = [HOME '/GSH/Data/MarsCrust/crust1.bd2.gmt'];
    %visual_gmtfile(Model.l2.bound,'km','block');
    %Model.l2.dens  = [HOME '/GSH/Data/MercuryCrust/mantle_rho.gmt'];
    Model.l2.dens  = [HOME '/GSH/Data/MarsCrust/crust1.rho2.gmt'];
    %visual_gmtfile(Model.l2.dens,'kg/m3','block');
    % %Model.l2.alpha = 
    
    % % Bottom
    Model.l3.bound = [HOME '/GSH/Data/MercuryCrust/outercore_rho.gmt'];

    % Alter layer thickness

    file_type = 'block';
    d = load(Model.l1.bound);
    
    if strcmp(file_type,'block')
        [A,Lon,Lat] = gmt2matrix(d);
    elseif strcmp(file_type,'gauss')
        [A,Lon,Lat] = gmt2matrix_gauss(d);
    else
        error('File type must be string: block or gauss')
    end

    if Delta_bd == 'NA'
        Delta_bd = zeros(size(A),'like',A);
    end
    Delta_bd = Delta_bd + 1000; % TEST ONLY

    A_new = A + Delta_bd;
    newbound = matrix2gmt(A_new,Lon,Lat);
    
    % save
    save([HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'],'newbound',"-ascii");
    save([HOME '/GSH/Results/' Model.name '.mat'],'Model');

    % check change
    Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'];
    %Model.l1.bound = [HOME '/GSH/Data/MarsCrust/crust1.bd1.gmt'];
    visual_gmtfile(Model.l1.bound,'km','block');
    
end