%%
close all;
c = 1500 ; %m/s
fs = 40e6;

delayedTime = [52 56 59 65];%us
delayedTime = delayedTime + 6;
%delayedTime = [52 52 52 52];

SyncDelayedTime = 0;
numberOfDelayedSample = delayedTime * fs /1e6 /2 + SyncDelayedTime;

newFrame1 = frame1(numberOfDelayedSample(1):end,:);
newFrame2 = frame2(numberOfDelayedSample(2):end,:);
newFrame3 = frame3(numberOfDelayedSample(3):end,:);
newFrame4 = frame4(numberOfDelayedSample(4):end,:);


minWidth = min([size(newFrame1,1) size(newFrame2,1) size(newFrame3,1) size(newFrame4,1)]);


newFrame = abs(hilbert(newFrame1(1:minWidth,:))) + abs(hilbert(newFrame2(1:minWidth,:))) + abs(hilbert(newFrame3(1:minWidth,:))) + abs(hilbert(newFrame4(1:minWidth,:)));
bf_range = [1,60];

figure;
title('Pre beamformed');
displayBmodeWithoutEnvelopeDetection(newFrame, 30, size(newFrame,1));




%%
bfImage1  = delay_and_sum_Beamforming(newFrame1(1:minWidth,:), fs, 128, bf_range);
bfImage2  = delay_and_sum_Beamforming(newFrame2(1:minWidth,:), fs, 128, bf_range);
bfImage3  = delay_and_sum_Beamforming(newFrame3(1:minWidth,:), fs, 128, bf_range);
bfImage4  = delay_and_sum_Beamforming(newFrame4(1:minWidth,:), fs, 128, bf_range);
%bfImage5  = delay_and_sum_Beamforming(newFrame5(1:minWidth,:), fs, 128, bf_range);
figure;
displayBmodeWithoutEnvelopeDetection(abs(hilbert(bfImage1)) + abs(hilbert(bfImage2)) + abs(hilbert(bfImage3)) + abs(hilbert(bfImage4)), 30, size(bfImage1,1));
title('Beamformed');
return;

%%
pitch = 38/127/1000;
delay_per_element = floor(pitch/c * fs);
temp = zeros(size(bfImage));

for j = 1: 128    
        temp(:,j)  = circshift(bfImage(:,j),[-delay_per_element * (129-1) 0]);
        %temp(:,j)  = circshift(bfImage(:,j),[-delay_per_element * (129-j) 0]);
        %shifted_line = bfImage(1 + delay_per_element * (128-j) : end,j);
        %temp(:,j) = padarray(shifted_line, size(temp,1)-length(shifted_line) , -3000 ,'post');        
end
figure;
subplot(121);
displayBmodeSimple(bfImage, 30, 3000 - numberOfDelayedSample + 1);
subplot(122);
displayBmodeSimple(temp, 30, 3000 - numberOfDelayedSample + 1);


%saveas(h,strcat(num2str(focusOfSingleElementTransducer),'.jpg'));
