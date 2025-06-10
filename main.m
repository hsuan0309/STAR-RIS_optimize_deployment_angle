clear; clc;
 
var_n=10^((-80-30)/10);  % Noise power in Watts
pop_size=50;
generations=30;
K=2;                  % number of users
P=10^((30-30)/10);  % total power
N=16;                 % number of STAR-RIS elements
crossover_param=0.5;
mutation_rate=0.2;

% user position (randomly distributed on a circle of r=3 centered at RIS)
r=3;
angles=2*pi*rand(K,1);
UE_positions=[r.*cos(angles),r.*sin(angles)+10]; % centered at (0,10)

% TARCs
% psi_r=sqrt(0.5)*exp(1j*2*pi*rand(N,1));
% psi_t=sqrt(0.5)*exp(1j*2*pi*rand(N,1));


% channels: all RIS elements are assumed to be at the same distance
%           from BS(10), and to UEs (3)
h=generate_rician_channel(10); % channel from BS to RIS
v_all=zeros(K,N);
for k=1:K
    v_all(k,:)=generate_rician_channel(3).'; % channel from RIS to UE k
end

% context struct
% context.psi_r=psi_r;
% context.psi_t=psi_t;
context.UE_positions=UE_positions;
context.h=h;
context.v_all=v_all;
context.var_n=var_n;

% Initial TARCs (random phase, balanced amplitude)
context.psi_t=sqrt(0.5)*exp(1j*2*pi*rand(N,1));
context.psi_r=sqrt(0.5)*exp(1j*2*pi*rand(N,1));

delta=pi/4; % initial deployment angle
max_outer_iter=20;
fitness_log=zeros(max_outer_iter,1);

% Initialize the best solution record
best_fitness=-inf;
best_delta=delta;
best_p=ones(K,1)*(P/K);
best_psi_t=context.psi_t;
best_psi_r=context.psi_r;

% Alternating optimization
for outer=1:max_outer_iter
    fprintf("\n=== Outer Iteration %d ===\n",outer);
    
    % deployment angle
    context.psi_t=best_psi_t;
    context.psi_r=best_psi_r;
    [delta,~]=genetic_algorithm(pop_size,generations,context,crossover_param,mutation_rate);
    
    % power allocation
    p=solve_power_allocation(delta,context);
    
    % TARCs
    use_penalty=true;
    lambda=20;
    [psi_r,psi_t]=solve_TARC(delta,p,context,use_penalty,lambda);
    context.psi_r=psi_r;
    context.psi_t=psi_t;


    % Evaluate fitness value
    fit=fitness_function(delta,context);

    if fit>best_fitness
        best_fitness=fit;
        best_delta=delta;
        best_p=p;
        best_psi_t=psi_t;
        best_psi_r=psi_r;
        fprintf("→ Accepted new best fitness: %.4f\n", fit);
    else
        fprintf("→ Reverted to previous best fitness: %.4f\n", best_fitness);
        delta=best_delta;
        p=best_p;
        context.psi_t=best_psi_t;
        context.psi_r=best_psi_r;
        fit=best_fitness;
    end

    fitness_log(outer)=fit;
    delta_log(outer)=rad2deg(delta);
    fprintf("Result: delta = %.2f deg | fitness = %.4f\n", rad2deg(delta), fit);
end

%% === Plot fitness convergence ===
figure;
plot(1:max_outer_iter, fitness_log, '-o', 'LineWidth', 2);
xlabel('Outer Iteration');
ylabel('Data Rate');
title('Overall Optimization Convergence');
grid on;

figure;
plot(1:max_outer_iter, delta_log, '-s', 'LineWidth', 2);
xlabel('Outer Iteration');
ylabel('Deployment Angle (deg)');
title('(Deployment Angle) Convergence');
grid on;


deltas = linspace(0, pi, 180);  % 從 0 到 pi 掃描
fitness_vals = zeros(size(deltas));

for i = 1:length(deltas)
    fitness_vals(i) = fitness_function(deltas(i), context);
end

figure;
plot(rad2deg(deltas), fitness_vals, 'LineWidth', 2);
xlabel('Deployment Angle (deg)');
ylabel('Fitness');
title('Fitness Landscape vs Deployment Angle');
grid on;