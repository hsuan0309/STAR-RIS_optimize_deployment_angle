function flag = terminated_condition(history, patience, tol)
    % history: vector that stores the best fitness value 
    %          of the population for each generation
    % patience: how many generations you're willing to wait
    %           and see before concluding that there's 
    %           no more significant progress
    % tol: minimum change to consider "improvement"
    
    flag = false;
    len = length(history);

    if len >= patience
        recent = history(end-patience+1:end);
        delta = max(recent) - min(recent);
        if delta < tol
            flag = true;
        end
    end
end
