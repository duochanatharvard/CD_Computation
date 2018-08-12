% output = CDC_get_season(input,season,two_hemi,data_type)
%
% CDC_get_season get the monthly values of a sepcific season
% Input data should start from Janurary and from the south pole
%  - data_type: {'monthly', 'daily', '6hourly'}
%  
% Last update: 2018-08-10

function output = CDC_get_season(input,season,two_hemi,data_type)
    
    if ~exist('data_type','var'),
        data_type = 'monthly';
    end
    
    switch data_type,
        case 'monthly',

            N_yr = size(input,3) / 12;
            months = repmat([1:12],1,N_yr);
            
            s_list = [1 2 12; 3 4 5; 6 7 8; 9 10 11;...
                      1 2 12; 3 4 5; 6 7 8; 9 10 11];
            
            if two_hemi == 0,
                logic = ismember(months,s_list(season,:));
                output = input(:,:,logic);
            else
                N_y = size(input,2);
                logic_nh = ismember(months,s_list(season,:));
                logic_sh = ismember(months,s_list(season+2,:));
                output = [input(:,1 : N_y/2,logic_sh), ...
                          input(:,N_y/2+1 : end,logic_nh)];
            end

        case 'daily',
            
            
        case '6hourly',
            
    end
    
end