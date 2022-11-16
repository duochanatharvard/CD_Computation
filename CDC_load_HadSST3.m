% [HadSST3,lon,lat,yr] = CDC_load_HadSST3(en)

function [HadSST3,lon,lat,yr] = CDC_load_HadSST3(en)

    if ~exist('en','var'), en = 0;  end
    dir    = [CDC_other_temp_dir,'HadSST3/'];
    
    if en == 0
        file = [dir,'HadSST.3.1.1.0.median.nc'];
    elseif en == -1
        file = [dir,'HadSST.3.1.1.0.unadjusted.nc'];
    else
        file = [dir,'HadSST/HadSST.3.1.1.0.anomalies.',num2str(en),'.nc'];
    end

    HadSST3 = ncread(file,'sst');
    lon    = ncread(file,'longitude');
    lat    = ncread(file,'latitude');
    
    HadSST3(HadSST3>1000) = nan;
    HadSST3 = HadSST3([37:72 1:36],end:-1:1,:);
    lon    = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;
    lat    = lat(end:-1:1);

    Nt     = fix(size(HadSST3,3)/12)*12;
    HadSST3 = reshape(HadSST3(:,:,1:Nt),size(HadSST3,1),size(HadSST3,2),12,Nt/12);
    yr     = [1:Nt/12]+1849;
    
    if en == -1
        HadSST3 = HadSST3(:,[end:-1:1],:,:);
    end

    [yr_start,yr_end] = CDC_common_time_interval;
    [HadSST3, yr] = CDC_trim_years(HadSST3, yr, yr_start, yr_end);
    
end