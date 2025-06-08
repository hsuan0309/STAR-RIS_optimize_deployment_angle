function selected = selection(population, fitness, num_select)
    % Roulette wheel selection

    fitness = fitness - min(fitness);
    if all(fitness == 0)
        prob = ones(size(fitness)) / length(fitness); 
    else
        prob = fitness / sum(fitness);  
    end

    idx = randsample(1:length(population), num_select, true, prob);  
    selected = population(idx);  % cell array output
end