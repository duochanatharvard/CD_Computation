function [data_gl,data_sh,data_nh] = CDC_hemi_sum(data,area)

    mask_gl = ones(size(data,1),size(data,2));
    data_gl = CDC_mask_sum(data,area,mask_gl);
    
    mask_sh = [ones(size(data,1),size(data,2)/2) zeros(size(data,1),size(data,2)/2)];
    data_sh = CDC_mask_sum(data,area,mask_sh);
    
    mask_nh = [zeros(size(data,1),size(data,2)/2) ones(size(data,1),size(data,2)/2)];
    data_nh = CDC_mask_sum(data,area,mask_nh);
end

function out = CDC_mask_sum(input,area,mask)

    size_temp = size(input);

    WEIGH = repmat(area,[1 1 size_temp(3:end)]);
    MASK  = repmat(mask ,[1 1 size_temp(3:end)]);

    WEIGH(MASK == 0) = 0;
    input(MASK == 0) = NaN;
    WEIGH(isnan(input)) = 0;

    out = nansum(nansum(input.*WEIGH,1),2);
    out = squeeze(out);
end