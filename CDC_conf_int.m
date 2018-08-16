% [out_int,out_para,MLE] = CDC_conf_int(x,y,z,val_pdf,alpha)
% 
% CDC_conf_int find the 1 to 3-dimensional confidence interval
%  
% inputs are:
%  - x,y,z: meshed grids for parameters
%  - val_pdf: value of probability density function
%  - alpha: coverage, alpha belongs to [0, 1]
% 
% output: 
%  - out_int: a logic matrix that indicate points in the c.i. 
%  - out_para: sets of parameters in the c.i., which can be used to compute
%              intervals of functions of these parameters
%  - MLE: maximum likelihood estimate of parameters
% 
% Please do check that the grids match up with the pdfs.
% The meshgrid function in matlab is a bit weird !!!
%  
% Last update: 2018-08-09

function [out_int,out_para,MLE] = CDC_conf_int(x,y,z,val_pdf,alpha)

    if isempty(y),
        dim = 1;
    elseif isempty(z),
        dim = 2;
    else
        dim = 3;
    end

    if dim > 1 && min(size(x)) == 1,
        if dim == 2,
            [yy,xx] = meshgrid(y,x);
        else
            [yy,xx,zz] = meshgrid(y,x,z);
        end
    else
        xx = x;
        if dim > 1,
            yy = y;
            if dim > 2,
                zz = z;
            end
        end
    end
    
    if ~exist('alpha','var'), alpha = 0.95; end
    if isempty(alpha), alpha = 0.95; end

    val_norm = val_pdf ./nansum(val_pdf(:));
    
    [val_sort,I] = sort(val_norm(:),'descend');
    
    id = find(cumsum(val_sort) < alpha, 1, 'last');
    
    out_int = false(size(xx));
    
    out_int(I(1:id)) = true;
    
    id2 = find(val_pdf == max(val_pdf(:)));

    if dim == 1,
        out_para = [xx(I(1:id)) val_pdf(I(1:id))];
        MLE = [xx(id2)];
    elseif dim == 2,
        out_para = [xx(I(1:id)) yy(I(1:id)) val_pdf(I(1:id))];
        MLE = [xx(id2)  yy(id2)];
    else
        out_para = [xx(I(1:id)) yy(I(1:id)) zz(I(1:id)) val_pdf(I(1:id))];
        MLE = [xx(id2)  yy(id2)  zz(id2)];
    end

end