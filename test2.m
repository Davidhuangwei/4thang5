fs = 80*10^6;  
c = 1500;
pitch = 38/127/1000;
ha = phased.ULA('NumElements',128,'ElementSpacing',pitch);
ha.Element.FrequencyRange = [20 20000];
for i =0
incidentAngle =[i ; 0];
hbf = phased.TimeDelayBeamformer('SensorArray',ha,...
    'SampleRate',fs,'PropagationSpeed',c,...
    'Direction',incidentAngle);
y = step(hbf,frame);
plot(y);
%title(num2str(i));
%drawnow
end