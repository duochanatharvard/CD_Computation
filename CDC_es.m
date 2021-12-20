% es = CDC_es(T)
% Saturation water vapor pressure
% input: temperature (C or K)
% output: saturation vapor pressure (hPa)
% Ref: Bolton 1980, Monthly Weather Review, 108, 1046--1053

function es = CDC_es(T)

    if nanmean(T(:)) < 200,  T = T + 273.15; end
    
    ratio = (T-273.15)./(T-29.65);
    es    = 6.112 .* exp(17.67 .* ratio);
end