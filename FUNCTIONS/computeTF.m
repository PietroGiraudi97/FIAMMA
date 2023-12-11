function [Gain, Phase] = computeTF(t,input,output,frequency,PLOT,SAVE_FIG)
% COMPUTETF compute the gain and phase lag between the input and output
% signals
% INPUTS:
%   t - time array
%   input - input signal array
%   output - output signal array
%   frequency - frequency of input signal
%   PLOT - Boolean to enable plot
%   SAVE_FIG - Boolean to save plot
% AUTHOR: Pietro Giraudi
% Imperial College London 2023
global PROBLEMDATA
N = round(frequency*(t(end)-t(1)));
t_start = t(end) - (4)/frequency;
t_end = t(end) - (1)/frequency;
dt = 1/(720*frequency);

input = interp1(t,input,[t(1):dt:t(end)]);
output = interp1(t,output,[t(1):dt:t(end)]);
t = [t(1):dt:t(end)];

i_start = min(find(t_start<=t));
i_end = max(find(t<=t_end));
input_mean = mean(input(i_start:i_end),'all');
input_norm = (input(i_start:i_end)-input_mean)/abs(input_mean);
input_amplitude = 0.5*(max(input_norm)-min(input_norm));

output_mean = mean(output(i_start:i_end),'all');
output_norm = (output(i_start:i_end)-output_mean)/abs(output_mean);
output_amplitude = 0.5*(max(output_norm)-min(output_norm));

signal1=input_norm/max(input_norm);
signal2=output_norm/max(output_norm);

[r,tau] = xcorr(signal1,signal2);
[~,index] = max(r);
phi_fit = tau(index)*2*pi*frequency*dt;
sin_fit = output_amplitude*sin(frequency*2*pi*t(i_start:i_end) + phi_fit);

if PLOT
    figure
    subplot(2,1,1)
    hold on
    plot(t, (input-input_mean)/abs(input_mean));
    plot(t, (output-output_mean)/abs(output_mean));
    xlabel('Time', 'interpreter','latex')
    grid on
    legend('Input', 'Output', 'interpreter', 'latex');
    hold off
    subplot(2,1,2)
    hold on
    plot(t(i_start:i_end),input_norm);
    plot(t(i_start:i_end),output_norm);
    plot(t(i_start:i_end),sin_fit);
    legend('Input', 'Output', 'Fit', 'interpreter', 'latex');
    xlabel('Time', 'interpreter','latex')
    hold off
    grid on
    drawnow
    if SAVE_FIG
        filename=strcat('Frequency_',num2str(round(frequency*PROBLEMDATA.t_ref*10)),'_Ampitude_',num2str(round(input_amplitude*100)),'perc.fig');
        savefig(filename)
    end
end

Gain = output_amplitude/input_amplitude;
Phase = mod(phi_fit,-2*pi);
end