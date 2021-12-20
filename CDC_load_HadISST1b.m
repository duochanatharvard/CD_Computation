% [HadISST1b,lon,lat,yr] = CDC_load_HadISST1b(en)

function [HadISST1b,lon,lat,yr] = CDC_load_HadISST1b(en)

    % HadISST1b
    dir = '/Users/duochan/Data/SST_Cyclone/DATA/SSTs/Step_2_HadISST1b_and_ensemble/';
    file = [dir,'HadISST1b_monthly_1871-2018_en_',num2str(en),'.nc'];

    HadISST1b = ncread(file,'sst');
    lon       = ncread(file,'lon');
    lat       = ncread(file,'lat');
    HadISST1b(HadISST1b<-99) = nan;
    
    Nt      = fix(size(HadISST1b,3)/12)*12;
    HadISST1b = reshape(HadISST1b(:,:,1:Nt),size(HadISST1b,1),size(HadISST1b,2),12,Nt/12);
    yr      = [1:Nt/12]+1870;
    
end