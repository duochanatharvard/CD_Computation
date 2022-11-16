% [HadCRUT5,lon,lat,yr] = CDC_load_HadCRUT5(en,P)
% P.do_analysis :: use partially infilled analyses data

function [HadCRUT5,lon,lat,yr] = CDC_load_HadCRUT5(en,P)

    if ~exist('en','var'), en = 0; end
    if ~exist('P','var'),  P.do_analysis = 0;  end
    dir    = [CDC_other_temp_dir,'HadCRUT5/'];
    
    if en == 0
        if P.do_analysis == 0
            file = [dir,'HadCRUT.5.0.1.0.anomalies.ensemble_mean.nc'];
        else
            file = [dir,'HadCRUT.5.0.1.0.analysis.anomalies.ensemble_mean.nc'];
        end
    elseif en == -1
        file = [dir,'HadCRUT.5.0.1.0.weights.nc'];
        disp('HadCRUT5 does not provide uncorrected estimates,')
        disp('Loading weights for LATs and SSTs instead');
    else
        file = [dir,'HadCRUT5_ensemble_v1/HadCRUT.5.0.1.0.anomalies.',num2str(en),'.nc'];
    end

    if en > 0
        HadCRUT5 = ncread(file,'tas');
    elseif en == 0
        HadCRUT5 = ncread(file,'tas_mean');
    elseif en == -1
        HadCRUT5 = ncread(file,'weights');
    end
    lon     = ncread(file,'longitude');
    lat     = ncread(file,'latitude');
    
    HadCRUT5(HadCRUT5>1000) = nan;
    HadCRUT5 = HadCRUT5([37:72 1:36],:,:);
    lon     = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;

    Nt       = fix(size(HadCRUT5,3)/12)*12;
    HadCRUT5 = reshape(HadCRUT5(:,:,1:Nt),size(HadCRUT5,1),size(HadCRUT5,2),12,Nt/12);
    yr       = [1:Nt/12]+1849;

    [yr_start,yr_end] = CDC_common_time_interval;
    [HadCRUT5, yr] = CDC_trim_years(HadCRUT5, yr, yr_start, yr_end);
end