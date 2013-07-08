
%%
count = 1;
for i = 50
subplot(2,2,count)
frame(:,:)  = passiveData(i,:,:);
displayBmode(frame,40);
title(strcat('frame number',num2str(i)));
drawnow;
count = count + 1;
if (count >4)
    figure;
    count = 1;
end
end

%%
fs = 40e6;
aperture_length = 6;
bf_image  = delay_and_sum_Beamforming(frame,fs,aperture_length,[53 154]);
figure;
displayBmode(bf_image,40);
