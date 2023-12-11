function FILENAME = generateGrid(PLOT)
% GENERATEGRID generates the meshgrid
% INPUTS:
%   PLOT - Boolean to enable plot
% AUTHOR: Pietro Giraudi
% Imperial College London 2023

global PROBLEMDATA

expansionRatio = 1;
FILENAME = 'MESH.mat';

x = [0 0];
i = 1;
while x(i) < PROBLEMDATA.R_out
    i = i + 1;
    dx = interp1([0 1]*PROBLEMDATA.R_out,[1 expansionRatio]*PROBLEMDATA.dx,x(i-1),"pchip");
    x(i) = x(i-1) + dx;
end

z = [0 0];
i = 1;
while z(i) < PROBLEMDATA.L
    i = i + 1;
    dz = interp1([0 1]*PROBLEMDATA.R_out,[1 expansionRatio]*PROBLEMDATA.dz,z(i-1),"pchip");
    z(i) = z(i-1) + dz;
end

[xx,zz]=meshgrid(x,z);
if PLOT
    figure
    mesh(xx,zz,0*xx)
    drawnow
end
MESH.xx = xx;
MESH.zz = zz;

save(FILENAME,"MESH");
end