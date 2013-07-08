no_elements = 128;      %  Number of elements in the transducer
width = .2/1000;
pitch = 38/127/1000;
kerf = pitch-width;
fs = 40e6;
c = 1500;
delay_per_element = floor(pitch/c * fs)+3;
no_samples = 1:3000;
distance = no_samples/fs*c*1000;% mm
for count = 50
    for i = 10
        frame(:,:) = passiveData(count,:,:);
        frame1 = frame(200:end,:);
        figure;
        displayBmode(frame1,30,strcat('frame',num2str(count)),distance);
        beamformed = beamform_one_image(frame1,8,40e6,1500,i,40);        
        figure;
        displayBmode(beamformed,30,strcat('frame',num2str(count)),distance);
    end

end