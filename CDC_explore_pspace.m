% log_L = CDC_explore_pspace(X,Y,W,sigma_2,b1,b2,beta_01,beta_02)
% 
% CDF_visual_fitting explores the parameter space of the linear model:
%                         y = ax + b
% 
% and returns the log likelihood on a mesh grid, which
% can be used to visualize the probability space of the fitting 
% In this model, individual points are assumed to be independent
%  
% Inputs are:
%  - X: should be nx2 matrix, with x1 being x and x2 being ones
%  - Y: data to be fitted 
%  - V: variance matrix, which is inverse of the weight
%  - sigma_2: error of fitting
%  - a and b: MLE of slope and intercept, respectively,
%  - a_grid and b_grid: range of a and b to be explored.
% 
% In principle, this function is recommanded to be used with - lscov:
% [b,STDX,MSE] = lscov(X,Y,W);
% such that sigma_2 is the MSE.
% 
% Here is a simple demo of how to call this function:
%         
%     A = normrnd([1:1:100]'/10,0,100,1);
%     B = A * 0.4 + normrnd(0,1,100,1);
%     [b,STDX,MSE] = lscov([A ones(100,1)],B,ones(100,1));
%     a_grid = [-0.1 : 0.001 : 0.1];
%     b_grid = [-0.1 : 0.0005 : 0.1]*5;
%     V = eye(100);
%     sigma_2 = MSE;
%     log_L = CDC_expolre_pspace([A ones(100,1)],B,V,sigma_2,b(1),b(2),a_grid,b_grid);
%     P = CDC_prob(log_L);
%     contourf(b(1)+a_grid,b(2)+b_grid,P','linest','none')
%     [out_int,out_para,MLE] = CDC_conf_int(b(1)+a_grid,b(2)+b_grid,[],P,0.8);
%     hold on;
%     contour(b(1)+a_grid,b(2)+b_grid,out_int',[1 1]/2,'w-','linewi',2)
%     caxis([0 max(P(:))]);
% 
% Last update: 2018-08-09


function log_L = CDC_explore_pspace(X,Y,V,sigma_2,a,b,a_grid,b_grid)

    N = numel(Y);

    a_mesh = repmat(a_grid',1,numel(b_grid)) + a;
    b_mesh = repmat(b_grid ,numel(a_grid),1) + b;
    
    rep_list = [1,1,N];
    rep_list_2 = [size(a_mesh,1),size(b_mesh,2),1];
    
    X_mat_1 = repmat(reshape(X(:,1),rep_list),rep_list_2);
    X_mat_2 = repmat(reshape(X(:,2),rep_list),rep_list_2);
    
    a_mat = repmat(a_mesh,1,1,N);
    b_mat = repmat(b_mesh,1,1,N);
    
    Y_hat = X_mat_1 .* a_mat + X_mat_2 .* b_mat;
    Y_mat = repmat(reshape(Y,rep_list),rep_list_2);
    
    V_mat = repmat(reshape(diag(V),rep_list),rep_list_2);
    
    log_L = - 0.5 ./ sigma_2 .* CDC_nansum((Y_mat - Y_hat).^2 ./ V_mat,3);
    

end