%This is a numerical simulation of a double pendulum with massless pivot arms.
 
% User Defined Parameters
%Define external parameters
G = 9.8;
dt = 1/800; %Decreasing this will increase simulation accuracy
T = 100000;
 
%Define pendulum
pivot = [3 3]; %rectangular coordinates
L1 = 1; %first bar
L2 = 1; %second bar
M1 = 1; %of the first bob
M2 = 1.5; %of the second bob
R1 = .2*M1; %radius of the first bob (proportional to the mass)
R2 = .2*M2; %radius of the second bob (proportional to the mass)
theta1 = pi/2; %radians, defines initial position of the first bob
dtheta1 = 0; %angular velocity of the first bob
theta2 = 0; %radians, defines initial position of the second bob
dtheta2 = 0; %angular velocity of the second bob
 
% Simulation
 
p1 = pivot - (L1*[-sin(theta1) cos(theta1)]); 
p2 = p1 - (L2*[-sin(theta2) cos(theta2)]); 

%Generate graphics, render pendulum
figure;
axesHandle = gca;
xlim(axesHandle, [(pivot(1) - (L1 + L2) - (R1 + R2)) (pivot(1) + (L1 + L2) + (R1 + R2))]);
ylim(axesHandle, [(pivot(2) - (L1 + L2) - (R1 + R2)) (pivot(2) + (L1 + L2) + (R1 + R2))]);
 
bob1 = rectangle('Position',[(p1 - R1/2) R1 R1],...
    'Curvature',1,'FaceColor','r'); 
bob2 = rectangle('Position',[(p2 - R2/2) R2 R2],...
    'Curvature',1,'FaceColor','r'); 
hold on
plot(pivot(1),pivot(2),'^'); %pendulum pivot
line1 = line([pivot(1) p1(1)],...
     [pivot(2) p1(2)]); 
line2 = line([p1(1) p2(1)],...
     [p1(2) p2(2)]); 
hold off
 
%Run simulation, all calculations are performed in cylindrical coordinates
for time = (0:dt:T)
    
    drawnow; %Forces MATLAB to render the pendulum
    
    del = theta2 - theta1;
    den1 = (M1 + M2)*L1 - M2*L1*cos(del)*cos(del);
    ddtheta1 = (M2*L1*dtheta1^2*sin(del)*cos(del) + ...
               M2*G*sin(theta2)*cos(del) + ...
               M2*L2*dtheta2^2*sin(del) - ...
               (M1 + M2)*G*sin(theta1))/den1;
           
    den2 = (L2/L1)*den1;
    ddtheta2 = (-M2*L2*dtheta2^2*sin(del)*cos(del) + ...
               (M1 + M2)*G*sin(theta1)*cos(del) - ...
               (M1 + M2)*L1*dtheta1^2*sin(del) - ...
               (M1 + M2)*G*sin(theta2))/den2;
    
    dtheta1 = dtheta1 + dt*ddtheta1;
    dtheta2 = dtheta2 + dt*ddtheta2;
    
    theta1 = theta1 + dt*dtheta1;
    theta2 = theta2 + dt*dtheta2;
    
    p1 = pivot - (L1*[-sin(theta1) cos(theta1)]);
    p2 = p1 - (L2*[-sin(theta2) cos(theta2)]);
 
    %Update figure with new position info
    set(bob1,'Position',[(p1 - R1/2) R1 R1]);
    set(bob2,'Position',[(p2 - R2/2) R2 R2]);
    set(line1,'XData',[pivot(1) p1(1)],'YData',...
        [pivot(2) p1(2)]);
    set(line2,'XData',[p1(1) p2(1)],'YData',...
        [p1(2) p2(2)]);
 
end