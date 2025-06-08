function [F_t,F_k,h_eff] = channel_gain(chromosome,k,context)
    % h: channel from BS to STAR-RIS (N*1)
    % v_k: channel from STAR-RIS to UE_k (N*1)
    delta=chromosome;

    psi_r=context.psi_r;
    psi_t=context.psi_t;
    UE_positions=context.UE_positions;
    h=context.h;            % channel from BS to STAR-RIS
    v_all=context.v_all;    % channel from STAR-RIS to all users
                            % channel for k-th user in k-th row
    % var_n=context.var_n;
    
    v_k=v_all(k,:);
    UE_pos=UE_positions(k,:);

    % [rows,cols]=size(v_k);
    % fprintf("Matrix v_k has %d rows and %d columns.\n",rows,cols);
    % [rows1,cols1]=size(h);
    % fprintf("Matrix h has %d rows and %d columns.\n",rows1,cols1);


    q=2; Dm=1;

    n_ris=[sin(delta);cos(delta)];
    BS_to_RIS=[0;10];  
    RIS_to_UE=UE_pos(:)-[0;10];

    theta_t=acos(dot(BS_to_RIS,n_ris)/norm(BS_to_RIS));
    theta_k=acos(dot(RIS_to_UE,n_ris)/norm(RIS_to_UE));

    F_t = abs(cos(theta_t))^q;
    F_k = abs(cos(theta_k))^q;
   
    if theta_k < pi/2
        psi = psi_r;
    else
        psi = psi_t;
    end

    xi_k = Dm^2 * F_t * F_k * diag(psi);  % N×N

    % effective channel
    h_eff = v_k * xi_k * h;  % scalar

end