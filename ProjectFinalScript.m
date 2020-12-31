%Charles Villazor
%November 3rd, 2020
%MAE 361
%Final Project Script
clc;clear;close all
%% This is a dice rolling simulator
%Roll die in a realistic way. Polygonic shapes will be used to simulate
%different die.
%Triangle is 3 sides (3 different numbers)
%Square is 4 sides (4 different numbers)
%Pentagon is 5 sides (5 different numbers)
%etc.
%% Initial Conditions
%m has to be at least 1, n has to be at least 2
n = 5; %This is the number of probabilites you want (sides of die per die)
m = 1; %Number of die you want
x = init(n,m); %initial conditions
deltaT = 0.01; %Time step
N = 500; %Amount of steps
l = 1; %Radius
save = false; %If you want to save the animation. Not saved = false, Saved = True
%% Numerical Integration
%pre allocation
for i = 1:m
    xgraphs{i} = zeros(1,N);
    ygraphs{i} = zeros(1,N);
    theta_graphs{i} = zeros(1,N);
end
time = zeros(1,N);
%function
for i = 1:N
    t = (i-1)*deltaT;
    xnew = step2('name_state',x,t,deltaT);
    for k = 1:m
        xgraphs{k}(i) = x(1+(7*(k-1)));
        ygraphs{k}(i) = x(3+(7*(k-1)));
        theta_graphs{k}(i) = x(5+(7*(k-1)));
    end
    time(i) = t;
    x = xnew;
end
%% Determining Random Number
rolledNumber = 0; % Pre-allocation
for i = 1:m
    rolledNumber = rolledNumber + randi(n); %Determines rolled number. the dice do not mean anything
end
%% Determining side length
sideLength = 2*l*sin(pi/n);
%% Movie (With trajectory, centers, and collision circles plotted)
figure (5)
grid on
for i = 1:length(xgraphs{1})
    clf() %Clears figure
    %Set up figure boundaries
    line([-6,6],[-1,-1],'Color','k','LineStyle',':','LineWidth',0.75)
    line([-6,-6],[-1,10],'Color','k','LineStyle',':','LineWidth',0.75)
    line([6,6],[-1,10],'Color','k','LineStyle',':','LineWidth',0.75)
    hold on
    for k = 1:m %Sets polygon location and angular position
        poly(k) = rotate(nsidedpoly(n,'Center',[xgraphs{k}(i) ygraphs{k}(i)],'SideLength', sideLength),...
            -rad2deg(theta_graphs{k}(i)),[xgraphs{k}(i) ygraphs{k}(i)]);
    end
    %Plotting polygon
    for k = 1:m
        plot(poly(k),'FaceAlpha',0,'LineWidth',1.5)
    end
    %Plotting Centers
    for k = 1:m
        scatter(xgraphs{k}(i),ygraphs{k}(i),'k','filled') %shows the center of the circle
    end
    %Plotting Trajectory of die
    for k = 1:m
        plot(xgraphs{k},ygraphs{k},'k'); %Trajectory of die
    end
    %Plots collision circle for die
    for k = 1:m
        circle(xgraphs{k}(i),ygraphs{k}(i),l); %plots circle around the center of the circle 
    end
    %Displays time
    text(-2,12,['Time:' string(time(i))]);
    %Displays what is rolled at the end
    if i == N
        text(2, 12, ['You Rolled a:' string(rolledNumber)])
    end
    hold off
    axis([-8,8,-2,14]); %Sets the boundaries for the axes, [-8,8] for x and [-2,14] for y
    %set(gca,'xtick',0:1:10) %sets the scale for the x axis
    %set(gca,'ytick',-5:1:5) %sets the scale for the y axis
    movie(i) = getframe;
end
%% Movie (Video ready)
if save == true
    figure(6)
    for i = 1:length(xgraphs{1})
        clf() %Clears figure
        %Set up figure boundaries
        line([-6,6],[-1,-1],'Color','k','LineStyle',':','LineWidth',0.75)
        line([-6,-6],[-1,10],'Color','k','LineStyle',':','LineWidth',0.75)
        line([6,6],[-1,10],'Color','k','LineStyle',':','LineWidth',0.75)
        hold on
        for k = 1:m %Sets polygon location and angular position
            poly(k) = rotate(nsidedpoly(n,'Center',[xgraphs{k}(i) ygraphs{k}(i)],'SideLength', sideLength),...
                -rad2deg(theta_graphs{k}(i)),[xgraphs{k}(i) ygraphs{k}(i)]);
        end
        %Plotting polygon
        for k = 1:m
            plot(poly(k),'FaceAlpha',0,'LineWidth',1.5)
        end
    %     %Plotting Centers
    %     for k = 1:m
    %         scatter(xgraphs{k}(i),ygraphs{k}(i),'k','filled') %shows the center of the circle
    %     end
    %     %Plotting Trajectory of die
    %     for k = 1:m
    %         plot(xgraphs{k},ygraphs{k},'k'); %Trajectory of die
    %     end
    %     %Plots collision circle for die
    %     for k = 1:m
    %         circle(xgraphs{k}(i),ygraphs{k}(i),1); %plots circle around the center of the circle 
    %     end
        %Displays time
        text(-2,12,['Time:' string(time(i))]);
        %Displays what is rolled at the end
        if i == N
            text(2, 12, ['You Rolled a:' string(rolledNumber)])
        end
        hold off
        axis([-8,8,-2,14]); %Sets the boundaries for the axes, [-8,8] for x and [-2,14] for y
        %set(gca,'xtick',0:1:10) %sets the scale for the x axis
        %set(gca,'ytick',-5:1:5) %sets the scale for the y axis
        film(i) = getframe(figure(6));
    end
    writerObj = VideoWriter('DiceRolling1.avi'); %Change the name if you want a video with a different name
    writerObj.FrameRate = 30;
    open(writerObj);
    for i=1:length(film)
        frame = film(i) ;    
        writeVideo(writerObj, frame);
    end
    close(writerObj);
end
