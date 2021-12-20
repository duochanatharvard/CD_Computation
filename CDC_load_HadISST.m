% [HadISST,lon,lat,yr] = CDC_load_HadISST

function [HadISST,lon,lat,yr] = CDC_load_HadISST

    % HadISST
    dir = '/Users/duochan/Data/Other_SSTs/HadISST/';
    file = [dir,'HadISST_sst.nc'];

    HadISST = ncread(file,'sst');
    lon     = ncread(file,'longitude');
    lat     = ncread(file,'latitude');
    HadISST(HadISST<-99) = nan;
    HadISST = HadISST([181:360 1:180],end:-1:1,:);
    lon     = lon([181:360 1:180]);  lon(lon<0) = lon(lon<0) + 360;
    lat     = lat(end:-1:1);
    
    Nt     = fix(size(HadISST,3)/12)*12;
    HadISST = reshape(HadISST(:,:,1:Nt),size(HadISST,1),size(HadISST,2),12,Nt/12);
    yr     = [1:Nt/12]+1869;
    
end