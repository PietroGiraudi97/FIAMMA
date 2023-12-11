function FILENAME = BKFlameStructure(Y_f_0,Y_o_0,Y_p_0,tin,p)
% BKFLAMESTRUCTURE Generates a Burke-Schumann flame structure
% INPUTS:
%   Z_st - Stoichiometric mixture fraction
% 
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

disp('*****Burke-Schumann Flame Structure Generator*****')

v_o         = 0.5;
v_f         = 1;
tfl         = 2100;
W_f         = 0.002;                % Molar mass H2, g/mol
W_o         = 0.032;                % Molar mass O2, g/mol
W_p         = 0.018;                % Molar mass H2O, g/mol
W_n         = 0.028;                % Molar mass N2, g/mol

Z_st = 1/(1+(v_o*W_o*Y_f_0)/(v_f*W_f*Y_o_0));
FILENAME = 'FLAMESTRUCTURE.mat';

FLAMESTRUCTURE.Z    = [0 Z_st 1];
FLAMESTRUCTURE.Z_st = Z_st;
FLAMESTRUCTURE.T    = [tin tfl tin];
FLAMESTRUCTURE.YF   = [0 0 Y_f_0];
FLAMESTRUCTURE.YO   = [Y_o_0 0 0];
FLAMESTRUCTURE.YP   = [Y_p_0 0.23+Y_p_0 0];
FLAMESTRUCTURE.YN   = 1-FLAMESTRUCTURE.YP-FLAMESTRUCTURE.YO-FLAMESTRUCTURE.YF;
FLAMESTRUCTURE.Cp   = [1100 1800 14300];
FLAMESTRUCTURE.mu   = [2.7e-5 6.8e-5 9e-6];
FLAMESTRUCTURE.Q    = [1 1 1];
FLAMESTRUCTURE.rho  = [0.67 0.14 0.08];%tfl./FLAMESTRUCTURE.T;
FLAMESTRUCTURE.D    = [5.3e-5 6.2e-4 9.1e-4];%(FLAMESTRUCTURE.T/tfl).^1.5;
FLAMESTRUCTURE.W    = [1 1 1];
FLAMESTRUCTURE.P    = p;

fig = figure;
yyaxis left
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.T)
xlabel('Mixture fraction Z');
ylabel('Temperature (K)');
yyaxis right
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YO,'r',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YP,'g',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YF,'m',FLAMESTRUCTURE.Z,FLAMESTRUCTURE.YN,'b');
ylim([0 1]);
ylabel('Mass Fraction');
legend('T','O2','H2O','H2','N2');
grid on
saveas(fig,'flameStructure.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.Cp);
xlabel('Mixture fraction Z');
ylabel('Cp (J/kg-K)');
grid on
saveas(fig,'CPvsZ.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.D);
xlabel('Mixture fraction Z');
ylabel('D (m^2/s)');
grid on
saveas(fig,'DvsZ.fig')

fig = figure;
plot(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.rho);
xlabel('Mixture fraction Z');
ylabel('rho (kg/m^3)');
grid on
saveas(fig,'RHOvsZ.fig')

save(FILENAME,'FLAMESTRUCTURE');
disp('*****Flame structure completed*****')

end