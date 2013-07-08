aperture = [8 16 32 64 128];
dynamicRange = 35;
for frameN = 15
    path = strcat('E:\\UIUC\\spring2013\\passive listening\\images\\NoWindow\\35dB\\');%',num2str(frameN),'\\');
    mkdir(path);
    frame(:,:) = frameSequence(frameN,:,:);%extract one frame
    for aperture_length = aperture % for each aperture
        for focus_zone =1:30 % for each focal zone
        figure;
        focus_r = [focus_zone:focus_zone+1]'/100;%change the focus zone
        beamformed = beamform_one_image(frame,aperture_length,40e6,1500,focus_r,dynamicRange);
        %title(sprintf('%s cm',num2str(focus_zone)));
        saveas(gcf,strcat(path,sprintf('aperture %s focus zone %s',num2str(aperture_length),num2str(focus_zone))));
        %save(strcat(path,sprintf('aperture %s focus zone %s',num2str(aperture_length),num2str(focus_zone))),'beamformed');
        close;
        end
    end

end


    