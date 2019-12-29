function [L_save,L_3d] = CDC_3D_profile_Gaussian(L_profile,lon_target,lat_target,ct_lon,sig_lon,ct_lat,sig_lat)

    a = repmat(normpdf(lon_target,ct_lon,sig_lon)',1,numel(lat_target));
    b = repmat(normpdf(lat_target,ct_lat,sig_lat),numel(lon_target),1);
    
    c = a.*b;  c = c ./ max(c(:));

    L_3d = repmat(c,1,1,numel(L_profile)) .* ...
        repmat(reshape(L_profile,1,1,numel(L_profile)),size(c,1),size(c,2));

    L_save = reshape(L_3d,size(L_3d,1),size(L_3d,2)*size(L_3d,3));

end