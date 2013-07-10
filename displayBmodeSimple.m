function displayBmodeSimple(frame,dynamicRange,no_samples)
    no_elements = 128;      % Number of elements in the transducer
    pitch = 38/127;         % element to element distance
    array_coordinate = (-(no_elements-1)/2:(no_elements-1)/2)' * pitch; 
    max_distance = no_samples * 1500 /40e3;
    distance = 0 : max_distance;
    %distance = distance;

    bf_image1 = abs(hilbert(frame));                  % Envelope detection
    bf_image1 = bf_image1 / max(max(bf_image1));
    imagesc(array_coordinate,distance,20*log10(bf_image1 + 0.001),[-dynamicRange 0]);
    xlabel('Lateral position (mm)');
    ylabel('Axial position (mm)')
    colormap gray;
    colorbar 
    drawnow
end