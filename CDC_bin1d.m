% [stat,N,x_out] = CDC_bin1d(x,y,xx)

function [stat,N,x_out,stat_mean] = CDC_bin1d(x,y,xx,varargin)
    
    % *********************************************************************
    % Parse input argument
    % ********************************************************************* 
    if numel(varargin) == 1
        varargin = varargin{1};
    end
    para = reshape(varargin(:),2,numel(varargin)/2)';
    for ct = 1 : size(para,1)
        temp = para{ct,1};
        temp = lower(temp);
        temp(temp == '_') = [];
        para{ct,1} = temp;
    end


    id = discretize(x,xx);
    
    for ct = 1:numel(xx)-1
        stat(ct,:) = quantile(y(id == ct),[0.025 0.25 0.5 0.75 0.975]);
        N(ct,1)      = nnz(id == ct);
        stat_mean(ct,1) = nanmean(y(id == ct));
        stat_std(ct,1)  = CDC_std(y(id == ct)) / sqrt(N(ct,1));
        tinv_sig(ct,1)  = tinv(0.975,N(ct,1)-1);
    end

    dif = xx(2)-xx(1);
    x_out = (xx(1:end-1) + xx(2:end))/2;
    % x_out = (xx(1)+dif/2):dif:xx(end);

    if nnz(ismember(para(:,1),'color')) ~= 0
        col = para{ismember(para(:,1),'color'),2};
        pic_x  = [x_out fliplr(x_out)];
        if 1    % plot c.i.s for data distribution
            pic_y1 = [stat(:,1)' fliplr(stat(:,5)')];
            pic_y2 = [stat(:,2)' fliplr(stat(:,4)')];
        else    % plot c.i.s for the mean
            pic_y2 = [(stat_mean + tinv_sig.* stat_std)' ...
                      flipud(stat_mean - tinv_sig.* stat_std)' ];            
        end
        % patch(pic_x(~isnan(pic_y1)),pic_y1(~isnan(pic_y1)),col,'linest','none','facealpha',0.1);
        patch(pic_x(~isnan(pic_y2)),pic_y2(~isnan(pic_y2)),col,'linest','none','facealpha',0.2);
        plot(x_out,stat(:,3)','linewi',3,'color',col)
        if numel(x_out<10)
            plot(x_out,stat(:,3)','.','linewi',3,'color',col,'markersize',40)
            plot(x_out,stat(:,3)','.','linewi',3,'color','w','markersize',18)
        end
    end
end