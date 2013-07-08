% Read in signals from scatterers to an array of elements
% HSIR constructed for each element
% Based on domain centered at 76 mm in depth with the dimensions of 6 mm by
% 25 mm. Center frequency of array elements 6.5 MHz. Size of pixels are
% 0.06 mm.
%%
field_init(0);

clear all
close all

%% Specifying the sampling rate and speed of sound:
fs = 500*10^6;          c = 1500;
set_field('fs', fs);    set_field('c',c);

%% Impulse response

f0 = 6.5*10^6;
dt = 1/fs;
T = round(fs/f0);
imp_res = sin(2*pi*f0*(1:4*T).*dt)'.*hanning(4*T);
img_depth = 63;

%% Create the domain (1 scatterer)

nscat = 3; %20*84;
scat_mat = rand(nscat,2);
localphantom = [scat_mat(:,1).*6-3, zeros(nscat,1), scat_mat(:,2).*25]./1000;

scat_location(:,1) = [-15,0,76]./1000'; % Millimeters
scat_location(:,2) = [-15,0, 50]./1000';
scat_location(:,3) = [0,0 76]./1000';
scat_location(:,4) = [10,0,63]./1000';

%% Define elements

width = .2/1000;
height = 8/1000;
pitch = 38/127/1000;
kerf = pitch-width;
N_elements = 1;
focus = [0 0 10^6]/1000;
L = 38/1000;
range = L/2;
N = 128;
depth =img_depth/1000;
trans = xdc_linear_array(N_elements, width, height, kerf, 8,40,focus);%Th = xdc_linear_array (no_elements, width, height, kerf, no_sub_x, no_sub_y, focus); 
xs = linspace(-range, range, N);
ys = zeros(N,1);    
%%
dr = 13;
signal = zeros(2^dr,N);
ft_ir = fft(imp_res,2^dr);
ft_ir = repmat(ft_ir,1,N);
zs = depth*ones(N,1);
elements = 128;
cen_arr = (elements+1)/2;
tmax = 20000;
sigsize = fix(25/1000/c/dt)+2^dr;
signal = zeros(sigsize,N);
for n = 1:nscat
    [sir, start_time] = calc_h(trans, [xs(:)-localphantom(n,1) ys(:) localphantom(n,3)*ones(N,1)+63/1000]);
    fsir = fft(sir,2^dr);
    ft = fsir.*ft_ir;
    signtemp = real(ifft(ft));
    temp = [zeros(fix(localphantom(n,3)/c/dt),N)', signtemp', zeros(fix(sigsize-2^dr+1-localphantom(n,3)/c/dt),N)']'; 
    signal = signal+temp;
end
%%
dbhil = 20*log10(abs(hilbert(signal)));
dbhil = dbhil-max(max(dbhil));
time = (1:2^dr).*dt;
distance = c*1000*time;
figure
imagesc(xs.*1000,distance,dbhil)
%imagesc(dbhil)
colormap('gray')
return;
%%
for m = 1:25
    z = (m-1+63)/1000
    for i = 1:128
        xdis = (i-(1:128)).*pitch/1000;
        dis = sqrt(xdis.^2+z^2);
        tau = (dis-z)./(c);
        deltau = fix(tau./dt);
        for n = 1:128
            sig(:,n) = [zeros(tmax-deltau(n)+fix((m-1)/1000/c/dt),1)', signal(:,n)', zeros(tmax+deltau(n)-fix((m-1)/1000/c/dt),1)']';
        end
        sumsig(:,i) = sum(sig,2);
    end
end
%%
xax = ((1:128)*pitch-(129/2)*pitch);
dbhilsig = 20*log10(abs(hilbert(sumsig)));
dbhilsig = dbhilsig-max(max(dbhilsig));
figure
yax = 1000*c*((1:2*tmax+2^dr).*dt-tmax*dt-3333*dt)+63;
imagesc(xax,yax,dbhilsig, [-35 0])
xlim([-3 3])
xlabel('Lateral Distance (mm)')
ylim([img_depth+1 img_depth+24])
colormap('gray')
field_end();