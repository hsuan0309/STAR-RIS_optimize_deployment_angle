function fitness = fitness_function(chromosome, context)
    K=2;
    fitness=0;
    for k=1:K
        R_k=rate(chromosome,k,context);
        fitness=fitness+R_k;
    end
    fitness=fitness;
end
