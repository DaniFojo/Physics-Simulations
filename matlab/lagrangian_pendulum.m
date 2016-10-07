% This is a numerical simulation of a pendulum with a massless pivot arm, 
% using lagrangian formulation.

% User Defined Parameters
% Define external parameters
G = 9.8;
dt = 1/1000; %Decreasing this will increase simulation accuracy
T = 100000;
 
% Define pendulum
rodPivotPoint = [2 2]; %rectangular coordinates
r = 1;
mass = 1; %of the bob
radius = .2; %of the bob
theta = pi/4; %radians, defines initial position of the bob
theta1 = 0; %angular velocity
 
% Simulation
 
position = rodPivotPoint - (r*[-sind(theta) cosd(theta)]); %in rectangular coordinates
 
% Generate graphics, render pendulum
figure;
axesHandle = gca;
xlim(axesHandle, [(rodPivotPoint(1) - r - radius) (rodPivotPoint(1) + r + radius)] );
ylim(axesHandle, [(rodPivotPoint(2) - r - radius) (rodPivotPoint(2) + r + radius)] );
 
rectHandle = rectangle('Position',[(position - radius/2) radius radius],...
    'Curvature',1,'FaceColor','r'); %Pendulum bob
hold on
plot(rodPivotPoint(1),rodPivotPoint(2),'^'); %Pendulum pivot
lineHandle = line([rodPivotPoint(1) position(1)],...
     [rodPivotPoint(2) position(2)]); %Pendulum rod
hold off
 
% Run simulation, all calculations are performed in cylindrical coordinates
for time = (0:dt:T)
 
    drawnow; %Forces MATLAB to render the pendulum
 
    theta2 = -G/radius*sin(theta);
    theta1 = theta1 + theta2*dt;
    theta = theta + theta1*dt;
 
    position = rodPivotPoint - (r*[-sin(theta) cos(theta)]);
 
    % Update figure with new position info
    set(rectHandle,'Position',[(position - radius/2) radius radius]);
    set(lineHandle,'XData',[rodPivotPoint(1) position(1)],'YData',...
        [rodPivotPoint(2) position(2)]);
 
end