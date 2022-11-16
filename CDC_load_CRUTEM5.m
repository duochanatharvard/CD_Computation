% [CRUTEM5,lon,lat,yr] = CDC_load_CRUTEM5(en)

function [CRUTEM5,lon,lat,yr] = CDC_load_CRUTEM5(en)

    if ~exist('en','var'), en = 0; end
    dir    = [CDC_other_temp_dir,'CRUTEM5/'];
    
    if en == 0
        file = [dir,'CRUTEM.5.0.1.0.anomalies.nc'];
        CRUTEM5 = ncread(file,'tas');
        lon     = ncread(file,'longitude');
        lat     = ncread(file,'latitude');
        
        CRUTEM5(CRUTEM5>1000) = nan;
        CRUTEM5 = CRUTEM5([37:72 1:36],:,:);
        lon     = lon([37:72 1:36]);  lon(lon<0) = lon(lon<0) + 360;
        
        Nt      = fix(size(CRUTEM5,3)/12)*12;
        CRUTEM5 = reshape(CRUTEM5(:,:,1:Nt),size(CRUTEM5,1),size(CRUTEM5,2),12,Nt/12);
        yr      = [1:Nt/12]+1849;
        
    elseif en == -1
        error('CRUTEM5 does not provide uncorrected estimates...')
        
    else
        file = [dir,'CRUTEM5_Ensemble_v1/CRUTEM.5.0.1.0_ensemble_member_',num2str(en),'.mat'];
        if ~isfile(file)
            
            w = CDC_load_CRUTEM5(-1);
            
            P.do_random = 0;
            HadCRUT5 = CDC_load_HadCRUT5(en);
            HadSST4  = CDC_load_HadSST4(en,P);
            
            CRUTEM5 = (HadCRUT5 - HadSST4.*(1-w)) ./ w;
            CRUTEM5(w == 1) = HadCRUT5(w == 1);
            
            save(file,'CRUTEM5','-v7.3');
            
        else
            load(file);
        end
        lon = 2.5:5:360;
        lat = -87.5:5:90;
        yr  = 1849 + [1:size(CRUTEM5,4)];
    end

    [yr_start,yr_end] = CDC_common_time_interval;
    [CRUTEM5, yr] = CDC_trim_years(CRUTEM5, yr, yr_start, yr_end);
end