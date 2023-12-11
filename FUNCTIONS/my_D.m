function D = my_D(c)
global FLAMESTRUCTURE
c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
D = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.D,c);
end