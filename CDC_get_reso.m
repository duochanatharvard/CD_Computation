% output = CDC_get_reso(model_name)
%
% CDC_get_reso returns the latitude and longitude resolution of 
%                               atmopsheric component for cmip5 models
%  
% Last update: 2018-08-10

function output = CDC_get_reso(model_name)

    switch model_name,
        case 'ACCESS1-0',
           output = [ 1.25	1.875];
        case 'ACCESS1-3',
           output = [ 1.25	1.875];
        case 'bcc-csm1-1',
           output = [ 2.7906	2.8125];
        case 'bcc-csm1-1-m',
           output = [ 2.7906	2.8125];
        case 'BNU-ESM',
           output = [ 2.7906	2.8125];
        case 'CCSM4',
           output = [ 0.9424	1.25];
        case 'CESM1-BGC',
           output = [ 0.9424	1.25];
        case 'CESM1-CAM5',
           output = [ 0.9424	1.25];
        case 'CESM1-FASTCHEM',
           output = [ 0.9424	1.25];
        case 'CESM1-WACCM',
           output = [ 1.8848	2.5];
        case 'CFSv2-2011',
           output = [ 1	1];
        case 'CMCC-CESM',
           output = [ 3.4431	3.75];
        case 'CMCC-CM',
           output = [ 0.7484	0.75];
        case 'CMCC-CMS',
           output = [ 3.7111	3.75];
        case 'CNRM-CM5',
           output = [ 1.4008	1.40625];
        case 'CNRM-CM5-2',
           output = [ 1.4008	1.40625];
        case 'CSIRO-Mk3-6-0',
           output = [ 1.8653	1.875];
        case 'CSIRO-Mk3L-1-2',
           output = [ 3.1857	5.625];
        case 'CanAM4',
           output = [ 2.7906	2.8125];
        case 'CanCM4',
           output = [ 2.7906	2.8125];
        case 'CanESM2',
           output = [ 2.7906	2.8125];
        case 'EC-EARTH',
           output = [ 1.1215	1.125];
        case 'FGOALS-g2',
           output = [ 2.7906	2.8125];
        case 'FGOALS-gl',
           output = [ 4.1026	5];
        case 'FGOALS-s2',
           output = [ 1.6590	2.8125];
        case 'GEOS-5',
           output = [ 2	2.5];
        case 'GFDL-CM2-1',
           output = [ 2.0225	2.5];
        case 'GFDL-CM3',
           output = [ 2	2.5];
        case 'GFDL-ESM2G',
           output = [ 2.0225	2];
        case 'GFDL-ESM2M',
           output = [ 2.0225	2.5];
        case 'GISS-E2-H',
           output = [ 2	2.5];
        case 'GISS-E2-H-CC',
           output = [ 2	2.5];
        case 'GISS-E2-R',
           output = [ 2	2.5];
        case 'GISS-E2-R-CC',
           output = [ 2	2.5];
        case 'HadCM3',
           output = [ 2.5	3.75];
        case 'HadGEM2-A',
           output = [ 1.25	1.875];
        case 'HadGEM2-AO',
           output = [ 1.25	1.875];
        case 'HadGEM2-CC',
           output = [ 1.25	1.875];
        case 'HadGEM2-ES',
           output = [ 1.25	1.875];
        case 'inmcm4',
           output = [ 1.5	2];
        case 'IPSL-CM5A-LR',
           output = [ 1.8947	3.75];
        case 'IPSL-CM5A-MR',
           output = [ 1.2676	2.5];
        case 'IPSL-CM5B-LR',
           output = [ 1.8947	3.75];
        case 'MIROC-ESM',
           output = [ 2.7906	2.8125];
        case 'MIROC-ESM-CHEM',
           output = [ 2.7906	2.8125];
        case 'MIROC4h',
           output = [ 0.5616	0.5625];
        case 'MIROC5',
           output = [ 1.4008	1.40625];
        case 'MPI-ESM-LR',
           output = [ 1.8653	1.875];
        case 'MPI-ESM-MR',
           output = [ 1.8653	1.875];
        case 'MPI-ESM-P',
           output = [ 1.8653	1.875];
        case 'MRI-AGCM3-2H',
           output = [ 0.562	0.5625];
        case 'MRI-AGCM3-2S',
           output = [ 0.188	0.1875];
        case 'MRI-CGCM3',
           output = [ 1.12148	1.125];
        case 'MRI-ESM1',
           output = [ 1.12148	1.125];
        case 'NorESM1-M',
           output = [ 1.8947	2.5];
        case 'NorESM1-ME',
           output = [ 1.8947	2.5];
    end
    
    if ~exist('output','var'),
        output = [nan nan];
    end
end
