function [f] = name_state(x,t)
%M-file contains state equations and motion equations
%Dice Roller

%Inputs
%x(t) nx1 vector of state variables at time t
%t time

%Outputs
%f(x,t) nx1 vector of time derivatives of state variables
%% Parameters and Constants
grav = 9.81;
n = x(7); %number of sides
m = length(x)/7; %number of shapes
mass = 5; %Mass (kg)
c = 500; %Damping Constant 
K = 500; %spring constant
mu = 0.9; %coefficient of friction
g = grav; %gravitational acceleration
radius = 1; %radius of ball
%% Normal and Friction Force (Ground)
%Pre Allocation
N = zeros(1,m); %Normal Force
v = zeros(1,m); %Difference in x-velocity and rolling velocity
F = zeros(1,m); %Friction Force

%Calculating Normal Force
for i = 1:m
    if x(3+((i-1)*7)) < 0 %if y position is less than 0
        N(i) = (-K*x(3+((i-1)*7)))-(c*x(4+((i-1)*7)));
    else
        N(i) = 0;
    end
end

%Calculating difference in velocities
for i = 1:m
    v(i) = x(2+((i-1)*7))-(radius*x(6+((i-1)*7))); %x velocity minus angular velocity
end

%Calculating friction forces
for i = 1:m
    if v(i) > 0 %if x velocity is greater then 0
        F(i) = -mu*N(i);
    elseif v(i)< 0
        F(i) = mu*N(i);
    else
        F(i) = 0;
    end
end

%% Distance and Angles between die
%Calculating Distances between rigid bodies 
r = cell(1,m);
for i = 1:m
    for k = 1:m
        r{i}(k) = sqrt(((x(1+(i-1)*7)-x(1+((k-1)*7)))^2)+((x(3+(i-1)*7)-x(3+((k-1)*7)))^2)); %Distance between die 
    end
end

%Calculating angles between rigid bodies
theta = cell(1,m);
tol = 0.001; %Tolerance, if the difference of two numbers are above this value, thay are numerically different
for i = 1:m
    for k = 1:m
        if i == k 
            theta{i}(k) = 0;
        else
            if x(1+(7*(i-1))) > x(1+((k-1)*7)) && abs(x(3+(7*(i-1)))-x(3+((k-1)*7))) < tol
                theta{i}(k) = 0; %angle of each force to the center mass
            elseif abs(x(1+(7*(i-1)))-x(1+((k-1)*7))) < tol && x(3+(7*(i-1))) > x(3+((k-1)*7))
                theta{i}(k) = pi/2; %angle of each force to the center mass
            elseif x(1+(7*(i-1))) < x(1+((k-1)*7)) && abs(x(3+(7*(i-1)))-x(3+((k-1)*7))) < tol
                theta{i}(k) = pi; %angle of each force to the center mass
            elseif abs(x(1+(7*(i-1)))-x(1+((k-1)*7))) < tol && x(3+(7*(i-1))) < x(3+((k-1)*7))
                theta{i}(k) = (3*pi)/2; %angle of each force to the center mass
            elseif x(1+(7*(i-1))) > x(1+(7*(k-1))) && x(3+(7*(i-1))) > x(3+(7*(k-1)))
                theta{i}(k) = atan((x(1+(7*(i-1)))-x(1+((k-1)*7)))/(x(3+(7*(i-1)))-x(3+(7*(k-1))))); %angle of each force to the center mass
            elseif x(1+(7*(i-1))) < x(1+(7*(k-1))) && x(3+(7*(i-1))) > x(3+(7*(k-1)))
                theta{i}(i) = atan((x(1+(7*(i-1)))-x(1+((k-1)*7)))/(x(3+(7*(i-1)))-x(3+(7*(k-1)))))+(pi/2); %angle of each force to the center mass
            elseif x(1+(7*(i-1))) < x(1+(7*(k-1))) && x(3+(7*(i-1))) < x(3+(7*(k-1)))
                theta{i}(k) = atan((x(1+(7*(i-1)))-x(1+((k-1)*7)))/(x(3+(7*(i-1)))-x(3+(7*(k-1)))))+(pi); %angle of each force to the center mass
            elseif x(1+(7*(i-1))) > x(1+(7*(k-1))) && x(3+(7*(i-1))) < x(3+(7*(k-1)))
                theta{i}(k) = atan((x(1+(7*(i-1)))-x(1+((k-1)*7)))/(x(3+(7*(i-1)))-x(3+(7*(k-1)))))+((3*pi)/2); %angle of each force to the center mass
            end
        end
    end
end
%% Collision Parameters
% This loop returns the condition in which the rigid bodies collide
collision = cell(1,m);
for i = 1:m
    for k = 1:m
        if r{i}(k) == 0 %If iterating through own rigid body
            collision{i}(k) = false;
        else
            if r{i}(k) < (radius*2) %if two rigid bodies are colliding
                collision{i}(k) = true;
            else
                collision{i}(k) = false;
            end
        end 
    end
end
% This loop removes any value that indicates that the rigid body is
% calculated against itself
for i = 1:m
    for k = 1:m
        if i == k
            if collision{i}(k) == false
                collision{i}(k) = [];
            end
            if r{i}(k) == 0
                r{i}(k) = [];
            end
            if theta{i}(k) == 0
                theta{i}(k) = [];
            end
        end
    end
end
%calulates the forces in each axial direction for the die
ftotal = cell(1,m);
fx = cell(1,m);
fy = cell(1,m);
for i = 1:m
    for k = 1:(m-1)
        if collision{i}(k) == true
            for j = 1:m-1
                ftotal{i}(j) = -K*(r{i}(j))-c*(sqrt((x(2+((i-1)*7))^2)+(x(4+((i-1)*7))^2)));
                fx{i}(j) = -ftotal{i}(j)*cos(theta{i}(j));
                fy{i}(j) = -ftotal{i}(j)*sin(theta{i}(j));
            end
        end
    end
end
%Calculating forces if die hits side wall
fwall = zeros(1,m);
for i = 1:m
    if x(1+((i-1)*7)) > 5
        fwall(i) = -(K*((x(1+((i-1)*7)))-5))-(c*(x(2+((i-1)*7))));
    elseif x(1+((i-1)*7)) < -5
        fwall(i) = -(K*((x(1+((i-1)*7)))-(-5)))-(c*(x(2+((i-1)*7))));
    else
        fwall(i) = 0;
    end
end
%% State Space
f = zeros(1,length(x)); %Pre allocate f vector
for i = 1:m
    f(1+((i-1)*7)) = x(2+((i-1)*7)); %x velocity
    f(2+((i-1)*7)) = ((F(i)+(sum(fx{i}))+fwall(i))/mass); %x acceleration
    f(3+((i-1)*7)) = x(4+((i-1)*7)); %y velocity
    f(4+((i-1)*7)) = (((N(i)+(sum(fy{i})))/mass)-g); %y acceleration
    f(5+((i-1)*7)) = x(6+((i-1)*7)); %angular velocity
    f(6+((i-1)*7)) = ((-F(i)*radius)/(0.5*mass*(radius^2))); %angular acceleration
    f(7+((i-1)*7)) = x(7); %Number of sides
end
end