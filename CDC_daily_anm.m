% [anm, fit] = CDC_daily_anm(data)
% 
% Calculate daily anomalies using sine/cosine fitting method
% The input 
% 
% CDC_daily_anm - Detrends and removes seasonal patterns from time-series data.
% 
% This function fits a combined harmonic model and linear trend to time-series data
% to extract and remove both the seasonal component and any linear or nonlinear trends.
% The flexibility of the model is controlled by two parameters: 'order_mean' and 'order_trend'.
% 
% 'order_mean' determines the number of harmonic terms (sine and cosine) used to model the seasonal cycle:
%   - order_mean = 0: No seasonal component is modeled.
%   - order_mean = 1: The model includes the first harmonic (basic annual frequency).
%   - order_mean > 1: Higher harmonics are included, increasing seasonal model complexity.
% 
% 'order_trend' specifies the inclusion and complexity of trend components in the model:
%   - order_trend = -1: No trend component is included in the model.
%   - order_trend = 0: A simple linear trend is included.
%   - order_trend >= 1: Linear trends modulated by up to the specified number of harmonic terms are included, 
%                        allowing for modeling changes in the amplitude and phase of seasonal patterns over time.
% 
% Usage:
%   detrendedData = CDC_daily_anm(data, order_mean, order_trend)
% 
% Inputs:
%   data - A matrix containing the time-series data, where rows correspond to days and columns to years ([day]x[year]).
%   order_mean - The number of harmonics to include in modeling the mean seasonal cycle.
%   order_trend - The level of trend complexity, ranging from no trend (-1), linear trend (0), 
%                 to nonlinear trends modulated by harmonics (1 or more).
% 
% Output:
%   detrendedData - The resulting data matrix after removing the fitted seasonal and trend components.

function detrendedData = CDC_daily_anm(data,order_mean,order_trend)

    if ~exist('is_anm','var'), is_anm = 0;  end

    % Extract size of the data
    [numDays, numYears] = size(data);

    % Prepare time vector for each day in the year assuming 365 days
    w = 2*pi*[1:numDays]'./numDays;
    t = repmat((1:numYears),numDays,1);    t = t(:);
    
    % Estimate annual mean value
    X = [ones(numDays*numYears, 1)];           % Constant term
    % Estimate seasonality in mean value
    for ct = 1:order_mean
        X = [X repmat(sin(ct*w),numYears,1), ... 
               repmat(cos(ct*w),numYears,1)];    
    end
    % Estimate linear trend
    if order_trend >= 0
        X = [X t];
    end
    % Estimate seasonal variations in linear trend
    for ct = 1:order_trend
        X = [X t.*repmat(sin(ct*w),numYears,1), ... 
               t.*repmat(cos(ct*w),numYears,1)];    
    end
         
    % Reshape data to be a column vector
    y = reshape(data, [], 1);

    l_rm      = isnan(y);
    yy        = y;
    XX        = X;
    yy(l_rm)   = [];
    XX(l_rm,:) = [];

    % Solve the linear model
    coeffs = XX \ yy;

    % Compute the model from the coefficients
    fittedModel = X * coeffs;

    % Reshape the fitted model to original data shape
    model = reshape(fittedModel, numDays, numYears);

    % Detrended data is the original data minus the fitted model
    detrendedData = data - model;

end