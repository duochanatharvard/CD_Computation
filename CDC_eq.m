% eq = CDC_eq(T,p)
% Saturation specific humidity (mass ratio)
% input:  temperature (C or K) and pressure (Pa or hPa)
% output: saturation specific humidity (kg / kg)

function eq = CDC_eq(T,p)

    if nanmean(T(:)) < 200,  T = T + 273.15; end
    if nanmean(p(:)) > 80000, p = p / 100;   end
    
    eq = CDC_es(T) * 0.622 ./ (p - 0.378 * CDC_es(T));
end