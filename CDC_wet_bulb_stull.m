% wet = CDC_wet_bulb_stull(T,q,p)
% Compute dew point temperature from specific humidity
% input: temperature (C or K), specific humidity (kg/kg) and p (hPa or Pa)
% output: wet bulb temperature (C)
% Ref: Stull 2011, Wet-Bulb Temperature from Relative Humidity and Air Temperature
% Journal of applied meterology and climatology, 50, 2267--2269

function wet = CDC_wet_bulb_stull(T,q,p)

    if nanmean(T(:)) > 200,  T = T - 273.15; end
    RH = q ./ CDC_eq(T,p) * 100;
    
    wet = T .* atan(0.151977.*sqrt(RH+8.313659)) + atan(T+RH) - atan(RH - 1.676331) + ...
        0.00391838.* RH.^(3/2).* atan(0.023101*RH) - 4.686035;
    
end