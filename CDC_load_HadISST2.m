% [HadISST2,lon,lat,yr] = CDC_load_HadISST2(en)

function [HadISST2,lon,lat,yr] = CDC_load_HadISST2(en)

    if ~exist('en','var'), en = 0;  end
    dir    = [CDC_other_temp_dir,'HadISST2/'];
    
    if en == 0
        file = [dir,'ERA20C_SST.nc'];
    else
        en_list = [69 115 137 396 400 1059 1169 1194 1346 1466];
        file    = [dir,'HadISST.2.1.0.0_realisation_dec2010_',num2str(en_list(en)),'.nc'];
    end

    HadISST2 = ncread(file,'sst');
    lon      = ncread(file,'longitude');
    lat      = ncread(file,'latitude');
    
    mask = all((HadISST2 - 273.2)<0.001,3);
    HadISST2(repmat(mask,1,1,size(HadISST2,3))) = nan;
    
    if en == 0
        HadISST2 = HadISST2(:,end:-1:1,:);
        lat    = lat(end:-1:1);
    else
        HadISST2 = HadISST2([181:360 1:180],end:-1:1,:);
        lon    = lon([181:360 1:180]);  lon(lon<0) = lon(lon<0) + 360;
        lat    = lat(end:-1:1);
    end
    
    Nt         = fix(size(HadISST2,3)/12)*12;
    HadISST2   = reshape(HadISST2(:,:,1:Nt),size(HadISST2,1),size(HadISST2,2),12,Nt/12);
    if en == 0
        yr     = [1:Nt/12]+1899;
    else
        yr     = [1:Nt/12]+1849;
    end

    [yr_start,yr_end] = CDC_common_time_interval;
    [HadISST2, yr] = CDC_trim_years(HadISST2, yr, yr_start, yr_end);
end