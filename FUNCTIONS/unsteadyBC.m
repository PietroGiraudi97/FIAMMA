function Y_BC = unsteadyBC(t,ampl,freq)
global MESH FLAMESTRUCTURE PROBLEMDATA

[Nz,Nx] = size(MESH.xx);
alpha_i = max(find(MESH.xx(1,:)<=PROBLEMDATA.R_in),[],'all');

% From 1 to alpha-1 FUEL INLET
% From alpha+1 to Nx OXIDISER INLET
V_BC = zeros(1,Nx);
F_BC = zeros(1,Nx);

F_BC(1:alpha_i-1) = PROBLEMDATA.F_BC_F;
F_BC(alpha_i) = FLAMESTRUCTURE.Z_st;
F_BC(alpha_i+1:Nx) = PROBLEMDATA.F_BC_O;

V_BC(1:alpha_i-1) = PROBLEMDATA.V_BC_F./PROBLEMDATA.U_ref;
V_BC(alpha_i) = PROBLEMDATA.V_BC_F./PROBLEMDATA.U_ref;
V_BC(alpha_i+1:Nx) = PROBLEMDATA.V_BC_O./PROBLEMDATA.U_ref;

if PROBLEMDATA.force_Fuel
    V_BC(1:alpha_i) = V_BC(1:alpha_i).*(1+ampl./2.*sin(2*pi*freq*PROBLEMDATA.t_ref*t));
end
if PROBLEMDATA.force_Oxi
    V_BC(alpha_i+1:end) = V_BC(alpha_i+1:end).*(1+ampl./2.*sin(2*pi*freq*PROBLEMDATA.t_ref*t));
end
Y_BC = [V_BC F_BC];
end
