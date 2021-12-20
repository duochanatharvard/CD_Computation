function mask = CDC_generate_mask(lon,lat,x,y)

    [lat_mesh,lon_mesh] = meshgrid(lat,lon);

    mask = ones(size(lon_mesh));
    
    l1 = (y(2)-y(1))./(x(2)-x(1)).*(lon_mesh-x(1)) + y(1) > lat_mesh;
    l3 = (y(3)-y(4))./(x(3)-x(4)).*(lon_mesh-x(4)) + y(4) < lat_mesh;

    l2 = (x(3)-x(2))./(y(3)-y(2)).*(lat_mesh-y(2)) + x(2) < lon_mesh;
    l4 = (x(4)-x(1))./(y(4)-y(1)).*(lat_mesh-y(1)) + x(1) > lon_mesh;
    
    mask(l1 | l2 | l3 | l4)=0;
end