% The following script reads the DAQ data and displays them on the screen
%
% Copyright Ultrasonix Medical Corporation - April 2010 
% Author: Reza Zahiri Azar

function runDAQ(path,varargin)%writeVideo1,fileName)

if (nargin==1)% if not specified filename
   writeVideo1 = 0;%then run without saving the file
   fileName = path;
else
    writeVideo1 = 1; %otherwise savevideo
    fileName = varargin{1};
end
   
close all
%clear all
clc
%%
nCh = 128;%128          % number of channels
reRoute = true;         % true: transducer element (correct image), false: DAQ element
chanls = ones(1,nCh);   % what channels to read (DAQ element), for each channel set to 1 
                        % if you want to read the data 

if (path(end) ~= '\') 
    path = [path,'\']; % correct the path
end 


if (writeVideo1==1)
    writerObj = VideoWriter(fileName); 
    writerObj.FrameRate = 8;
    open(writerObj);    
end
N = 140;
headerFile = readDAQ(path, chanls, 1 , reRoute);
N = min(140,headerFile(1));
for frameN = 1:1:N  % display first N frames
    % read the data
    [hdr, RF1] = readDAQ(path, chanls, frameN , reRoute);
    
    frameSequence(frameN,:,:) = RF1(:,:);    %raw signal
    RF =(abs( hilbert(RF1(:,:)) ))  ;% envelope detection
    RF = RF /max(max(RF));%normalize to have max of 1
    RF = 20*log10(RF+0.001);% 0 dB is max. Compress the envelope
    G = 45;
    imagesc(RF,[-G 0]);% display with dynamic range G
    title(['Transmit #',num2str( frameN )]);    
    xlabel('Channels')
    ylabel('Samples (Depth)')
    colormap gray;
    colorbar
    drawnow
   
    if (writeVideo1)
        frame = getframe;
        writeVideo(writerObj,frame);
    end
end
    save(fileName,'frameSequence');

if(writeVideo1)
    close(writerObj);
end

end