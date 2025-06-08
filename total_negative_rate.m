function total_loss = total_negative_rate(delta, p, context)
    K = length(p);
    total_loss = 0;
    for k = 1:K
        [F_t, F_k, h_eff] = channel_gain(delta, k, context);
        gain = (F_t * F_k * abs(h_eff))^2;
        interference = 0;
        for j = 1:K
            if j ~= k
                interference = interference + gain * p(j);
            end
        end
        SINR = gain * p(k) / (interference + context.var_n);
        R_k = log2(1 + SINR);
        total_loss = total_loss - R_k;
    end
end