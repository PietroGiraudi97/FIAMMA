function FILENAME = CanteraH2(Y_f_0,Y_o_0,Y_p_0,tin,p)
% CanteraH2() Generates a flame structure file solving a counter-flow
% diffusion flame with the Cantera library.
% INPUT:
% Y_f_0 = H2 mass fraction in fuel stream
% Y_o_0 = O2 mass fraction in oxidiser stream
% Y_p_0 = H2O mass fraction in oxidiser stream
% tin = inlet Temperature [K]
% p = inlet pressure [Pa]
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

runtime = cputime;  % Record the starting time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%
disp('*****Cantera H2-Oxi Solver*****')
W_f        =   0.002;                % Molar mass H2, g/mol
W_o        =   0.032;                % Molar mass O2, g/mol
W_p        =   0.018;                % Molar mass H2O, g/mol
W_n        =   0.028;                % Molar mass N2, g/mol
mdot_f     =   1;                   % Fuel mass flux, kg/m^2/s
s          =   (1*W_o)/(2*W_f);     % Stoichiometric mass fraction of H2 O2 reaction
S          =   s*Y_f_0/Y_o_0;
mdot_o     =   S*mdot_f;            % Air mass flux, kg/m^2/s
FILENAME   =   'FLAMESTRUCTURE.mat';% File name for saving end exporting data 'FLAMESTRUCTURE.mat' by default
transport  =   'Mix';                % Transport model % 'Mix 'Multi' 'None'
% NOTE: Transport model needed if mechanism file does not have transport
% properties.

Y_n_0       = 1-(Y_o_0+Y_p_0);
WOX         = 1/(Y_n_0/W_n + Y_o_0/W_o + Y_p_0/W_p);
WFU         = 1/(Y_f_0/W_f + (1-Y_f_0)/W_n);

% Molar fractions
X_f_0      =   Y_f_0*WFU/W_f;
X_o_0      =   Y_o_0*WOX/W_o;
X_n_0      =   Y_n_0*WOX/W_n;
X_p_0      =   Y_p_0*WOX/W_p;

fuelcomp   =  append('H2:',num2str(X_f_0),', N2:',num2str(1-X_f_0));                    % Fuel composition
oxcomp = append('O2:',num2str(X_o_0),', N2:',num2str(X_n_0),', H2O:',num2str(X_p_0));   % Oxidizer composition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set-up initial grid, loglevel, tolerances. Enable/Disable grid
% refinement.
%

initial_grid    =   linspace(0,0.1,200);       % Units: m
tol_ss          =   [1.0e-5 1.0e-9];        % [rtol atol] for steady-state problem
tol_ts          =   [1.0e-3 1.0e-9];        % [rtol atol] for time stepping
loglevel        =   1;                      % Amount of diagnostic output (0 to 5)
refine_grid     =   1;                    % 1 to enable refinement, 0 to disable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the gas objects for the fuel and oxidizer streams. These objects
% will be used to evaluate all thermodynamic, kinetic, and transport
% properties.
%

