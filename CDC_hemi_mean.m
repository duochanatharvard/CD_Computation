function [data_gl,data_sh,data_nh] = CDC_hemi_mean(data)

    reso_y = 180/size(data,2);
    lat    = (reso_y/2:reso_y:180)-90;

    mask_gl = ones(size(data,1),size(data,2));
    data_gl = CDC_mask_mean(data,lat,mask_gl);
    
    mask_sh = [ones(size(data,1),size(data,2)/2) zeros(size(data,1),size(data,2)/2)];
    data_sh = CDC_mask_mean(data,lat,mask_sh);
    
    mask_nh = [zeros(size(data,1),size(data,2)/2) ones(size(data,1),size(data,2)/2)];
    data_nh = CDC_mask_mean(data,lat,mask_nh);
end