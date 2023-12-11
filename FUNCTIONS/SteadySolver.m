function [Solution_Filename] = SteadySolver(ReadSolution,ReadSolution_Filename,tol,plot_SteadyState,save_SteadyState,disp_Stats)
% STEADYSOLVER computes the steady state solution
% INPUTS:
%   ReadSolution - trigger to start the solution from the guess contained
%   in ReadSolution_Filename
%   ReadSolution_Filename - File containing the initial guess when
%   ReadSolution is TRUE
%   tol - tolerance parameter
%   plot_SteadyState - trigger to plot the solution
%   save_SteadyState - trigger to save the solution
%   disp_Stats - trigger to display solver statistics
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

%% code
fprintf("------------------------------\n");
fprintf("Steady state solver initiated.\n");
global MESH FLAMESTRUCTURE PROBLEMDATA

%Setting filenames
Filename = strcat('SSSolution');
Solution_Filename = strcat(Filename,'.mat');%'SteadyState.mat';

%Normalisation mesh grid
xx = MESH.xx;
zz = MESH.zz;

[Nz,Nx] = size(xx);
dxx = [zeros(Nz,1) diff(xx,1,2)];
dzz = [zeros(1,Nx);diff(zz,1,1)];

if ReadSolution
    load(ReadSolution_Filename,'V','F','x','z')
    [M,N] = size(F);
    if M ~= Nz || N ~= Nx
        V = interp2(x,z,V,xx,zz,'spline',0)./PROBLEMDATA.U_ref;
        F = interp2(x,z,F,xx,zz,'spline',0);
    end
else
    V = ones(Nz,Nx);
    F = zeros(Nz,Nx);
end

V0 = V(2:Nz,1:Nx);
V0 = reshape(V0,1,[]);
F0 = F(2:Nz,1:Nx);
F0 = reshape(F0,1,[]);
Y0 = [V0 F0];

dYdt = 2;
t = [0 1];
i = 1;

while norm(dYdt)>tol
    
    [t,Y] = ode45(@(t,Y) SteadyFun(t,Y),[0 1],Y0);
    
    %Computing rate of change of the variables
    dYdt = (Y(end,:)-Y(1,:))/(t(end)-t(1));
    
    Y0 = Y(end,:);
    
    %Displaying solver statistics
    if disp_Stats
        stats = strcat('Iteration: ',num2str(i),',\t Norm: ',num2str(norm(dYdt)),',\t Tolerance: ',num2str(tol),'\n');
        fprintf(stats);
    end
    i = i+1;
end
fprintf("Steady state solution found.\n");

V0 = Y(end,1:end/2);
F0 = Y(end,end/2+1:end);
V0 = reshape(V0,Nz-1,Nx);
F0 = reshape(F0,Nz-1,Nx);

%Obataining the BC
Y_BC = steadyBC();

%Reconstructing the BC
V_BC = Y_BC(1:end/2);
F_BC = Y_BC(end/2+1:end);

%Applying BC
V = [V_BC; V0].*PROBLEMDATA.U_ref;
F = [F_BC; F0];

%Saving the solution
if save_SteadyState
    x = xx;
    z = zz;
    save(Solution_Filename,'V','F','x','z')
    fprintf(strcat("Steady state solution saved in ",Solution_Filename,"\n"));
end

%Plotting the solution
if plot_SteadyState
    plotFigure(Solution_Filename)
end

fprintf("Steady state solver completed.\n");
end