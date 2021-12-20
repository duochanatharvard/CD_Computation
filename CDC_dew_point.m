% dew = CDC_dew_point(q,p)
% Compute dew point temperature from specific humidity
% input: specific humidity (kg / kg) and p (hPa or Pa)
% output: dew point temperature (C)

function dew = CDC_dew_point(q,p)

    if nanmean(p(:)) > 80000, p = p / 100;   end
    if nanmean(q(:)) > 0.5,   q = q / 1000;   end

    e = p .* q ./ (0.622 + q.*0.378);
    A = log(e ./ 6.112) ./ 17.67;
    a = 273.15;
    b = 29.65;
    dew = (A.*b - a) ./ (A - 1);
    dew = dew - 273.15;
end