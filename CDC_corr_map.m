function R = CDC_corr_map(input)

    for i = 1:size(input,3)
        for j = i+1:size(input,3)
            a = input(:,:,i);
            b = input(:,:,j);
            R(i,j) = CDC_corr(a(:),b(:));
        end
    end

end
        