function plotFigure(Solution_Filename)
% PLOTFIGURE plots the flame contained in the Solution_Filename
% INPUTS:
%   Solution_Filename - Filename of the solution to be plotted
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

global FLAMESTRUCTURE

%Loading Solution
load(Solution_Filename)

Figure_Filename = strcat(Solution_Filename(1:end-4),'.fig');

xplot = linspace(0,max(x,[],'all'),50);
zplot = linspace(0,max(z,[],'all'),50);
[xplot,zplot] = meshgrid(xplot,zplot);
vplot = interp2(x,z,V,xplot,zplot,'linear');
fplot = interp2(x,z,F,xplot,zplot,'linear');

figg = figure;
subplot(1,2,1)
contourf([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(fplot) fplot],linspace(min(fplot,[],'all'),max(fplot,[],'all')),'EdgeColor','none')
hold on
contour([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(fplot) fplot],[FLAMESTRUCTURE.Z_st FLAMESTRUCTURE.Z_st+0.00001],'m','LineWidth',2)
axis equal
xlabel('$r [mm]$','interpreter','latex')
ylabel('$z [mm]$','interpreter','latex')
title('F')
caxis([min(fplot,[],"all") max(fplot,[],"all")])
colorbar
subplot(1,2,2)
contourf([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(vplot) vplot],linspace(min(vplot,[],'all'),max(vplot,[],'all')),'EdgeColor','none')
hold on
contour([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(fplot) fplot],[FLAMESTRUCTURE.Z_st FLAMESTRUCTURE.Z_st+0.00001],'m','LineWidth',2)
axis equal
xlabel('$r [mm]$','interpreter','latex')
ylabel('$z [mm]$','interpreter','latex')
title('V')
caxis([min(vplot,[],"all") max(vplot,[],"all")])
colorbar

drawnow
saveas(figg,Figure_Filename)
fprintf(strcat("Figure saved in ",Figure_Filename,"\n"));

end