fuel = GRI30(transport);
ox = GRI30(transport);
% Set each gas mixture state with the corresponding composition.
set(fuel,'T', tin, 'P', p,'X', fuelcomp);
set(ox,'T',tin,'P',p,'X', oxcomp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set-up the flow object. For this problem, the AxisymmetricFlow model is
% needed. Set the state of the flow as the fuel gas object. This is
% arbitrary and is only used to initialize the flow object. Set the grid to
% the initial grid defined prior, same for the tolerances.
%

f = AxisymmetricFlow(ox,'flow');
set(f, 'P', p, 'grid', initial_grid);
set(f, 'tol', tol_ss, 'tol-time', tol_ts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the fuel and oxidizer inlet steams. Specify the temperature, mass
% flux, and composition correspondingly.
%

% Set the oxidizer inlet.
inlet_o = Inlet('air_inlet');
set(inlet_o, 'T', tin, 'MassFlux', mdot_o, 'X', oxcomp);%
%
% Set the fuel inlet.
inlet_f = Inlet('fuel_inlet');
set(inlet_f, 'T', tin, 'MassFlux', mdot_f, 'X', fuelcomp);%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Once the inlets have been created, they can be assembled
% to create the flame object. Function CounterFlorDiffusionFlame
% (in Cantera/1D) sets up the initial guess for the solution using a
% Burke-Schumann flame. The input parameters are: fuel inlet object, flow
% object, oxidizer inlet object, fuel gas object, oxidizer gas object, and
% the name of the oxidizer species as in character format.
%

fl = CounterFlowDiffusionFlame(inlet_f, f, inlet_o, fuel, ox, 'O2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve with fixed temperature profile first. Grid refinement is turned off
% for this process in this example. To turn grid refinement on, change 0 to
% 1 for last input is solve function.
%

solve(fl, loglevel, 0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enable the energy equation. The energy equation will now be solved to
% compute the temperature profile. We also tighten the grid refinement
% criteria to get an accurate final solution. The explanation of the
% setRefineCriteria function is located on cantera.org in the Matlab User's
% Guide and can be accessed by help setRefineCriteria
%

enableEnergy(f);
setRefineCriteria(fl, 2, 200.0, 0.1, 0.2);
solve(fl, loglevel, refine_grid);
%saveSoln(fl,'h2.xml','energy',['solution with energy equation']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show statistics of solution and elapsed time.
%

writeStats(fl);
elapsed = cputime - runtime;
e = sprintf('Elapsed CPU time: %10.4g',elapsed);
disp(e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make a single plot showing temperature and mass fraction of select
% species along axial distance from fuel inlet to air inlet.
%

z = grid(fl, 'flow');                    % Get grid points of flow
spec = speciesNames(fuel);               % Get species names in gas
T = solution(fl, 'flow', 'T');           % Get temperature solution
for i = 1:length(spec)
    % Get mass fraction of all species from solution
    y(i,:) = solution(fl, 'flow', spec{i});
end
j = speciesIndex(fuel, 'O2');            % Get index of O2 in gas object
k = speciesIndex(fuel, 'H2O');           % Get index of H2O in gas object
l = speciesIndex(fuel, 'H2');          % Get index of H2 in gas object
m = speciesIndex(fuel, 'N2');           % Get index of CO2 in gas object
n = speciesIndex(fuel, 'OH');  
Z = (s.*y(l,:)-y(j,:)+Y_o_0)./(s.*Y_f_0+Y_o_0);
Z_st = (Y_o_0)./(s.*Y_f_0+Y_o_0);

s1 = find(Z>0.999,1,"last");
e1 = find(Z<0.001,1,"first");

FLAMESTRUCTURE.Z = Z(s1:e1);
FLAMESTRUCTURE.Z(1) = 1;
FLAMESTRUCTURE.Z(end) = 0;
FLAMESTRUCTURE.Z_st = Z_st;
FLAMESTRUCTURE.T = T(s1:e1);
FLAMESTRUCTURE.YF = y(l,s1:e1);
FLAMESTRUCTURE.YO = y(j,s1:e1);
FLAMESTRUCTURE.YP = y(k,s1:e1);
FLAMESTRUCTURE.YOH = y(n,s1:e1);
FLAMESTRUCTURE.YN = 1-FLAMESTRUCTURE.YF-FLAMESTRUCTURE.YO-FLAMESTRUCTURE.YP;

mix = GRI30(transport);
for count = 1:1:length(FLAMESTRUCTURE.Z)
    mixcomp = append('H2:',num2str(FLAMESTRUCTURE.YF(count)),', O2:',num2str(FLAMESTRUCTURE.YO(count)),', N2:',num2str(FLAMESTRUCTURE.YN(count)),', H2O:',num2str(FLAMESTRUCTURE.YP(count)));
    set(mix,'T', FLAMESTRUCTURE.T(count), 'P', p, 'Y', mixcomp);
    FLAMESTRUCTURE.Cp(count) = cp_mass(mix);
    FLAMESTRUCTURE.D(count) = dot(mixDiffCoeffs(mix),massFractions(mix));
    FLAMESTRUCTURE.rho(count) = density(mix);
    FLAMESTRUCTURE.mu(count) = viscosity(mix);
    FLAMESTRUCTURE.Q(count)= dot(netProdRates(mix),enthalpies_RT(mix)*8.31446261815324*temperature(mix)); %[kJ/m3/s]
end
%FLAMESTRUCTURE.T = (FLAMESTRUCTURE.T-tin)./max((FLAMESTRUCTURE.T-tin),[],'all')+1;
%tfl = max(FLAMESTRUCTURE.T,[],'all');
%temp = 1*(FLAMESTRUCTURE.T-tin)/(tfl-tin)+1;
%FLAMESTRUCTURE.D = temp.^1.5;%ones(1,length(FLAMESTRUCTURE.Z));
%FLAMESTRUCTURE.rho = 1./(FLAMESTRUCTURE.T./tin);%ones(1,length(FLAMESTRUCTURE.Z));
%FLAMESTRUCTURE.Cp = ones(1,length(FLAMESTRUCTURE.Z));
fig = figure;
yyaxis left
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.T)
xlabel('Mixture fraction Z');
ylabel('Temperature (K)');
yyaxis right
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YO,'r',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YP,'g',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YF,'m',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YN,'b',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YOH,'c');
ylim([0 1]);
ylabel('Mass Fraction');
legend('T','O2','H2O','H2','N2','OH');
grid on
title('Flame Structure')
saveas(fig,'FLAMESTRUCTURE.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.Cp);
xlabel('Mixture fraction Z');
ylabel('Cp (J/(kg K))');
grid on
title('Specific heat capacity')
saveas(fig,'CpvsZ.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.D);
xlabel('Mixture fraction Z');
ylabel('D (m^2/s)');
grid on
title('Diffusion coefficient')
saveas(fig,'DvsZ.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.mu);
xlabel('Mixture fraction Z');
ylabel('mu (Pa s)');
grid on
title('Viscosity')
saveas(fig,'MUvsZ.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.rho);
xlabel('Mixture fraction Z');
ylabel('rho (kg/m^3)');
grid on
title('Density')
saveas(fig,'rhovsZ.fig')

save(FILENAME,'FLAMESTRUCTURE');
disp('*****Cantera completed*****')
end