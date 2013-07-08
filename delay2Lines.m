Upsampledline1 = interp(line1,4);
Upsampledline2 = interp(line2,4);
for i=0
figure;
hold on;
plot(Upsampledline1)
delay2 = [zeros(i,1); Upsampledline2(1:end-i)];
plot(delay2,'r');
title(num2str(i));
hold off;
%k = waitforbuttonpress 
%close;

end