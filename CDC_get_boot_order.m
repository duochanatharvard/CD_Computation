% order = CDC_get_boot_order(N_total,N_block,N_sample,en)
% N_total:   Total number of points
% N_block:   Number of points in a block
% N_sample:  Total number of bootsrapping members
% en:        Which ensemble member
function order = CDC_get_boot_order(N_total,N_block,N_sample,en)

    rng(0);
    [~,boot_sample] = bootstrp(N_sample, @(x) [mean(x)], [1:N_total/N_block]);

    order = repmat(boot_sample(:,en)'*N_block-N_block,N_block,1);
    order = order + repmat([1:N_block]',1,size(boot_sample,1));
    order = order(:);
    
end