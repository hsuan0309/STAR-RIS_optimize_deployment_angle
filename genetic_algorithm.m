function [best_solution,fitness_history,angle_history]=genetic_algorithm(pop_size,generations,context,crossover_param,mutation_rate)
    population=create_initial_population(pop_size);

    % evaluate the initial fitness value
    fitness=zeros(1,pop_size);
    for i=1:pop_size
        fitness(i)=fitness_function(population{i},context);
    end
    fitness_history=zeros(1,generations);
    angle_history=zeros(1,generations);
    
    % Elitism (store best solution so far)
    [prev_best_fitness,prev_best_idx]=max(fitness);
    prev_best_solution=population{prev_best_idx};

    % Early stopping condition parameters
    % patience=10;
    % tol=1e-4;

    for gen=1:generations
        % Retain top 10% of the original individuals to the next generation
        num_elite=max(1,round(0.1*pop_size));
        [~,sorted_idx]=sort(fitness,'descend');
        new_population=cell(1,pop_size);
        for i=1:num_elite
            new_population{i}=population{sorted_idx(i)};
        end

        % num_elite=0;
        
        % Roulette wheel selection and crossover for the rest individuals
        num_mating=2*floor((pop_size-num_elite)/2); % ensure even number 
        selected=selection(population,fitness,num_mating);

        mating_idx=1;
        for i=num_elite+1:2:(pop_size-1)
            parent1=selected{mating_idx};
            parent2=selected{mating_idx+1};

            if rand()<crossover_param
                [child1,child2]=crossover(parent1,parent2);
            else
                child1=parent1;
                child2=parent2;
            end
            child1=mutation(child1,mutation_rate);
            child2=mutation(child2,mutation_rate);
            
            new_population{i}=child1;
            % if i+1 <=pop_size
            %     new_population{i+1}=child2;
            % end
            new_population{i+1}=child2;
            mating_idx=mating_idx+2;
        end
        if any(cellfun(@isempty, new_population))
            missing_idx = find(cellfun(@isempty, new_population));
            for m = 1:length(missing_idx)
                new_population{missing_idx(m)} = population{randi(pop_size)};
            end
        end


        population=new_population;
        for i=1:pop_size
            fitness(i)=fitness_function(population{i},context);
            % fprintf('%.1f ', rad2deg(new_population{i}));
            % fprintf('%.6f ', fitness(i));
        end

        % Reinsert prev best sol if current generation is worse
        [current_best_fitness,best_idx]=max(fitness);
        if current_best_fitness<prev_best_fitness
            [~,worst_idx]=min(fitness);
            population{worst_idx}=prev_best_solution;
            fitness(worst_idx)=prev_best_fitness;
            disp(['→ Reinserted previous best solution at generation ', num2str(gen)]);
        else
            prev_best_fitness=current_best_fitness;
            prev_best_solution=population{best_idx};
        end

        % record fitness history
        fitness_history(gen)=max(fitness);
        angle_history(gen)=population{best_idx};
        disp(['Generation ', num2str(gen), ...
         ' | Best Fitness = ', sprintf('%.6e', fitness_history(gen)), ...
        ' | Best Angle = ', sprintf('%.2f deg', rad2deg(population{best_idx}))]);

        % terminate condition

        % if terminated_condition(fitness_history,patience,tol)
        %     disp(['Terminated early at generation ',num2str(gen)]);
        %     fitness_history=fitness_history(1:gen); % Trim unused tail
        %     break;
        % end
  

    end

    [~,best_idx]=max(fitness);
    best_solution=population{best_idx};

end