%%
close all;
c = 1500 ; %m/s
fs = 40e6;
delayedTime = 56 ;%us
%focusOfSingleElementTransducer = 38.1 ; % mm

SyncDelayedTime = 0;
numberOfDelayedSample = delayedTime * fs /1e6 /2 + SyncDelayedTime;
%temp = focusOfSingleElementTransducer / c * fs /1000;
newFrame = frame(numberOfDelayedSample:end,:);
bf_range = [1,100];

h = figure;
%subplot(141);
%displayBmodeSimple(frame, 30,3000);
%title('Before adjusted');
%subplot(142);
%displayBmodeSimple(delay_and_sum_Beamforming(frame, fs, 128, bf_range),30,3000);
subplot(121);
displayBmodeSimple(newFrame, 30, 3000-numberOfDelayedSample+1);
%title('After adjusted');
subplot(122);
%%
bfImage  = delay_and_sum_Beamforming(newFrame, fs, 128, bf_range);
displayBmodeSimple(bfImage, 30, 3000 - numberOfDelayedSample + 1);
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
