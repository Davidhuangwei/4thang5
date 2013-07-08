%% envelope detection and compress
frame  = zeros(size(frameSequence,2),size(frameSequence,3));
plotFrame =  1 : size(frameSequence,1);
%plotFrame = 1:50;
for frameN = plotFrame
    frame(:,:) = frameSequence(frameN,:,:);
    RF =(abs( hilbert(frame(:,:)) ))  ;% envelope detection
    RF = RF /max(max(RF));%normalize to have max of 1
    RF = 20*log10(RF+0.001);% 0 dB is max. Compress the envelope
    G = 35;
    imagesc(RF,[-G 0]);% display with dynamic range G
    title(['Transmit #',num2str( frameN )]);    
    xlabel('Channels')
    ylabel('Samples (Depth)')
    colormap gray;
    colorbar
    drawnow
end