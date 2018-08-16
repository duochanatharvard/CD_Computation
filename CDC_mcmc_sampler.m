% sample = CDC_mcmc_sampler(x,y,z,P,N)
% 
% CDC_mcmc_sampler is a simple MCMC sampler that takes value from a
% matrixrized ditribution. Now the function support up to three dimentions.
% x,y,z are parameters in each dimension
% P is the probability matrix
% N is number of samples to take, default = 1000.
% warm up by 10000 steps.
%
%
% Last Update: 2018-08-17

function sample = CDC_mcmc_sampler(x,y,z,P,N)


    if ~isempty(z),
        p0 = [ceil(numel(x)/2) ceil(numel(y)/2) ceil(numel(z)/2)];
        Dim = [numel(x) numel(y) numel(z)];
        D = 3;
    elseif ~isempty(y),
        p0 = [ceil(numel(x)/2) ceil(numel(y)/2)];
        Dim = [numel(x) numel(y)];
        D = 2;
    else
        p0 = ceil(numel(x)/2);
        Dim = [numel(x)];
        D = 1;
    end
    
    % Initiate the sampler ------------------------------------------------
    p_old = p0;
    
    % Loop to take samples ------------------------------------------------
    sample = [];
    N_warm = 10000;
    for ct = 1:N_warm+N

        % determine which dimension to move -------------------------------
        i = rem(ct,D) + 1;

        % Move to the next position ---------------------------------------
        a = randperm(5);
        b = sign(normrnd(0,1,1)) .* a(1);
        p_new = p_old;
        p_new(i) = p_old(i) + b;
        if p_new(i) > Dim(i), p_new(i) = Dim(i); end
        if p_new(i) < 1, p_new(i) = 1; end  

        % Get the probability of both positions ---------------------------
        switch D,
            case 3,
                P_old = P(p_old(1),p_old(2),p_old(3));
                P_new = P(p_new(1),p_new(2),p_new(3));
            case 2,
                P_old = P(p_old(1),p_old(2));
                P_new = P(p_new(1),p_new(2));
            case 1,
                P_old = P(p_old(1));
                P_new = P(p_new(1));
        end

        % Determine whether to accept the new sample ----------------------
        if P_new > P_old,
            p_old = p_new;
        else
            A = unifrnd(0,1,1);
            if A < (P_new / P_old);
                p_old = p_new;
            end
        end

        % Take samples ----------------------------------------------------
        if ct > N_warm,  % take samples

            switch D,
                case 3,
                    temp = [x(p_old(1)) y(p_old(2)) z(p_old(3))];
                case 2,
                    temp = [x(p_old(1)) y(p_old(2))];
                case 1,
                    temp = [x(p_old(1))];
            end
            sample = [sample; temp]; %#ok<AGROW>
        end
    end
end
    
            