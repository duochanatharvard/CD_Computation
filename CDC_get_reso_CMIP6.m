% output = CDC_get_reso_CMIP6(model_name)
%
% CDC_get_reso returns the latitude and longitude resolution of 
%                               atmopsheric component for cmip6 models
%  
% Last update: 2021-03-02

function output = CDC_get_reso_CMIP6(model_name)

    switch model_name
        case 'ACCESS-CM2'
            output = [1.8750  1.2500];
        case 'ACCESS-ESM1-5'
            output = [1.8750  1.2500];
        case 'AWI-CM-1-1-MR'
            output = [0.9375  0.9272];
        case 'BCC-CSM2-MR'
            output = [1.1250  1.1121];
        case 'CAMS-CSM1-0'
            output = [1.1250  1.1121];
        case 'CESM2-WACCM'
            output = [1.2500  0.9424];
        case 'CIESM'
            output = [1.2500  0.9424];
        case 'CMCC-CM2-SR5'
            output = [1.2500  0.9424];
        case 'CanESM5'
            output = [2.8125  2.7673];
        case 'E3SM-1-1'
            output = [1.0000  1.0000];
        case 'EC-Earth3'
            output = [0.7031  0.6959];
        case 'EC-Earth3-Veg'
            output = [0.7031  0.6959];
        case 'EC-Earth3-Veg-LR'
            output = [1.1250  1.1121];
        case 'FGOALS-f3-L'
            output = [1.2500  1.0000];
        case 'FGOALS-g3'
            output = [2.0000  2.0253];
        case 'FIO-ESM-2-0'
            output = [1.2500  0.9424];
        case 'GFDL-CM4'
            output = [1.2500  1.0000];
        case 'GFDL-ESM4'
            output = [1.2500  1.0000];
        case 'IITM-ESM'
            output = [1.8750  1.8888];
        case 'INM-CM4-8'
            output = [2.0000  1.5000];
        case 'INM-CM5-0'
            output = [2.0000  1.5000];
        case 'IPSL-CM6A-LR'
            output = [2.5000  1.2676];
        case 'KACE-1-0-G'
            output = [1.8750  1.2500];
        case 'KIOST-ESM'
            output = [1.8750  1.8947];
        case 'MIROC6'
            output = [1.4062  1.3890];
        case 'MPI-ESM1-2-HR'
            output = [0.9375  0.9272];
        case 'MPI-ESM1-2-LR'
            output = [1.8750  1.8496];
        case 'MRI-ESM2-0'
            output = [1.1250  1.1215];
        case 'NESM3'
            output = [1.8750  1.8652];
        case 'NorESM2-LM'
            output = [2.5000  1.8947];
        case 'NorESM2-MM'
            output = [1.2500  0.9424];
        case 'TaiESM1'
            output = [1.2500  0.9424];
    end
    
    if ~exist('output','var')
        output = [nan nan];
    end
end
