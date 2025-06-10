clear; clc;

K=2;                  % number of users
P=10^((30-30)/10);  % total power
N=16;                 % number of STAR-RIS elements
max_outer_iter=20;

% context struct
context=setup_context(N,K,P);

[best_delta,best_p,context,best_fitness,fitness_log,delta_log]=run_alternating_optimization(context,max_outer_iter);

%% === Plot fitness convergence ===
figure;
plot(1:max_outer_iter, fitness_log, '-o', 'LineWidth', 2);
xlabel('Outer Iteration');
ylabel('Data Rate');
title('Overall Optimization Convergence');
grid on;

figure;
plot(1:max_outer_iter,delta_log,'-s','LineWidth',2);
xlabel('Outer Iteration');
ylabel('Deployment Angle (deg)');
title('(Deployment Angle) Convergence');
grid on;


deltas = linspace(0, pi, 180);  % 從 0 到 pi
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