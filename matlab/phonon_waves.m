N = 20; %Number of particles.
T = 100000; %Number of time increments.
t = 100; %How many stages we skip after saving the next one
k = 0.000001; %Elastic constant.
particles = zeros(N,1);

X = zeros(T/t, N); %positions

V = zeros(T/t, N); %velocities

Xt = zeros(1,N); %temporal variable + intial condition
Vt = zeros(1,N); %temporal variable + intial condition
Xt(1,1) = 0.2;
Vt(1,15) = 0.0001;

A = zeros(1,N); %accelerations


% Solve using Euler's method
for i = 1:T
    for j = 1:N
        if j == 1
            A(j) = -2*k*Xt(j) + k*Xt(N) + k*Xt(j+1);
        elseif j == N
            A(j) = -2*k*Xt(j) + k*Xt(j-1) + k*Xt(1);    
        else
            A(j) = -2*k*Xt(j) + k*Xt(j-1) + k*Xt(j+1);  
        end
    end
    Xt = Xt + Vt;
    Vt = Vt + A;
    if mod(i,t) == 0
        X(i/t, :) = Xt;
        V(i/t, :) = Vt;
    end
end

% Graphics
figure;
axesHandle = gca;
xlim(axesHandle, [-2 N + 2]);
ylim(axesHandle, [ceil(-N/2) - 2, + ceil(N/2) + 2 ]);
for j = 0:N - 1
        particles(j+1) = rectangle('Position',[(j - .3) -.3 .6 .6],...
        'Curvature',1,'FaceColor','r');
end

% Animation
for i = 1:T/t
    for j = 0:N-1
        set(particles(j+1), 'Position', [j + X(i,j+1) - .3 -.3, .6, .6]);
    end
    title('Positions')
    drawnow;
    pause(.01); %pause to slow down the animation
end


        
