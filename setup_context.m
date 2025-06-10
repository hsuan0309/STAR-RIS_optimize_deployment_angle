function context = setup_context(N,K,P)
    var_n=10^((-80-30)/10); % noise power in Watts
    
    % UE position (on circle)
    r=3;
    angles=2*pi*rand(K,1);
    UE_positions=[r.*cos(angles),r.*sin(angles)+10];

    % Channels
    h=generate_rician_channel(10,N);  % BS to RIS
    v_all=zeros(K, N);
    for k=1:K
        v_all(k,:)=generate_rician_channel(3,N).'; % RIS to UE_k
    end

    % Initial random TARCs
    psi_t=sqrt(0.5)*exp(1j*2*pi*rand(N, 1));
    psi_r=sqrt(0.5)*exp(1j*2*pi*rand(N, 1));

    % Pack context
    context.N=N;
    context.K=K;
    context.P=P;
    context.UE_positions=UE_positions;
    context.h=h;
    context.v_all=v_all;
    context.var_n=var_n;
    context.psi_t=psi_t;
    context.psi_r=psi_r;
end
