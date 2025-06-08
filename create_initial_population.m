function population = create_initial_population(pop_size) 

    population = cell(1, pop_size);
    for i = 1:pop_size
        population{i} = pi * rand();  % ∈ (0, π)
    end
end