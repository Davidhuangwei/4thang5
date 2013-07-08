aperture = [8 16 32 64 128];
dynamicRange = 35;
for frameN = 80
    %path = strcat('D:\\Passive beamforming listening\\passive listening\\images\\NoWindow\\35dB\\frameNumber',num2str(frameN),'\\');
    path = strcat('D:\\Passive beamforming listening\\passive listening\\images\\testFrame80',num2str(frameN),'\\');
    mkdir(path);
    frame(:,:) = frameSequence(frameN,:,:);%extract one frame
    %frame(1:200,:) = 0;
    for aperture_length = aperture % for each aperture
        for focus_zone =1:30 % for each focal zone
        figure;
        focus_r = [focus_zone:focus_zone+1]'/100;%change the focus zone
        
        beamformed = beamform_one_image(frame,aperture_length,40e6,1500,focus_r,dynamicRange);
        %beamformed(1:200,:)=0;
        title(sprintf('%s cm',num2str(focus_zone)));
        saveas(gcf,strcat(path,sprintf('aperture %s focus zone %s.png',num2str(aperture_length),num2str(focus_zone))));
        close;
        end
    end

end
