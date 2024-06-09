clear;
close all;
clc;

addpath('\Tools\')
HOME = pwd;

%% iteration setup
% plot parameters
aa=24;
whether_to_plot = false;

% numerical parameters
Dr = 10e3; % km
ITRmax = 0;
ModelMax = 3;

% variables
crust_Te = 54.7e3; %range [20e3,229.5]; % elastic thickness [km]
crustTc = 43.1e3; %range [12.5e3,162.5e3]; % mean crustal thickness [km]

%% create baseline planetary model
%% import gravity and topography model
% load spherical gravity harmonics and digital elevation model according to
% model grid
RefModel

%% parameter optimisation
Model = 1;
while Model<ModelMax+1
    % model setup
    if Model==1
        VAR = crustTc;
    elseif Model ==2
        VAR = crustTc;
    else
        VAR = crust_Te;
    end

    % fitting for model X
    ITR = 0;
    while(ITR<ITRmax+1)
        % loop setup 
        Phi_der = 0; % derivative of variable wrt objective function
        Phi_test = [
            VAR, VAR-Dr, VAR+Dr
        ];
        Phi_result = [];

        % test model for each variable
        for test=1:length(Phi_test)
            disp(['Model ', num2str(Model), ' - ITR ', num2str(ITR), ' - test', num2str(test)]);
            % model crustal inversion
            if Model==1
                Dref = VAR;
                DT = InversionM1(Dref,whether_to_plot,aa);
            elseif Model ==2
                % Dref = VAR; unchanged from M1
                DT = InversionM2(Dref,whether_to_plot,aa);
            else
                Te = VAR;
                DT = InversionM3(Dref, Te,whether_to_plot,aa);
            end

            % alter boundary gmt
            %bound_M1 = matrix2gmt(A + crustal_thickness_model1,Lon,Lat);
            %save([HOME '/GSH/Data/MercuryCrust/crust_bd_M1.gmt'],'bound_M1',"-ascii");
            %M1 = Model;
            %M1.l2.bound = [HOME '/GSH/Data/MercuryCrust/mantle_bd_M1.gmt'];
            %save([HOME '/GSH/Results/' Model.name '_M1.mat'],'Model');

            % compute gravity harmonics
            %ModelTest = load([HOME '/GSH/Results/' Model.name '_M1.mat']);
            %tic;
            %[V_test] = model_SH_analysis(ModelTest.Model);
            %toc

            % get variance error

            % save result
            Phi_result(end+1) = [OBJ];
        end
        
        % compute slope of VAR wrt OBJ
        Phi_der = (Phi_result(3)-Phi_result(2))/(2*Dr);

        % adapt variable such that OBJ error is minimized
        dVAR = Phi_der * (1-OBJ);
        VAR = VAR + dVAR;

        % next loop
        ITR = ITR+1;
    end
    
    % next model
    Model = Model +1;
end

disp('END');