% [CRUTEM5,lon,lat,yr] = CDC_load_CRUTEM5

function [CRUTEM5,lon,lat,yr] = CDC_load_CRUTEM5

    % CRUTEM5
    dir = '/Users/duochan/Data/Other_SSTs/HadCRUT5/';
    
    if ~exist('en','var')
        file = [dir,'CRUTEM.5.0.1.0.anomalies.nc'];
    else
        if en == 0
            file = [dir,'CRUTEM.5.0.1.0.anomalies.nc'];
        else
            file = [dir,''];
        end
    end

    CRUTEM5 = ncread(file,'tas');
    lon    = ncread(file,'longitude');
    lat    = ncread(file,'latitude');
    
    CRUTEM5(CRUTEM5>1000) = nan;
    CRUTEM5 = CRUTEM5([37:72 1:36],:,:);
    lon    = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;

    Nt     = fix(size(CRUTEM5,3)/12)*12;
    CRUTEM5 = reshape(CRUTEM5(:,:,1:Nt),size(CRUTEM5,1),size(CRUTEM5,2),12,Nt/12);
    yr     = [1:Nt/12]+1849;
    
end