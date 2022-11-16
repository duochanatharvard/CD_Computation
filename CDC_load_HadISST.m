% [HadISST,lon,lat,yr] = CDC_load_HadISST

function [HadISST,lon,lat,yr] = CDC_load_HadISST

    % HadISST
    dir    = [CDC_other_temp_dir,'HadISST/'];
    file = [dir,'HadISST_sst.nc'];

    HadISST = ncread(file,'sst');
    lon     = ncread(file,'longitude');
    lat     = ncread(file,'latitude');
    HadISST(HadISST<-99) = nan;
    HadISST = HadISST([181:360 1:180],end:-1:1,:);
    lon     = lon([181:360 1:180]);  lon(lon<0) = lon(lon<0) + 360;
    lat     = lat(end:-1:1);
    
    Nt     = fix(size(HadISST,3)/12)*12;
    HadISST = reshape(HadISST(:,:,1:Nt),size(HadISST,1),size(HadISST,2),12,Nt/12);
    yr     = [1:Nt/12]+1869;
    
    [yr_start,yr_end] = CDC_common_time_interval;
    [HadISST, yr] = CDC_trim_years(HadISST, yr, yr_start, yr_end);
end