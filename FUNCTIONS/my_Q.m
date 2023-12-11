function Q = my_Q(c)
global FLAMESTRUCTURE

c(c>1)=1;
c(c<0)=0;

%% Cantera Flame Structure
Q = interp1(FLAMESTRUCTURE.Z,FLAMESTRUCTURE.Q,c); %[kJ/m3/s]

end