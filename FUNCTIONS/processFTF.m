function processFTF(list_filenames,PLOT)
fprintf("------------------------\n");
fprintf("Processing Flame Transfer Function.\n")
global MESH FLAMESTRUCTURE PROBLEMDATA
for i =1:length(list_filenames)
    load(list_filenames(i))
    
    FTF.Frequency(i) = Frequency;
    FTF.Gain(i) = Gain;
    FTF.Phase(i) = Phase;
end

P1 = polyfit(FTF.Frequency(1:2),FTF.Gain(1:2),1);
FTF.Gain = FTF.Gain./P1(2);


P2 = polyfit(FTF.Frequency(1:2),FTF.Phase(1:2),1);
FTF.Phase = FTF.Phase-P2(2);
%while FTF.Phase(1)>0
%    FTF.Phase = FTF.Phase-2*pi;
%end

if PLOT
    fig = figure;
    subplot(2,1,1)
    plot(FTF.Frequency,mag2db(FTF.Gain),'rx-','LineWidth',2,'MarkerSize',5)
    grid on
    ylabel('Gain [dB]','interpreter','latex');
    xlabel('Frequency [Hz]','interpreter','latex');
    subplot(2,1,2)
    plot(FTF.Frequency,rad2deg(unwrap(FTF.Phase)),'rx-','LineWidth',2,'MarkerSize',5)
    grid on
    ylabel('Phase [deg]','interpreter','latex');
    xlabel('Frequency [Hz]','interpreter','latex');
    sgtitle('Flame Transfer Function')
    saveas(fig,'FTF.fig')
end
save('FTF.mat','FTF')

fprintf(strcat("Steady state solution saved in FTF.mat.\n"));
end



