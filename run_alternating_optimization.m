function [best_delta,best_p,context,best_fitness,fitness_log,delta_log]=run_alternating_optimization(context,max_outer_iter)
    pop_size=50;
    generations=30;
    mutation_rate=0.2;
    crossover_param=0.5;

    delta=pi/4;  % initial
    best_fitness=-inf;
    best_delta=delta;
    best_p=ones(context.K,1)*(context.P/context.K);
    best_psi_t=context.psi_t;
    best_psi_r=context.psi_r;

    fitness_log=zeros(max_outer_iter,1);
    delta_log=zeros(max_outer_iter,1);

    for outer=1:max_outer_iter
        % Step 1: optimize delta
        context.psi_t=best_psi_t;
        context.psi_r=best_psi_r;
        delta=genetic_algorithm(pop_size,generations,context,crossover_param, mutation_rate);

        % Step 2: optimize power
        p=solve_power_allocation(delta,context);

        % Step 3: optimize TARCs
        [psi_r,psi_t]=solve_TARC(delta,p,context,true,20);
        context.psi_r=psi_r;
        context.psi_t=psi_t;

        % Step 4: evaluate
        fit=fitness_function(delta,context);
        if fit>best_fitness
            best_fitness=fit;
            best_delta=delta;
            best_p=p;
            best_psi_t = psi_t;
            best_psi_r = psi_r;
        else
            delta = best_delta;
            p = best_p;
            context.psi_t = best_psi_t;
            context.psi_r = best_psi_r;
            fit=best_fitness;
        end
        
        fitness_log(outer)=fit;
        delta_log(outer)=rad2deg(delta);
        fprintf("Result: delta = %.2f deg | fitness = %.4f\n", rad2deg(delta), fit);
    end
end
