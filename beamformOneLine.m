function beamformed_line = beamformOneLine( frame,center_ele,fs,Aperture_Width,bf_range )

%fs :sampling frequency 40Mhz

c = 1540;               % speed of sound 
no_elements = 128;      % Number of elements in the transducer
pitch = 38/127;         % element to element distance


array_coordinate = (-(no_elements-1)/2:(no_elements-1)/2)' * pitch; % -19 mm to 19 mm

focus_x = array_coordinate(center_ele); % x coordinate of the center element of the aperture 

no_samples_per_line = size(frame,1); 

beamformed_line = zeros(1,no_samples_per_line);

for focus_z = bf_range(1):0.1:bf_range(2);% mm
    distance_center = focus_z;% z coordinate of the focus
    sample_center = fix(distance_center/c /1000 *fs); %convert into sample number; round off error
    for i=(-Aperture_Width/2):(Aperture_Width/2)
    
        idx_x_i = center_ele + i; % element number i of the aperture
        if (idx_x_i<1 || idx_x_i>128)
            continue;
        end
        x_i = array_coordinate(idx_x_i); % convert the coordinate into mm
        
        distance = power(x_i-focus_x,2) + focus_z * focus_z; % distance from the focal point to the element i
        distance = sqrt(distance);
        delay_time = (distance_center - distance) / c /1000; % delay time 
        
        delay_sample_real = delay_time * fs;
        delay_sample_round = fix(delay_sample_real); % in samples
        
        interpolated_coeff = delay_sample_round - delay_sample_real;
        delayed_sample_adjusted = sample_center-delay_sample_round;% delayed sample
        
        if (delayed_sample_adjusted > 0 && delayed_sample_adjusted < no_samples_per_line) % check for out of range
            %interpolated_coeff = 1-interpolated_coeff;
            inter_value = (1-interpolated_coeff) * frame(delayed_sample_adjusted,idx_x_i)+ interpolated_coeff * frame(delayed_sample_adjusted+1,idx_x_i);
            %beamformed_line(sample_center) = beamformed_line(sample_center) +frame(delayed_sample_adjusted,idx_x_i);%+ inter_value;
             beamformed_line(sample_center) = beamformed_line(sample_center) + inter_value;
        end
    end
end
%plot(beamformed_line);
%pause;
%close
end

