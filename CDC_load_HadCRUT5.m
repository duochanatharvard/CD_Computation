% [HadCRUT5,lon,lat,yr] = CDC_load_HadCRUT5

function [HadCRUT5,lon,lat,yr] = CDC_load_HadCRUT5

    % HadCRUT5
    dir = '/Users/duochan/Data/Other_SSTs/HadCRUT5/';
    
    if ~exist('en','var')
        file = [dir,'HadCRUT.5.0.1.0.analysis.anomalies.ensemble_mean.nc'];
    else
        if en == 0
            file = [dir,'HadCRUT.5.0.1.0.analysis.anomalies.ensemble_mean.nc'];
        else
            file = [dir,''];
        end
    end

    HadCRUT5 = ncread(file,'tas_mean');
    lon    = ncread(file,'longitude');
    lat    = ncread(file,'latitude');
    
    HadCRUT5(HadCRUT5>1000) = nan;
    HadCRUT5 = HadCRUT5([37:72 1:36],:,:);
    lon    = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;

    Nt     = fix(size(HadCRUT5,3)/12)*12;
    HadCRUT5 = reshape(HadCRUT5(:,:,1:Nt),size(HadCRUT5,1),size(HadCRUT5,2),12,Nt/12);
    yr     = [1:Nt/12]+1849;
    
end