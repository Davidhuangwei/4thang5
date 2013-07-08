function beamformed = beamform_one_image(oneFrame,aperture,fs,c,focus_r,dynamicRange)


%  Central frequency 10MHz                       [Hz]
%fs = 40e6;            %  Sampling frequency                      [Hz]
% c = 1500;              %  Speed of sound                          [m/s]
no_elements = 128;      %  Number of elements in the transducer
width = .2/1000;
pitch = 38/127/1000;
kerf = pitch-width;

bft_init;%  Initialize the program

bft_param('c', c);
bft_param('fs', fs);

xdc = bft_linear_array(no_elements, width, kerf);

no_lines = 128;%  Define and create the image
bft_no_lines(no_lines);
%focus_r = [60:4500]'/1000;

center_focus = [-(no_elements-1)/2:(no_elements-1)/2]' * pitch;

for i = 1:no_lines
    %   bft_apodization(xdc,0,hanning(no_elements)',i);
  
    lo_index = i-1-aperture/2;
    if (lo_index <0) 
          lo_index = 0; 
    end  
    hi_index = i+aperture/2;
    if (hi_index >128) 
          hi_index = 128; 
    end
    if (i>32 && i <96)
        apertureWindow = ones(1,hi_index-lo_index);%.*hanning(hi_index-lo_index)';
    else
        apertureWindow =  ones(1,hi_index-lo_index);%.*hanning(hi_index-lo_index)';
    end
        
    %apertureWindow = ones(1,hi_index-lo_index);
    apo =[zeros(1,lo_index), apertureWindow, zeros(1,128-hi_index)];
    bft_apodization(xdc,0,apo,i);
    
 
    focus = [center_focus(i)*ones(length(focus_r),1), zeros(length(focus_r),1), focus_r];
    bft_center_focus([center_focus(i) 0 0],i);%set the center of focus to the center of transducer  %center_focus(i)
    T = (focus_r -.5/1000)/c *2;    
    bft_focus(xdc, T, focus,i);
  
end 

start_time = 0;
scat(:,:) = oneFrame;
beamformed = bft_beamform(start_time,scat);
%beamformed(1:2,:) = 0;
%bf_image = bft_add_image(bf_image, beamformed, emission_no, start_time); 
%displayBmode(beamformed,dynamicRange);
%  Release the allocated memory
bft_end 


