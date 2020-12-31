function [h] = circle(x,y,r)
%% Info
% Used to make a circle around a center point, given a radius
% Inputs:
% x, x coordinate of center
% y, y coordinate of center
% r, radius of circle
% output:
% h, a plot of the circle
%% function
hold on
th = 0:0.01:360;
xunit = r * cosd(th) + x;
yunit = r * sind(th) + y;
h = plot(xunit, yunit,'b');
hold off
end
