writeVideo1 = 1;
if (writeVideo1==1)
writerObj = VideoWriter('bfapril7th.avi'); 
writerObj.FrameRate = 15;
open(writerObj);    
end
H = figure;
bfData = zeros(size(passiveData));
for i=30
    image(:,:) = passiveData(i,:,:);
    RF =(abs( hilbert(double(image)) ) ) ;
    RF = RF /max(max(RF));
    RF = 20*log10(RF);
    imagesc(RF,[-40 0]);
    colormap gray;
    colorbar
    figure;
    
    beamformed = beamform_one_image(image,16,40e6,1500,30,40);
    
    close
    bfData(i,:,:) = beamformed;
    if (writeVideo1)
            frame = getframe;
            writeVideo(writerObj,frame);
    end
    
end
if(writeVideo1)
    close(writerObj);
end
save('bfData','bfData');