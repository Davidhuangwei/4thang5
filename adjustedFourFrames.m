%%
hilBertFlag = 0;
select = 1;
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

if (hilBertFlag > 0)
    newFrame = abs(hilbert(newFrame1(1:minWidth,:))) + abs(hilbert(newFrame2(1:minWidth,:))) + abs(hilbert(newFrame3(1:minWidth,:))) + abs(hilbert(newFrame4(1:minWidth,:)));
else 
    newFrame = newFrame1(1:minWidth,:) + newFrame2(1:minWidth,:) + newFrame3(1:minWidth,:) + newFrame4(1:minWidth,:);
end
bf_range = [1,60];

figure;
title('Pre beamformed');
if (hilBertFlag > 0)
    displayBmodeWithoutEnvelopeDetection(newFrame, 30, size(newFrame,1));    
else
    displayBmodeSimple(newFrame, 30, size(newFrame,1));
end



line_start = 32;
line_end = 110;
%%
if (select == 0)
    bfImage1  = delay_and_sum_Beamforming(newFrame1(1:minWidth,:), fs, 128, bf_range);
    bfImage2  = delay_and_sum_Beamforming(newFrame2(1:minWidth,:), fs, 128, bf_range);
    bfImage3  = delay_and_sum_Beamforming(newFrame3(1:minWidth,:), fs, 128, bf_range);
    bfImage4  = delay_and_sum_Beamforming(newFrame4(1:minWidth,:), fs, 128, bf_range);
else
    bfImage1  = delay_and_sum_Beamforming_select_lines(newFrame1(1:minWidth,:), fs, 128, bf_range, line_start, line_end);
    bfImage2  = delay_and_sum_Beamforming_select_lines(newFrame2(1:minWidth,:), fs, 128, bf_range, line_start, line_end);
    bfImage3  = delay_and_sum_Beamforming_select_lines(newFrame3(1:minWidth,:), fs, 128, bf_range, line_start, line_end);
    bfImage4  = delay_and_sum_Beamforming_select_lines(newFrame4(1:minWidth,:), fs, 128, bf_range, line_start, line_end);
end
%bfImage5  = delay_and_sum_Beamforming(newFrame5(1:minWidth,:), fs, 128, bf_range);
figure;
if (hilBertFlag > 0)
    displayBmodeWithoutEnvelopeDetection(abs(hilbert(bfImage1)) + abs(hilbert(bfImage2)) + abs(hilbert(bfImage3)) + abs(hilbert(bfImage4)), 30, size(bfImage1,1));
else
    displayBmodeSimple(bfImage1 + bfImage2 + bfImage3 + bfImage4, 30, size(bfImage1,1));
end
title('Beamformed');
return;

%%
pitch = 38/127/1000;
delay_per_element = floor(pitch/c * fs);
temp = zeros(size(bfImage));

for j = 1: 128    
        temp(:,j)  = circshift(bfImage(:,j),[-delay_per_element * (129-1) 0]);
          
end
figure;
subplot(121);
displayBmodeSimple(bfImage, 30, 3000 - numberOfDelayedSample + 1);
subplot(122);
displayBmodeSimple(temp, 30, 3000 - numberOfDelayedSample + 1);


%saveas(h,strcat(num2str(focusOfSingleElementTransducer),'.jpg'));
