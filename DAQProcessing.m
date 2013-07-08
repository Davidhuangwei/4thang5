function DAQProcessing


for i = 9:16
    fileName = strcat('trong',num2str(i));
    runDAQ(fileName,fileName);
end

end