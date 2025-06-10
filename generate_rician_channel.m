function h = generate_rician_channel(d,N)

    rho_0 = 1e-5;                
    K = 10^(5 / 10);               % dB to watts
    lambda = (3*1e8) / (28*1e9);     % f = 28GHz                 
    phase = -2 * pi * d / lambda;

    % LoS and NLoS 
    h_bar = exp(1j * phase)*ones(N,1);       % LoS 
    h_tilde = (randn(N,1) + 1j * randn(N,1)) / sqrt(2);  % CN(0,1)

    scale = sqrt(rho_0 / d^2);
    h = scale * (sqrt(K / (1 + K)) * h_bar + sqrt(1 / (1 + K)) * h_tilde);
end
