% [GISTEMP, lon, lat, yr] = CDC_load_GISTEMP(en)
% if en does not exist :: use land only data
% if en == 1 :: use regridded data
% if en == 2 :: use combined land-ocean data


function [NOAATEMP, lon, lat, yr] = CDC_load_NOAATEMP

    dir =  [CDC_other_temp_dir,'NOAAGlobalTemp/'];

    file     = [dir,'air.mon.anom.v5.nc'];
    tas      = ncread(file,'air');
    tas(abs(tas)>100) = nan;
    lon      = ncread(file,'lon');
    lat      = ncread(file,'lat');
    NOAATEMP = tas;

    Nt       = fix(size(NOAATEMP,3)/12)*12;
    NOAATEMP = reshape(NOAATEMP(:,:,1:Nt),size(NOAATEMP,1),size(NOAATEMP,2),12,Nt/12);
    yr       = [1:Nt/12]+1879;
    
    [yr_start,yr_end] = CDC_common_time_interval;
    [NOAATEMP, yr] = CDC_trim_years(NOAATEMP, yr, yr_start, yr_end);
end