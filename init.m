function [x] = init(n,m)
%Develops initial conditions for bouncing ball system

%Inuputs
%n - Number of sides of shape
%m - Number of shapes

%Outputs
%x - all initial conditions
%% Initial Conditions
x = zeros(1,m*7);
radius=1;
for i = 1:m
    x(1+((i-1)*7)) = randi(4)-randi(4); %x position
    if x(1+((i-1)*7)) <= 0 %if the x-coordinate is less than or equal to 0
        x(2+((i-1)*7)) = abs(randi(5)-randi(5)); %x velocity
    else %If x-coordinate is positive
        x(2+((i-1)*7)) = -(randi(5)-randi(5)); %x velocity
    end
    x(3+((i-1)*7)) = randi(5)+randi(5)+4; %y position
    x(4+((i-1)*7)) = (randi(5)-randi(5)); %y velocity
    x(5+((i-1)*7)) = randi(10)-randi(3); %angular position
    x(6+((i-1)*7)) = randi(5)+randi(5); %angular velocity
    x(7+((i-1)*7)) = n; %Number of sides
end
%% Calculating Distance
r = cell(1,m);
for i = 1:m
    for k = 1:m
        r{i}(k) = sqrt(((x(1+(i-1)*7)-x(1+((k-1)*7)))^2)+((x(3+(i-1)*7)-x(3+((k-1)*7)))^2)); %Distance between die 
    end
end
%% Fixing Distances
for i = 1:m
    for k = 1:m
        if i == k
            x(1+((i-1)*7)) = x(1+((i-1)*7)); %x position
            x(2+((i-1)*7)) = x(2+((i-1)*7)); %x velocity
            x(3+((i-1)*7)) = x(3+((i-1)*7)); %y position
            x(4+((i-1)*7)) = x(4+((i-1)*7)); %y velocity
            x(5+((i-1)*7)) = x(5+((i-1)*7)); %angular position
            x(6+((i-1)*7)) = x(6+((i-1)*7)); %angular velocity
            x(7+((i-1)*7)) = x(7+((i-1)*7)); %Number of sides
        else
            while r{i}(k) <= radius*2
                x(1+((i-1)*7)) = randi(4)-randi(4); %x position
                if x(1+((i-1)*7)) <= 0
                    x(2+((i-1)*7)) = abs(randi(5)-randi(5)); %x velocity
                else
                    x(2+((i-1)*7)) = -(randi(5)-randi(5)); %x velocity
                end
                x(3+((i-1)*7)) = randi(5)+randi(5)+4; %y position
                x(4+((i-1)*7)) = randi(10)-randi(10); %y velocity
                x(5+((i-1)*7)) = randi(10)-randi(3); %angular position
                x(6+((i-1)*7)) = randi(7)-randi(7); %angular velocity
                x(7+((i-1)*7)) = n; %Number of sides
                r{i}(k) = sqrt(((x(1+(i-1)*7)-x(1+((k-1)*7)))^2)+((x(3+(i-1)*7)-x(3+((k-1)*7)))^2)); %Distance between die 
            end
        end
    end
end
%% Manually setting conditions
% for i = 1:m
%     if i == 1
%         x(1+((i-1)*7)) = 4; %x position
%         x(2+((i-1)*7)) = 0; %x velocity
%         x(3+((i-1)*7)) = 0; %y position
%         x(4+((i-1)*7)) = 0; %y velocity
%         x(5+((i-1)*7)) = 0; %angular position
%         x(6+((i-1)*7)) = 0; %angular velocity
%         x(7+((i-1)*7)) = n; %Number of sides
%     else
%         x(1+((i-1)*7)) = 0; %x position
%         x(2+((i-1)*7)) = 5; %x velocity
%         x(3+((i-1)*7)) = 0; %y position
%         x(4+((i-1)*7)) = 0; %y velocity
%         x(5+((i-1)*7)) = 0; %angular position
%         x(6+((i-1)*7)) = 0; %angular velocity
%         x(7+((i-1)*7)) = n; %Number of sides
%     end
% end
% for i = (m+1):(m+2)
%     if i == m+1
%         x(1+((i-1)*7)) = 5; %x position
%         x(2+((i-1)*7)) = 0; %x velocity
%         x(3+((i-1)*7)) = 0; %y position
%         x(4+((i-1)*7)) = 0; %y velocity
%         x(5+((i-1)*7)) = 0; %angular position
%         x(6+((i-1)*7)) = 0; %angular velocity
%         x(7+((i-1)*7)) = n; %Number of sides
%     elseif i == m+2
%         x(1+((i-1)*7)) = -5; %x position
%         x(2+((i-1)*7)) = 0; %x velocity
%         x(3+((i-1)*7)) = 0; %y position
%         x(4+((i-1)*7)) = 0; %y velocity
%         x(5+((i-1)*7)) = 0; %angular position
%         x(6+((i-1)*7)) = 0; %angular velocity
%         x(7+((i-1)*7)) = n; %Number of sides
%     end
% end
end

