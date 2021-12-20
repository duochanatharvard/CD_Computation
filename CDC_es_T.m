% es_T = CDC_es_T(T)
% Derivative of saturation water vapor pressure (hpa)
% input: temperature (C or K)
% output: Derivative of saturation water vapor pressure (hpa)
% Ref: C-C equation

function es_T = CDC_es_T(T)

    Rv     = 461;               % J / kg / K
    L      = 2.5008e6;          % J / kg
    
    if nanmean(T(:)) < 200, T = T + 273.15;  end
    
    es_T  = L .* CDC_es(T) ./ (T.^2 .* Rv);
end