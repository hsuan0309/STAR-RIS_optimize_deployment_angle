function p_opt = solve_power_allocation(delta, context)
    K = size(context.UE_positions, 1);
    P = 1;  % total power
    var_n = context.var_n;

    gain = zeros(K, 1);
    for k = 1:K
        [F_t, F_k, h_eff] = channel_gain(delta, k, context);
        gain(k) = (F_t * F_k * abs(h_eff))^2;
    end

    % 先給定一組初始 power（均分）
    p_init = ones(K,1) * (P/K);

    % 根據初始 power 計算固定 interference
    fixed_interf = zeros(K,1);
    for k = 1:K
        interf = 0;
        for j = 1:K
            if j ~= k
                interf = interf + gain(k) * p_init(j);
            end
        end
        fixed_interf(k) = interf + var_n;
    end

    cvx_begin quiet
        variable p(K) nonnegative
        expression SINR(K)

        for k = 1:K
            SINR(k) = gain(k) * p(k) / fixed_interf(k);  % denominator is constant
        end

        maximize( sum(log(1 + SINR)) / log(2) )
        subject to
            sum(p) <= P;
    cvx_end

    p_opt = p;
end
