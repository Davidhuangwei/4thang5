no_elements = 128;      %  Number of elements in the transducer
width = .2/1000;
pitch = 38/127/1000;
kerf = pitch-width;
fs = 40e6;
c = 1500;
delay_per_element = floor(pitch/c * fs)+3;
no_samples = 1:3000;
distance = no_samples/fs*c*1000;% mm
for count = 48
frame(:,:) = passiveData(count,:,:);
for h = 3
delay_per_element = floor(pitch/c * fs) + h;%48-count;
for i = 1
    beamformed = beamform_one_image(frame,12,40e6,1500,i,40);        
    %temp = zeros(size(beamformed));
    %for j = 1: 128
    %    temp(:,j)  = circshift(beamformed(:,j),[-delay_per_element*(129-j) 1]);
        %shifted_line = beamformed(1+delay_per_element*(128-j):end,j);
        %temp(:,j) = padarray(shifted_line, size(temp,1)-length(shifted_line),-3000,'post');        
    %end
    displayBmode(beamformed(1:3000,:),40,strcat('frame',num2str(count)),distance);
    %figure;
    %displayBmode(temp(1:4000,:),20,strcat('frame',num2str(count)),distance);
    %saveas(gcf,strcat('bff',num2str(count),num2str(h),'.png'));
    %close;
end
end
end