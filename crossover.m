function [child1, child2] = crossover(parent1, parent2)

    alpha = rand();  
    beta = 1 - alpha;

    child1 = alpha * parent1 + beta * parent2;
    child2 = beta * parent1 + alpha * parent2;

    % Ensure the offspring are within the valid range [0,pi]
    child1 = max(0, min(pi, child1));
    child2 = max(0, min(pi, child2));
end
