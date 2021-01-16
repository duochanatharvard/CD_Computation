% AMO = CDC_calculate_AMO(SST,lon,lat,if_monthly)
%
% Annual smoothed AMO index following Trenberth and Shea, 2006. 
% Observed AMO index, defined as detrended 10-year low-pass filtered annual 
% mean area-averaged SST anomalies over the North Atlantic basin (0N-65N, 
% 80W-0E), using HadISST dataset (Rayner et al. 2003) for the period 1870-2015.

function [AMO,SST_resi] = CDC_calculate_AMO(SST,lon,lat,if_monthly)

    N_yrs = fix(size(SST,3)/12);
    SST   = SST(:,:,1:(N_yrs*12));
    
    % SST anomalies
    SST   = CDC_demean(SST,3,12);

    % annual mean
    if if_monthly == 1
        SST = reshape(SST,size(SST,1),size(SST,2),12,N_yrs);
        SST = squeeze(nanmean(SST,3));
    end
    
    % area-averaged 
    SST_global = CDC_mask_mean(SST,lat(1,:),ones(numel(lon),numel(lat)));
    
    % over the North Atlantic basin (0N-65N, 80W-0E),
    if min(size(lon)) == 1
        [lat,lon] = meshgrid(lat,lon);
    end
    l_lon = (lon < 360 & lon > 280) | (lon < 0 & lon > -80);
    l_lat = lat > 0 & lat < 65;
    l = repmat(l_lon & l_lat, 1, 1, size(SST,3));
    SST(~l) = nan;
    
    SST_mean = CDC_mask_mean(SST,lat(1,:),l(:,:,1));

    % detrended 
    SST_resi = SST_mean - SST_global;
        
    % 10-year low-pass filtered
    AMO = CDC_filter(SST_resi,'l',10,1);
    
end