% FIAMMA v1.0
% FIAMMA is a solver that computes the Flame Transfer Function for jet
% diffusion flames
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

%% Housekeeping
clear
clc
close all

%% Inputs
R_in = 0.00015;                  %<--------- Fuel inlet radius [m]
R_out = 0.001;                  %<--------- Oxi outer radius [m]
L = 0.002;                      %<--------- Length of domain [m]
dx = R_out/16;                  %<--------- Radial discretisation [m]
dz = dx;                      %<--------- Axial discretisation [m]

% Mixture-fraction boundary conditions
F_BC_F = 1;                     %<--------- Mixture fraction fuel side
F_BC_O = 0;                     %<--------- Mixture fraction oxidiser side

V_BC_F = 10;                    %<--------- Fuel inlet Velocity [m/s]
V_BC_O = 1;                     %<--------- Oxi inlet velocity [m/s]

% Forcing inputs
Frequency = [100];     %<--------- Frequency [Hz]                                       
Amplitude = 1;                %<--------- Forcing amplitude [0.01 = 1% of mean velocity]
force_Fuel = true;              %<--------- Apply forcing to fuel stream?
force_Oxi = true;               %<--------- Apply forcing to oxi stream?

% Chemical input
Y_f_0 = 1;                      %<--------- H2 mass fraction in fuel stream
Y_o_0 = 0.23;                   %<--------- O2 mass fraction in oxidiser stream
Y_p_0 = 0;                      %<--------- H2O mass fraction in oxidiser stream
T_in = 300;                     %<--------- Inlet temperature [K]
p = 101325;                     %<--------- Pressure [Pa]

% Solver parameters
tol_steady = 1e-2;              %<--------- tolerance parameter for steady state solver
tol_unsteady = 1e-2;            %<--------- tolerance parameter for unsteady solver
read_Solution = false;          %<--------- Trigger to start the solver from a previously computed solution
read_Solution_Filename = 'SSSolution.mat'; %<--------- Filename of initial guess

%Triggers for plotting
plot_Grid = true;               %<--------- plot mesh?
plot_SteadyState = true;        %<--------- plot steady state solution?
plot_Movie = true;             %<--------- plot movie of forced solution?
plot_FTF = true;                %<--------- plot Flame Transfer Function?

%Trigger for displaying solver statistics
disp_Stats = true;              %<--------- display solver statistics?

%Trigger for saving the solution
save_Solution = true;           %<--------- save solution?

%% CODE

fprintf('-------------FIAMMA v1.0---------\n');
fprintf('GIRAUDI MODEL AXI----------------\n');

addpath("FUNCTIONS/")
global MESH FLAMESTRUCTURE PROBLEMDATA

%% Generating the Flame Structure
%FlameStructure_Filename = BKFlameStructure(Y_f_0,Y_o_0,Y_p_0,T_in,p);
%FlameStructure_Filename = CanteraH2(Y_f_0,Y_o_0,Y_p_0,T_in,p);
%FlameStructure_Filename = CanteraCH4(Y_f_0,Y_o_0,Y_p_0,T_in,p);
FlameStructure_Filename = 'FLAMESTRUCTURE.mat';
load(FlameStructure_Filename);

%% Setting up the Problem Data
ProblemData_Filename = getProblemData(Amplitude, Frequency, dx, dz, force_Fuel, force_Oxi, F_BC_F, F_BC_O,V_BC_O,V_BC_F,R_out,R_in,L);
load(ProblemData_Filename);

fprintf('PECLET NUMBER = %3.2f-----------\n',PROBLEMDATA.Pe);
fprintf('REYNOLDS NUMBER = %3.2f---------\n',PROBLEMDATA.Re);
fprintf('--------------------------------\n')

%% Generating the Grid
Mesh_Filename = generateGrid(plot_Grid);
load(Mesh_Filename);

%% Solving for Steady State solution
SteadySolution_Filename = SteadySolver(read_Solution,read_Solution_Filename,tol_steady,plot_SteadyState,save_Solution,disp_Stats);

%% Solving for Unsteady solution
UnsteadySolution_Filename = UnsteadySolver(SteadySolution_Filename,plot_Movie,save_Solution,tol_unsteady,disp_Stats);

%% Generating the Flame Transfer Function
processFTF(UnsteadySolution_Filename,plot_FTF);
