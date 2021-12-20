function sig = CDC_is_sig(R,R_mem)

    sig(:,:,1) = R > 0 & quantile(R_mem,0.025,3) > 0;
    sig(:,:,2) = R < 0 & quantile(R_mem,0.975,3) < 0;
    
end