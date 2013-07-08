function synthetic_image(rfDAQCollection,aperture)
%SYNTHETIC Synthetic aperture beamforming with BFT
% 
%  Central frequency 10MHz                       [Hz]
fs = 40e6;            %  Sampling frequency                      [Hz]
c = 1540;              %  Speed of sound                          [m/s]
no_elements = 128;      %  Number of elements in the transducer

%this specification is for l14-5/38
width = 0.2798 *1e-3;     % Width of the element                     [m]
kerf =  0.025 *1e-3;%pitch - width;  % Inter-element spacing                    [m]
%pitch = width + kerf;
 
bft_init;%  Initialize the program

bft_param('c', c);
bft_param('fs', fs);

xdc = bft_linear_array(no_elements, width, kerf);

no_lines = 128;%  Define and create the image
bft_no_lines(no_lines);
focus_r = [25:35]'/1000;

pitch = width + kerf;
center_focus = [-(no_elements-1)/2:(no_elements-1)/2]' * pitch;
%center_focus = ones(1,no_elements)*36*pitch;

writerObj = VideoWriter('beamformed.avi'); 
writerObj.FrameRate = 8;
open(writerObj);  
for i = 1:no_lines
%   bft_apodization(xdc,0,hanning(no_elements)',i);
  if (1)  
    lo_index = i-1-aperture/2;
    if (lo_index <0) 
          lo_index = 0; 
    end  
    hi_index = i+aperture/2;
    if (hi_index >128) 
          hi_index = 128; 
    end
    apo =[zeros(1,lo_index), ones(1,hi_index-lo_index), zeros(1,128-hi_index)];
  else
    lo_index = i-1-1;
    if (lo_index <0) 
          lo_index = 0; 
    end  
    hi_index = i+1;
    if (hi_index >128) 
          hi_index = 128; 
    end
    apo =[zeros(1,lo_index), 1/10*ones(1,hi_index-lo_index), zeros(1,128-hi_index)];
  end
  bft_apodization(xdc,0,apo,i);
    
%    apo = [zeros(1,i-1), 1, zeros(1,128-i)];
 % bft_apodization(xdc,0,apo,i);
  
  focus = [center_focus(i)*ones(length(focus_r),1), zeros(length(focus_r),1), focus_r];
  %focus = [-0.0059, 0,55];
  %focus = [zeros(length(focus_r),1), zeros(length(focus_r),1), focus_r];
  bft_center_focus([center_focus(i) 0 0],i);%set the center of focus to the center of transducer  %center_focus(i)
  T = (focus_r -.5/1000)/c *2;
  %T = (55 -.5/1000)/c *2;
  bft_focus(xdc, T, focus,i);
  %theta = theta + d_theta;
end
  

%
%  Allocate memory for the image
%
no_rf_samples = 6000;
bf_image = zeros(no_rf_samples, no_lines);
%
% Make one low-resolution image at a time and sum them
%

for emission_no=50
  disp(['emission no: ' num2str(emission_no)]);
  start_time = 0;
  %scat(:,:) = rfDAQCollection(emission_no+1,:,:);  
  scat(:,:) = rfDAQCollection;
  %scat1 = scat(:,1:32);
  beamformed = bft_beamform(start_time,scat);
  %InterImage = interpolateImage(abs(hilbert(beamformed)));
  %imagesc(InterImage);  
  %colormap gray;
  %drawnow;
  bf_image = bft_add_image(bf_image, beamformed, emission_no, start_time);
  %imagesc(bf_image);
  bf_image1 = abs(hilbert(beamformed));                  % Envelope detection
  bf_image1 = bf_image1 / max(max(bf_image1));
  imagesc(20*log10(bf_image1 + 0.001),[-50 0])
  colormap gray;
  frame = getframe;
  writeVideo(writerObj,frame);
  drawnow;
end
close(writerObj);
%  Release the allocated memory
bft_end 
%
%  Dispplay the image
%
save bf_imageRect64 bf_image
bf_image = abs(hilbert(bf_image));                  % Envelope detection
bf_image = bf_image / max(max(bf_image));
figure;
imagesc(20*log10(bf_image + 0.001),[-50 0])


