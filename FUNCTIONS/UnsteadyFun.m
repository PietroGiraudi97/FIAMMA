function dYdt = UnsteadyFun(t,Y,ampl,freq)
global FLAMESTRUCTURE MESH PROBLEMDATA

xx = MESH.xx./PROBLEMDATA.L_ref;
zz = MESH.zz./PROBLEMDATA.L_ref;

%Generating boundary condition
Y_BC = unsteadyBC(t,ampl,freq);

%Reconstructing the variable
[Nz,Nx] = size(MESH.xx);
V0 = Y(1:end/2);
V0 = reshape(V0,Nz-1,Nx);
F0 = Y(end/2+1:end);
F0 = reshape(F0,Nz-1,Nx);

%Reconstructing the BC
V_BC = Y_BC(1:end/2);
F_BC = Y_BC(end/2+1:end);

%Inlet boundary condition
V = [V_BC; V0];
F = [F_BC; F0];

rho = my_rho(F)./PROBLEMDATA.rho_ref;
D = my_D(F)./PROBLEMDATA.D_ref;
mu = my_mu(F)./PROBLEMDATA.mu_ref;

rr = xx;
rr(:,1) = 1;

%Momentum equation
dVdt = -V.*dz(V,zz) + 1./PROBLEMDATA.Re.*mu./rho.*(d2x(V,xx)+1./rr.*dx(V,xx)+4./3.*d2z(V,zz));

%Mixture fraction equation
dFdt = - (V.*dz(F,zz)) + 1./PROBLEMDATA.Pe .* ( D.*d2x(F,xx) + 1./(rho).*dx(F,xx).*dx(rho.*D,xx) + D./rr.*dx(F,xx) + D.*d2z(F,zz) + 1./rho.*dz(F,zz).*dz(rho.*D,zz));

dVdt = reshape(dVdt(2:Nz,1:Nx),[],1);
dFdt = reshape(dFdt(2:Nz,1:Nx),[],1);

dYdt = [dVdt;dFdt];
end