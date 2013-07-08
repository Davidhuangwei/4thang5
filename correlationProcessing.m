%%
frame(:,:) = frameSequence(40,:,:);
%%
fs = 40e6;
noSamples = 3000;
d = noSamples / fs * 1500;
distance = 0:(d*1000);
displayBmode(frame,40,'Frame number 40',distance);

%%
firstLine = frame(500:end,45);
secondLine = frame(500:end,46);
lineNumber  = 32;
close all;
%%
summedImage = zeros(length(firstLine)*4,128);
for idx = lineNumber
    maxIdx = zeros(1,127);
    firstLine = frame(500:end,lineNumber);
    upsampledFirstLine = interp(firstLine,4); %upsample to have better interpolation
    summed = upsampledFirstLine;
    for i=1:128
        if (i == lineNumber)
            continue;
        end
        secondLine = frame(500:end,i);
        upsampledLine2 = interp(secondLine, 4);
        
        c=xcorr(upsampledFirstLine,upsampledLine2); % correlation
        maxIdx(i) = find(c==max(c),1,'first'); %maximum correlation
        delaySample = maxIdx(i) - length(firstLine) * 4; % convert to delayed sample
        if (delaySample > 0) %leads
            delayedLine = [zeros(delaySample,1); upsampledLine2(1:end-delaySample)];
            summed  = summed + delayedLine;
        else %lags
            delayedLine = [upsampledLine2(abs(delaySample)+1:end); zeros(abs(delaySample),1)];
            summed = summed + upsampledFirstLine;
        end
    end
    summedImage(:,idx) = summed;
end

