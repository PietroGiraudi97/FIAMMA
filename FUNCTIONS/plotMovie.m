function plotMovie(Solution_Filename)
global MESH FLAMESTRUCTURE PROBLEMDATA
%Loading Solution
load(Solution_Filename)

Movie_Filename = strcat(Solution_Filename(1:end-4),'.gif');
Figure_Filename = strcat(Solution_Filename(1:end-4),'.fig');
fig = figure('Position', [10 10 1200 400]);
gif(Movie_Filename,'overwrite',true);

F_mean = mean(F,3);
V_mean = mean(V,3);

xplot = linspace(0,max(MESH.xx,[],'all'),50);
zplot = linspace(0,max(MESH.zz,[],'all'),50);
[xplot,zplot] = meshgrid(xplot,zplot);
for i = 1:round(length(t)/(300)):length(t)
    clf
    vplot = interp2(MESH.xx,MESH.zz,(V(:,:,i)-V_mean),xplot,zplot,'linear');
    vplot(isnan(vplot)) = 0;
    vplot(isinf(vplot)) = 0;

    subplot(1,2,1)
    contourf([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(vplot) vplot],linspace(min(vplot,[],"all"),max(vplot,[],"all")),'EdgeColor','none')
    colormap jet
    hold on
    contour([-fliplr(MESH.xx) MESH.xx],[fliplr(MESH.zz) MESH.zz],[fliplr(F(:,:,i)) F(:,:,i)],[FLAMESTRUCTURE.Z_st FLAMESTRUCTURE.Z_st+0.00001],'m','LineWidth',2)
    colorbar
    caxis(PROBLEMDATA.U_ref*[-PROBLEMDATA.Amplitude PROBLEMDATA.Amplitude])
    axis equal
    title('$V^\prime$','Interpreter','latex')
    xlabel('$r$','interpreter','latex')
    ylabel('$z$','interpreter','latex')

    fplot = interp2(MESH.xx,MESH.zz,(F(:,:,i)-F_mean),xplot,zplot,'linear');
    fplot(isnan(fplot)) = 0;
    fplot(isinf(fplot)) = 0;

    subplot(1,2,2)
    contourf([-fliplr(xplot) xplot],[fliplr(zplot) zplot],[fliplr(fplot) fplot],linspace(min(fplot,[],"all"),max(fplot,[],"all")),'EdgeColor','none')
    colormap jet
    hold on
    contour([-fliplr(MESH.xx) MESH.xx],[fliplr(MESH.zz) MESH.zz],[fliplr(F(:,:,i)) F(:,:,i)],[FLAMESTRUCTURE.Z_st FLAMESTRUCTURE.Z_st+0.00001],'m','LineWidth',2)
    colorbar
    caxis([-PROBLEMDATA.Amplitude PROBLEMDATA.Amplitude])
    axis equal
    title('$F^\prime$','Interpreter','latex')
    xlabel('$r$','interpreter','latex')
    ylabel('$z$','interpreter','latex')

    drawnow
    gif
end
fprintf(strcat("Movie saved in ",Movie_Filename,"\n"));
saveas(fig,Figure_Filename)
close all

fprintf(strcat("Figure saved in ",Figure_Filename,"\n"));
end