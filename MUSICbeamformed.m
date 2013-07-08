function MUSICbeamformed(frame)
%%
%frame(:,:) = frameSequence(10,:,:);
frame = frame/max(max(frame));
env = hilbert(frame);% envelope detection
comp = 20*log(abs(env)); % amplitude compression
imagesc(comp,[-40 0]); %  display
colormap gray
%%

%X  = frame(1:3000,:)';
X = frame';
%%
[U, S, V ] = svd(X);
Un = U(:,2:end);

pitch = 38/127/1000;
c = 1500;
f = 6.5e6;
lamda = c / f;
g = zeros(1,180);
for theta  = 1:180
    goc = theta/180*pi;
    phi = exp(1i*2*pi*pitch*sin(goc)/lamda);
    a = zeros(1,128);
    for j = 1:128
        a(j) = phi^(j-1);
    end
    g(theta)  = norm(Un'*a');
    
end
plot(1./g)
