function readTexo(path, lineSize)
%this function reads the binary data acquired by Texo SDK 5., 6. ...
%which does not include the header file.
%the texo parameters like number of lines and lines length has to be
%resorted to the corresponding C program used to generate the data

%data path
%path = 'J:\19 JULY\TESTTEST\';
filename = 'data.txo';

%Texo params
numOfLines = 128;
%lineSize =1040;%1300;%1040;%910;

%opening file
fid = fopen([path, filename],'r');
RF_prev=0;
for i =2:20
fseek( fid, (i) * (lineSize*numOfLines)*2, 'cof');
RF = fread(fid,[lineSize, numOfLines],'int16');
%diff = RF-RF_prev;
%RF_prev = RF;
%sum(diff(:))
%plot(RF);
%continue;
bf_image = abs(hilbert(RF));                  % Envelope detection
bf_image = bf_image / max(max(bf_image));
%figure;
imagesc(20*log10(bf_image + 0.001),[-45 0])
colormap(gray(256));
colorbar
%frame = getframe;
%imwrite(frame.cdata,'texoBF.jpg');

drawnow;
%movegui('center');
%k = waitforbuttonpress;
end
fclose(fid);
return;



% Envelope detection
% 
% If you have access to RF data you can use the following code to generate the envelope in matlab
Env = abs(hilbert(RF));
% In case you have I/Q data use the following code
% >> Envelop = sqrt( I.^2 + Q.^2);
% 
% 2) Compression table
% 
% Log compression is the most commonly use method to compress the amplitude data 
Comp = 20*log10( Env );
% 
% 3) Mapping and Displaying
% 
% For linear mapping you can use the following code
Reject = 10; % noise floor in dB
DynamicRange = 60; % dynamic range in dB
B = 255 * (Comp - Reject) / DynamicRange;
% 
% The "DynamicRange (dB)" and "Reject (dB)" are two key parameters in generating your final B image. 
% 
% In Sonix systems, your RF data is 16bit signed data. 
% Which means you have 15 bit resolution to show the amplitude. 
% This means the maximum dynamic range that you can have is roughly 90dB. 
% Thus if you reject the first 20dB, you are only left with 70dB signal to work with 
% and setting the dynamic to be more than 70dB will just make your image look darker.
% 
% 4) Display
% 
% Finally for displaying you B mode image use the following code
imagesc(B , [0 255]);
colormap(gray(256));




