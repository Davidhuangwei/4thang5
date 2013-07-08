function beamformed_image  = delay_and_sum_Beamforming(frame,fs,aperture_length,bf_range)
% fs: sampling frequency
% aperture_length: number of elements in the aperture used to beamformed
% one line
% bf_range: range to beamform image

[M, N] = size(frame);
beamformed_image  = zeros(M,N);
for i = 1: N
    line =  beamformOneLine(frame,i,fs,aperture_length,bf_range);
    %plot(line);
    %pause(1/30);
    beamformed_image(:,i) = line;    
end