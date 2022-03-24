% [COBESST2,lon,lat,yr] = CDC_load_COBESST2

function [COBESST2,lon,lat,yr] = CDC_load_COBESST2

    % COBESST2
    if strcmp(computer,'MACI64')
        dir = '/Users/duochan/Data/Other_SSTs/CobeSST2/';
    else
        dir = '/n/home10/dchan/Other_SSTs/CobeSST2/';
    end
    file = [dir,'sst.mon.mean.nc'];

    COBESST2 = ncread(file,'sst');
    lon    = ncread(file,'lon');
    lat    = ncread(file,'lat');
    COBESST2(COBESST2>1000) = nan;
    COBESST2 = COBESST2(:,end:-1:1,:);
    lat    = lat(end:-1:1);
    Nt     = fix(size(COBESST2,3)/12)*12;
    COBESST2 = reshape(COBESST2(:,:,1:Nt),size(COBESST2,1),size(COBESST2,2),12,Nt/12);
    yr     = [1:Nt/12]+1849;
    
end