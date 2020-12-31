function [xnew] = step2(file,x,t,deltaT)
%Performs 2nd order numerical integration step (Runga Kutta Method)
%
%Inputs
%file - name of file that contains state equations
%x - n x 1 vector (1 column vector) of state variables at time t (initial variables?)
%t - time
%deltaT - time step (Change in time)
%
%Outputs
%xnew - n x 1 vector (1 column vector) of state variables at time t+deltaT
%
%Calls
%M-file
eval(['f1=',file,'(x,t);']);
deltax1 = deltaT*f1;
eval(['f2=',file,'(x+deltax1,t+deltaT);']);
xnew = x+(0.5*deltaT*(f1+f2));
end

