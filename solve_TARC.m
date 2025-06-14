function [psi_r,psi_t]=solve_TARC(delta,p,context,use_penalty,lambda)
    N=length(context.h);
    K=length(p);
    max_iter=50; % maximum number of iterations
    alpha=0.05;  % learning rate for gradient descent
    
    if nargin<5
        lambda=20;   % penalty strength
    end

    % early stopping variables
    prev_loss=inf;
    tol=1e-4;

    phi_t=2*pi*rand(N,1);
    phi_r=2*pi*rand(N,1);
    beta_t=rand(N,1);
    beta_t=min(max(beta_t,0),1);

    for iter=1:max_iter
        psi_t=sqrt(beta_t).*exp(1j*phi_t);
        psi_r=sqrt(1-beta_t).*exp(1j*phi_r);

        context.psi_t=psi_t;
        context.psi_r=psi_r;

        loss=total_negative_rate(delta,p,context);

        penalty=sum(beta_t-0.5).^2;
        if use_penalty
            loss=loss+lambda*penalty;
        end

        % numerical gradient
        grad_phi_t=zeros(N,1);
        grad_phi_r=zeros(N,1);
        grad_beta_t=zeros(N,1);
        epsilon=1e-5;

        for n=1:N
            % phi_t
            phi_t_eps=phi_t;
            phi_t_eps(n)=phi_t(n)+epsilon; % n-th phase being added by epsilon
            psi_t_eps=sqrt(beta_t).*exp(1j*phi_t_eps);
            context.psi_t=psi_t_eps;
            loss_eps=total_negative_rate(delta,p,context);
            if use_penalty
                loss_eps=loss_eps+lambda*sum((beta_t-0.5).^2);
            end
            grad_phi_t(n)=(loss_eps-loss)/epsilon;
            
            % phi_r
            phi_r_eps=phi_r;
            phi_r_eps(n)=phi_r(n)+epsilon; % n-th phase being added by epsilon
            psi_r_eps=sqrt(1-beta_t).*exp(1j*phi_r_eps);
            context.psi_t=psi_t;
            context.psi_r=psi_r_eps;
            loss_eps=total_negative_rate(delta,p,context);
            if use_penalty
                loss_eps=loss_eps+lambda*sum((beta_t-0.5).^2);
            end
            grad_phi_r(n)=(loss_eps-loss)/epsilon;

            % beta_t 
            beta_eps=beta_t; 
            beta_eps(n)=min(max(beta_t(n)+epsilon,0),1);
            psi_t_eps=sqrt(beta_eps).*exp(1j*phi_t);
            psi_r_eps=sqrt(1-beta_eps).*exp(1j*phi_r);
            context.psi_t=psi_t_eps; 
            context.psi_r=psi_r_eps;
            loss_eps=total_negative_rate(delta,p,context);
            if use_penalty
                loss_eps=loss_eps+lambda*sum((beta_eps-0.5).^2);
            end
            grad_beta_t(n)=(loss_eps-loss)/epsilon;
        end

        % gradient descent update 
        phi_t=mod(phi_t-alpha*grad_phi_t,2*pi);
        phi_r=mod(phi_r-alpha*grad_phi_r,2*pi);
        beta_t=beta_t-alpha*grad_beta_t;
        beta_t=min(max(beta_t,0),1);

        fprintf("TARC iter %d | Loss: %.4f | Penalty: %.4f\n", iter, loss, penalty);
        
        % Early stopping check
        if abs(loss-prev_loss)<tol
            fprintf("Early stopped at iter %d (loss stable)\n",iter);
            break;
        end
        prev_loss=loss;
    end

    psi_t=sqrt(beta_t).*exp(1j*phi_t);
    psi_r=sqrt(1-beta_t).*exp(1j*phi_r);
end