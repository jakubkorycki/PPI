clear;
close all;
clc;

HOME = pwd;
addpath([HOME '\Tools\'])


%% iteration setup
% plot parameters
aa=24;
whether_to_plot = false;

% numerical parameters
Dr = 10e3; % km
ITRmax = 5;
ModelMax = 1;

% variables
crust_Te = 54.7e3; %range [20e3,229.5]; % elastic thickness [km]
crust_Tc = 43.1e3; %range [12.5e3,162.5e3]; % mean crustal thickness [km]

%% create baseline planetary model
%% import gravity and topography model
% load spherical gravity harmonics and digital elevation model according to
% model grid
RefModel

% reference degree variance
[n_ref, DV_ref] = degreeVariance(V_ref);

% baseline harmonics
disp(['Model baseline', ' - ITRmax ', num2str(ITRmax), ' - test', num2str(3)]);
tic;
[V_base] = model_SH_analysis(Model);
toc
V_base = sortrows([0 0 1 0; V_base(:, 1:4)],1);
[n_base, DV_base] = degreeVariance(V_base);

%% parameter optimisation
M = 1;
while M<ModelMax+1
    % model setup
    if M==0
        VAR = 0;
    elseif M==1
        VAR = crust_Tc;
    elseif M ==2
        VAR = crust_Tc;
    else
        VAR = crust_Te;
    end

    % fitting for model X
    ITR = 0;    
    while(ITR<ITRmax+1)
        % loop setup 
        Phi_der = 0; % derivative of variable wrt objective function
        Phi_test = [
            VAR-Dr, VAR+Dr, VAR
        ];
        disp(Phi_test);
        Phi_result = [];

        % test model for each variable
        for test=1:length(Phi_test)
            disp(['Model ', num2str(M), ' - ITR ', num2str(ITR), ' - test', num2str(test)]);
            % model crustal inversion
            if M==0
                Dref = crust_Tc;
                DT = zeros("like",A);
            elseif M==1
                Dref = Phi_test(test);
                DT = InversionM1(Dref,whether_to_plot,aa);
            elseif M ==2
                % Dref = VAR; unchanged from M1
                DT = InversionM2(Dref,whether_to_plot,aa);
            else
                %Dref = Tc; %or use previous value opti for M1
                Te = Phi_test(test);
                DT = InversionM3(Dref, Te,whether_to_plot,aa);
            end

            % alter boundary gmt
            newbound = matrix2gmt(DT/1000,Lon,Lat);
            %Model.l2.bound = newbound;
            save([HOME '/Data/MercuryCrust/mantle_bd_test.gmt'],'newbound',"-ascii");
            Model.l2.bound = [HOME '/Data/MercuryCrust/mantle_bd_test.gmt'];

            % compute gravity harmonics
            tic;
            [V_test] = model_SH_analysis(Model);
            toc

            % get variance error
            V_test = sortrows([0 0 1 0; V_test(:, 1:4)],1);
            [n_test, DV_test] = degreeVariance(V_test);
            
            DVerr = DV_test - DV_ref;
            OBJ = sum(DVerr);

            % save result
            Phi_result(end+1) = OBJ;
        end
        
        % compute slope of VAR wrt OBJ
        Phi_der = (Phi_result(2)-Phi_result(1))/(2*Dr);

        % adapt variable such that OBJ error is minimized
        dVAR = Phi_der * (Phi_result(3)) * 10^18;
        VAR = VAR + dVAR;

        disp([Phi_result(3), Phi_der, dVAR]);

        % next loop
        ITR = ITR+1;
    end
    
    % next model
    M = M +1;
end

disp('END');