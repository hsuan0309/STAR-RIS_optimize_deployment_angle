function R_k=rate(chromosome,k,context)
    % k: k-th user
    % psi_r=context.psi_r;
    % psi_t=context.psi_t;
    % UE_positions=context.UE_positions;
    % h=context.h;            % channel from BS to STAR-RIS
    % v_all=context.v_all;    % channel from STAR-RIS to all users
    %                         % channel for k-th user in k-th row
    var_n=context.var_n;
    K=2;
    p_k=1/K;
    p_j=1/K;


    % signal power
    [F_t,F_k,h_eff_k]=channel_gain(chromosome,k,context);

    signal_power=((F_t)*(F_k)*abs(h_eff_k*p_k))^2;

    % interference
    interference=0;
    for j=1:K
        if j==k
            continue;
        end
        interference=interference+((F_t)*(F_k)*abs(h_eff_k*p_j))^2;
    end

    SINR=signal_power/(interference+var_n);
    R_k=log2(1+SINR);

end

    