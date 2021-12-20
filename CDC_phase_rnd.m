function output = CDC_phase_rnd(input,N)

    specturm = fft(input);
    energy = sqrt(real(specturm).^2 + imag(specturm).^2);
    if size(energy,1) == 1; energy = energy';  end
    N_band = fix(numel(input)/2) + 1;

    phase_rnd = zeros(numel(energy),N);
    for ct = 1:N_band
        temp_phase = unifrnd(0,2*pi,1,N);
        phase_rnd(ct+1,:) = temp_phase;
        phase_rnd(end-ct+1,:) = - temp_phase;
    end

    a = repmat(energy,1,N).* cos(phase_rnd);
    b = repmat(energy,1,N).* sin(phase_rnd);
    specturm_rnd =  a + b .* 1i;
    if rem(numel(input),2) == 0
        specturm_rnd(numel(input)/2+1,:) = specturm(numel(input)/2+1);
    end
    output = ifft(specturm_rnd,[],1);
        
end