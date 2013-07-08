path = 'D:\1th12';
directoryStruct  = dir(path);
for i = 1:length(directoryStruct)
    fileName = directoryStruct(i).name;
    
    if (length(fileName)>2)
        path1 = strcat(path,'\',fileName);
        innerDirecStruc = dir(path1);
        if (length(innerDirecStruc)>10)
            runDAQ(path1,fileName);
        end
    end
end