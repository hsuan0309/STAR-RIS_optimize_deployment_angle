clear; clc;

K=2;                  % number of users
P=10^((30-30)/10);  % total power
N_list=[16,25,36];
P_list=[0.01,0.1,1];
max_outer_iter=20;

results=zeros(length(N_list),length(P_list));
num_of_realizations=3;

for i=1:length(N_list)
    for j=1:length(P_list)
        sum=0;
        for k=1:num_of_realizations
            fprintf("=== Running for N = %d, P = %ddBm ===\n", N_list(i), P_list(j));
            N=N_list(i);
            P=P_list(j);
            context=setup_context(N,K,P);
            [best_delta,best_p,context,best_fitness,fitness_log,delta_log]=run_alternating_optimization(context,max_outer_iter);
            sum=sum+best_fitness;
        end
        results(i,j)=sum/num_of_realizations;
    end
end

for i=1:length(N_list)
    for j=1:length(P_list)

        fprintf("=== Running for N = %d, P = %ddBm ===\n", N_list(i), P_list(j));
        N=N_list(i);
        P=P_list(j);
        context=setup_context(N,K,P);
        [best_delta,best_p,context,best_fitness,fitness_log,delta_log]=run_alternating_optimization(context,max_outer_iter);
        results(i,j)=best_fitness;
    end
end

figure;
plot(N_list, results, '-o', 'LineWidth', 2);
legend(arrayfun(@(x) sprintf('%dW', x), P_list, 'UniformOutput', false), 'Location', 'NorthWest');
xlabel('Number of RIS Elements (N)');
ylabel('Achievable Data Rate');
title('Data Rate vs. RIS Elements (for different Transmit Power)');
grid on;

%% === Plot fitness convergence ===
% figure;
% plot(1:max_outer_iter, fitness_log, '-o', 'LineWidth', 2);
% xlabel('Outer Iteration');
% ylabel('Data Rate');
% title('Overall Optimization Convergence');
% grid on;
% 
% figure;
% plot(1:max_outer_iter,delta_log,'-s','LineWidth',2);
% xlabel('Outer Iteration');
% ylabel('Deployment Angle (deg)');
% title('(Deployment Angle) Convergence');
% grid on;
% 
% 
% deltas = linspace(0, pi, 180);  % 從 0 到 pi
% fitness_vals = zeros(size(deltas));
% 
% for i = 1:length(deltas)
%     fitness_vals(i) = fitness_function(deltas(i), context);
% end
% 
% figure;
% plot(rad2deg(deltas), fitness_vals, 'LineWidth', 2);
% xlabel('Deployment Angle (deg)');
% ylabel('Fitness');
% title('Fitness Landscape vs Deployment Angle');
% grid on;