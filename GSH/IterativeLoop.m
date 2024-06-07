% makefile for the complete GSH circle for a particular model
clear;
close all;
clc;

addpath('data\')
addpath('GSH\')
addpath('GSH\Data')
addpath('GSH\Tools')
addpath('GSH\Results')

HOME = pwd;

% Model
% Load previous saved model

%model_name = 'Crust01_crust';
%load(model_name);

% Construct new model
ModelFit_bd = 0;
PlanetaryModel

%%%%%%%%%%%%%%%%%%% Computation area %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Part that can be modified %%%%%%%%%%%%%%%%%%%%%%%

latLim =    [-89.5 89.5 1];  % [deg] min latitude, max latitude, resolution latitude (preferable similar to latitude)
lonLim =    [-180 180 1];% [deg] min longitude, max longitude, resolution longitude (preferable similar to latitude)
height =    0.0; % height of computation above spheroid
SHbounds =  [0 49]; % Truncation settings: lower limit, upper limit SH-coefficients used


lats = fliplr(latLim(1):latLim(3):latLim(2));
lons = lonLim(1):lonLim(3):lonLim(2);

%%%%%%%%%%%%%% Part that can be modified %%%%%%%%%%%%%%%%%%%%%%%

%% Reference Model
G = 6.6743e-11;
R_ref = 2440e3;
M_mercury = 3.285e23;
g_ref = G*M_mercury/R_ref^2;

gravity_ref = readmatrix('cleaned_gsh.csv', OutputType='double');
Lmax_ref = max(gravity_ref(:,1));
clm_ref = gravity_ref(:, 1:4);

sc_ref = clm2sc(clm_ref); % Convert coeffs from vec to /S|C\ Triangle

gravity_map_norm = GSHS(sc_ref, lons, 90-lats, Lmax_ref);
% gravity_map = (1+gravity_map_norm) * g_ref;
gravity_anomaly_map = gravity_map_norm * g_ref;


%% Global Spherical Harmonic Analysis 

% new
tic;
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'];
[V] = model_SH_analysis(Model);
toc
save([HOME '/GSH/Results/' Model.name '_V_new.mat'],'V')

% low
tic;
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_low.gmt'];
[V] = model_SH_analysis(Model);
toc
save([HOME '/GSH/Results/' Model.name '_V_low.mat'],'V')

% high
tic;
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_high.gmt'];
[V] = model_SH_analysis(Model);
toc
save([HOME '/GSH/Results/' Model.name '_V_high.mat'],'V')

%% Global Spherical Harmonic Synthesis

% new
tic;
Model.l1.bound = [HOME '/GSH/Data/MercuryCrust/crust_bd_new.gmt'];
[data] = model_SH_synthesis(lonLim,latLim,height,SHbounds,V,Model);
toc
save([HOME '/GSH/Results/' Model.name '_' num2str(SHbounds(1)) '_' num2str(SHbounds(2)) '_data.mat'],'data')

