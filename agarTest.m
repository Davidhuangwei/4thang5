
close all
frame2 = frame(i:end,:);
displayBmodeSimple(frame2, 30, size(frame2,1));
for i =1050:10:1200
%for i = 1050:1050
    
    frame2 = frame(i:end,:);
    frame3  = delay_and_sum_Beamforming(frame2, 40e6, 128, [1,60]);
    frame4 = zeros(size(frame3));
    for j = 20:128
        frame4(:,j) = circshift(frame3(:,j),[8*(128-j) 0]);
    end
    h = figure;
    displayBmodeSimple(frame4, 30, size(frame4,1));
    saveas(h,strcat(num2str(i),'.jpg'));
    close;
    clear frame2 frame3
end
