% makefile for the complete GSH circle for a particular model
clear;
close all;
clc;

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
height =    225000.0; % height of computation above spheroid
SHbounds =  [0 49]; % Truncation settings: lower limit, upper limit SH-coefficients used

%%%%%%%%%%%%%% Part that can be modified %%%%%%%%%%%%%%%%%%%%%%%

%% Global Spherical Harmonic Analysis 

tic;
[V] = model_SH_analysis(Model);
toc

save([HOME '/GSH/Results/' Model.name '_V.mat'],'V')

%% Global Spherical Harmonic Synthesis

tic;
[data] = model_SH_synthesis(lonLim,latLim,height,SHbounds,V,Model);
toc

%% Save data

save([HOME '/GSH/Results/' Model.name '_' num2str(SHbounds(1)) '_' num2str(SHbounds(2)) '_data.mat'],'data')