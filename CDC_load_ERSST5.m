% [ERSST5,lon,lat,yr] = CDC_load_ERSST5

function [ERSST5,lon,lat,yr] = CDC_load_ERSST5

    % ERSST5
    dir = '/Users/duochan/Data/Other_SSTs/ERSST5/';
    file = [dir,'sst.mnmean.nc'];

    ERSST5 = ncread(file,'sst');
    lon    = ncread(file,'lon');
    lat    = ncread(file,'lat');
    ERSST5(ERSST5<-100) = nan;
    ERSST5 = ERSST5(:,end:-1:1,:);
    lat    = lat(end:-1:1);
    Nt     = fix(size(ERSST5,3)/12)*12;
    ERSST5 = reshape(ERSST5(:,:,1:Nt),size(ERSST5,1),size(ERSST5,2),12,Nt/12);
    yr     = [1:Nt/12]+1853;
    
end