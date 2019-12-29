% CDC_interp2(lon,lat,field,lon_target,lat_target)
function out_field = CDC_interp2(lon,lat,field,lon_target,lat_target)
    % lon = [0:1:359]';
    % lat = [-90:1:90]';
    lon   = reshape(lon,numel(lon),1);
    [lat,lon] = meshgrid(lat,[lon-360; lon; lon+360]);

    % lon_target   = [0:2.5:357.5]';
    % lat_target   = [-90:2.5:90]';
    [lat_target,lon_target] = meshgrid(lat_target,lon_target);

    out_field = interp2(lat,lon,[field; field; field],lat_target,lon_target);
end