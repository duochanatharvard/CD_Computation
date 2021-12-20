% [HadSST4,lon,lat,yr] = CDC_load_HadSST4(en)

function [HadSST4,lon,lat,yr] = CDC_load_HadSST4(en)

    % HadSST4
    dir = '/Users/duochan/Data/Other_SSTs/HadSST4/';
    
    if ~exist('en','var')
        file = [dir,'HadSST.4.0.1.0_median.nc'];
    else
        if en == 0
            file = [dir,'HadSST.4.0.1.0_median.nc'];
        elseif en == -1
            file = [dir,'HadSST.4.0.1.0_unadjusted.nc'];
        else
            file = [dir,'HadSST-2/HadSST.4.0.1.0_ensemble_member_',num2str(en),'.nc'];
        end
    end

    HadSST4 = ncread(file,'tos');
    lon    = ncread(file,'longitude');
    lat    = ncread(file,'latitude');
    
    HadSST4(HadSST4>1000) = nan;
    HadSST4 = HadSST4([37:72 1:36],:,:);
    lon    = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;

    Nt     = fix(size(HadSST4,3)/12)*12;
    HadSST4 = reshape(HadSST4(:,:,1:Nt),size(HadSST4,1),size(HadSST4,2),12,Nt/12);
    yr     = [1:Nt/12]+1849;
    
end