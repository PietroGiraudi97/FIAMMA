function [t,f] = RK4(fun,t_limits,f0,dt)
%%Pietro Giraudi, 5 December 2022, Imperial College London
%%Standard Runge-Kutta solver
t = [t_limits(1):dt:t_limits(2)]';
f(1,:) = f0;
for i = 2:length(t)
    k1 = fun(t(i-1),f(i-1,:))';
    k2 = fun(t(i-1)+dt/2,f(i-1,:)+k1*dt/2)';
    k3 = fun(t(i-1)+dt/2,f(i-1,:)+k2*dt/2)';
    k4 = fun(t(i-1)+dt,f(i-1,:)+dt*k3)';
    f(i,:) = f(i-1,:) + 1/6.*(k1+2*k2+2*k3+k4)*dt;
end
end