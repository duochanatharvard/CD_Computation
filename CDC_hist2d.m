function [count,x,y] = CDC_hist2d(data,N,alpha)

    if ~exist('alpha','var'), alpha = 0.05; end

    temp   = quantile(data(:,1),[alpha/2 1-alpha/2]); 
    % temp   = round(temp,2,'significant');
    x      = linspace(temp(1),temp(2),N+1);
    RAN{1} = x;
    x      = x(1:end-1) + (x(2) - x(1))/2;

    temp   = quantile(data(:,2),[alpha/2 1-alpha/2]); 
    % temp   = round(temp,2,'significant');
    y      = linspace(temp(1),temp(2),N+1);
    RAN{2} = y;
    y      = y(1:end-1) + (y(2) - y(1))/2;
    
    count  = hist2d(data,RAN);
    % CDF_pcolor(x,y,count);
    % daspect([x(end)-x(1)  y(end)-y(1) 1])
end

function count = hist2d(data, RAN)

    for i = 1:2
        range = RAN{i};
        LV(i) = size(range,2) - 1;
        JG = range(2)-range(1);
        DATA(:,i) = fix((data(:,i) - range(1))/JG) + 1;
        DATA(DATA(:,i) > LV(i),i) = NaN;
        DATA(DATA(:,i) < 1,i) = NaN;
    end

    logic = all(isnan(DATA) == 0,2);
    [DATA_uni,~,J] = unique(DATA(logic,:),'rows');

    count = zeros(LV);
    if size(data,2) == 3
        data_temp = data(logic,3);
        value = nan(LV);
    end

    for i = 1:size(DATA_uni,1)
        if size(data,2) ~= 3
            count(DATA_uni(i,1),DATA_uni(i,2)) = nnz(J == i);
        else
            count(DATA_uni(i,1),DATA_uni(i,2)) = nnz(J == i);
            value(DATA_uni(i,1),DATA_uni(i,2)) = nanmean(data_temp(J == i));
        end
    end
    
    if size(data,2) == 3
        value(count < 1) = nan;
        count = value;
    end
    
end