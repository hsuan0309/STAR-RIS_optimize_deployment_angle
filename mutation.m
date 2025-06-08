function mutated = mutation(chromosome, mutation_rate)
    if rand() < mutation_rate
        perturbation = 0.5 * (2*rand() - 1);  % [-0.2, 0.2]
        mutated = chromosome + perturbation;
        mutated = mod(mutated, pi);  % [0, π)
    else
        mutated = chromosome;
    end
end
