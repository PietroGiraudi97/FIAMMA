function [Solution_Filename_List] = UnsteadySolver(SteadyStateSolution_Filename,plot_Movie,save_Solution,tol,disp_Stats)
% UNSTEADYSOLVER computes the forced solution
% INPUTS:
%   tol - tolerance parameter
%   plot_Movie - trigger to plot the solution
%   save_Solution - trigger to save the solution
%   disp_Stats - trigger to display solver statistics
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

%% code
fprintf("--------------------------\n")
fprintf("Unsteady solver initiated.\n");
global MESH FLAMESTRUCTURE PROBLEMDATA

% Forcing cycles for each iteration
cycles = 5;

for k = 1:length(PROBLEMDATA.Frequency)
    fprintf(strcat("fl/c = ",num2str(PROBLEMDATA.Frequency(k)*PROBLEMDATA.t_ref)," \n"));
    %Loading Steady-State solution
    load(SteadyStateSolution_Filename);

    % Setting file names
    Filename = strcat('UNSolution_',num2str(k));
    Solution_Filename = strcat(Filename,'.mat');

    % Setting the fields for the solver
    [Nz,Nx] = size(F);
    V0 = V(2:Nz,1:Nx);
    F0 = F(2:Nz,1:Nx);
    V0 = reshape(V0,1,[]);
    F0 = reshape(F0,1,[]);
    Y0 = [V0 F0];
    Gain_old = 0;
    Phase_old = 0;
    Gain = 1;
    Phase = 1;
    j = 0;

    % Solver call
    options=odeset('OutputFcn',@odeprog,'Events',@odeabort);

    while abs((Gain-Gain_old)/Gain) > tol || abs((Phase-Phase_old)/Phase) > tol
        Gain_old = Gain;
        Phase_old = Phase;
        j = j+1;

        [t,Y] = ode45(@(t,Y) UnsteadyFun(t,Y,PROBLEMDATA.Amplitude,PROBLEMDATA.Frequency(k)),[0 cycles/(PROBLEMDATA.t_ref*PROBLEMDATA.Frequency(k))],Y0,options);%cycles/(PROBLEMDATA.t_ref*PROBLEMDATA.Frequency(k))
        %[t,Y] = RK4(@(t,Y) UnsteadyFun(t,Y,PROBLEMDATA.Amplitude,PROBLEMDATA.Frequency(k)),[0 cycles/(PROBLEMDATA.t_ref*PROBLEMDATA.Frequency(k))],Y0,0.1);%cycles/(PROBLEMDATA.t_ref*PROBLEMDATA.Frequency(k))

        % Reconstructing variables
        F = zeros(Nz,Nx,length(t));
        V = ones(Nz,Nx,length(t));
        for i = 1:length(t)
            Y0 = Y(i,:);
            
            V0 = Y0(1:end/2);
            F0 = Y0(end/2+1:end);
            V0 = reshape(V0,Nz-1,Nx);
            F0 = reshape(F0,Nz-1,Nx);

            % Getting the BC
            Y_BC = unsteadyBC(t(i),PROBLEMDATA.Amplitude,PROBLEMDATA.Frequency(k));

            % Reconstructing the BC
            V_BC = Y_BC(1:end/2);
            F_BC = Y_BC(end/2+1:end);

            % Applying BC
            V1 = [V_BC; V0];
            F1 = [F_BC; F0];

            F(:,:,i) = F1;
            V(:,:,i) = V1;
        end

        Q = computeHRR(F,PROBLEMDATA.U_ref.*V,PROBLEMDATA.t_ref.*t,x,z);
        [Gain, Phase] = computeTF(PROBLEMDATA.t_ref.*t, 1+PROBLEMDATA.Amplitude/2*sin(PROBLEMDATA.Frequency(k)*2*pi*PROBLEMDATA.t_ref.*t), Q, PROBLEMDATA.Frequency(k), 0, 0);
        Y0 = Y(end,:);
        if disp_Stats
            stats = strcat('Iteration: ',num2str(j),',\t Gain: ',num2str(Gain),',\t Phase: ',num2str(Phase),'\n');
            fprintf(stats);
        end
    end

    fprintf(strcat("Unsteady solution found.\n"));

    %Saving the solution
    if save_Solution
        Frequency = PROBLEMDATA.Frequency(k);
        Amplitude = PROBLEMDATA.Amplitude;
        V = PROBLEMDATA.U_ref.*V;
        t = PROBLEMDATA.t_ref.*t;
        save(Solution_Filename,'-v7.3','t','F','V','x','z','Frequency','Amplitude','Gain','Phase');
        fprintf(strcat("Unsteady solution saved in ",Solution_Filename,"\n"));
        clear t F V Q Frequency Amplitude Gain Phase
    end

    %Plotting the solution
    if plot_Movie
        plotMovie(Solution_Filename)
    end

    Solution_Filename_List(k) = string(Solution_Filename);
end
fprintf(strcat("Unsteady solver completed.\n"));
end