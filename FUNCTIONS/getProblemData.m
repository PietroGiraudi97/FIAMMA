function ProblemData_Filename = getProblemData(Amplitude, Frequency, dx, dz, force_Fuel, force_Oxi, F_BC_F, F_BC_O,V_OX,V_FU,R_out,R_in,L)
% GETPROBLEMDATA generates the PROBLEMDATA structure that contains all the
% reference values needed for the solver
% AUTHOR: Pietro Giraudi
% Imperial College London 2023
global FLAMESTRUCTURE

PROBLEMDATA.Amplitude = Amplitude;
PROBLEMDATA.Frequency = Frequency;
PROBLEMDATA.L_ref = R_out;
PROBLEMDATA.R_in = R_in;
PROBLEMDATA.R_out = R_out;
PROBLEMDATA.L = L;
PROBLEMDATA.dx = dx;
PROBLEMDATA.dz = dz;
PROBLEMDATA.D_ref = my_D(1);
PROBLEMDATA.mu_ref = my_mu(1);
PROBLEMDATA.rho_ref = my_rho(1);
PROBLEMDATA.Cp_ref = my_Cp(1);
PROBLEMDATA.T_ref = my_T(1);
PROBLEMDATA.U_ref = V_FU;
PROBLEMDATA.t_ref = PROBLEMDATA.L_ref/PROBLEMDATA.U_ref;
PROBLEMDATA.St = Frequency*PROBLEMDATA.L_ref/PROBLEMDATA.U_ref;
PROBLEMDATA.Pe = PROBLEMDATA.L_ref*PROBLEMDATA.U_ref/PROBLEMDATA.D_ref;
PROBLEMDATA.Re = PROBLEMDATA.rho_ref*PROBLEMDATA.U_ref*PROBLEMDATA.L_ref/PROBLEMDATA.mu_ref;
PROBLEMDATA.V_BC_F = V_FU;
PROBLEMDATA.V_BC_O = V_OX;
PROBLEMDATA.F_BC_F = F_BC_F;
PROBLEMDATA.F_BC_O = F_BC_O;
PROBLEMDATA.force_Fuel = force_Fuel;
PROBLEMDATA.force_Oxi = force_Oxi;

ProblemData_Filename = "PROBLEMDATA.mat";
save(ProblemData_Filename,"PROBLEMDATA")
end