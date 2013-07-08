function frame = denoiseImage(frame1)

%%
%frame1(:,:)  = frameSequence(frameNumber,:,:);
frame = zeros(size(frame1,1)-300,size(frame1,2));
for i=1:128
    line = frame1(:,i);
    %line(1:200) = 0;
    denoised_line =  wden(line,'minimaxi','s','sln',5,'sym8');
    %plot(abs(fft(line,6000)));
    frame(:,i) = denoised_line(301:end);
    %plot(line);%line i
    %plot(denoised_line);
    %title(sprintf('frame number %d',i));
       
end
%%
frame2 = abs(hilbert(frame));
frame2 = frame2/max(max(frame2));
frame2 = 20*log10(frame2);
imagesc(frame2,[-25 0]);
colormap gray
colorbar