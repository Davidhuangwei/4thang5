function line = beamformed(x, center, left_aperture, right_aperture)

focusPoint = [25 0 50]/1000;
speedOfSound = 1540;
samplingFrequency = 40e6;
no_elements = 128; 
%this specification is for l14-5/38
width = 0.2798 *1e-3;     % Width of the element                     [m]
kerf =  0.025 *1e-3;%pitch - width;  % Inter-element spacing                    [m]
pitch = width + kerf;


for element = left_aperture:right_aperture
    
        centerPoint = [center * pitch 0 0];
        elementPoint = [element * pitch 0 0];
        
        delay = calculateDelay(centerPoint,focusPoint,elementPoint,speedOfSound);
        line = line + delaySignal(x,element,delay,samplingFrequency);
    
   
end


end


