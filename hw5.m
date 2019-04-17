clear variables; close all; clc;

%% Video 1: Ball
w = 256;
h = 144;
framerate = 29.9887;
dt = 1/framerate;

Xname = 'X20190312_181033.mat'; 
% starts at about 70
% ends at about 150
load(Xname)

X = X(:, 20:155);

frames = size(X,2);

r = 20;

tic
X1 = X(:,1:end-1);
X2 = X(:,2:end);
[Phi,omega,lambda,b,Xdmd,s] = DMD(X1,X2,r,dt);
toc

X(:,1) = [];

Xsparse = X - abs(Xdmd);

R = zeros(size(Xsparse));
R(Xsparse<0) = Xsparse(Xsparse<0);

Xsparsedmd = Xsparse - R;
Xlowrankdmd = Xdmd + R;

figure(1)
colormap(bone)
for i = 1:frames-1
    subplot(1,3,1)
    im = Xsparsedmd(:,i);
    imagesc(reshape(im, [h w])); axis image
    subplot(1,3,2)
    imagesc(reshape(real(Xdmd(:,i)), [h w])); axis image
    subplot(1,3,3)
    imagesc(reshape(X(:,i), [h w])); axis image
    title(i)
    drawnow
end

figure(1)
subplot(3,10,1:10)
imagesc(reshape(real(Xdmd(:,1)), [h w])); axis image
title('Background Image')
xticks([])
yticks([])

frm = fix(linspace(65,frames-21,10));

for j = 10:-1:1
    subplot(3,10,10+j)
    i = frm(j);
    im = Xsparsedmd(:,i);
    imagesc(reshape(im, [h w])); axis image
    title(i)
    xticks([])
    yticks([])
end
ylabel('X_{sparse}')

for j = 10:-1:1
    subplot(3,10,20+j)
    i = frm(j);
    imagesc(reshape(X(:,i), [h w])); axis image
    xticks([])
    yticks([])
end
ylabel('Original Video')

fig11 = figure(11);
plot(s/sum(s), 'o')
title('Singular Values for Ball Video')
saveas(fig11, 'svball.png')

fig111 = figure(111);
scatter(real(omega), imag(omega))
xlabel('Re(\omega)')
ylabel('Im(\omega)')
title('Values of Omega on the Complex Plane for Ball Video')
saveas(fig111, 'omegaball.png')
%%
fig1111 = figure(1111);
E = zeros([1 frames-1]);
for i = 1:frames-1
    E(i) = norm(X(:,i) - (Xsparsedmd(:,i) + Xlowrankdmd(:,i)),2);
end
semilogy(E, 'o');
yline(mean(E), '--', {sprintf('Average=%.2f',mean(E))})
title('|X-(X_{Fg} + X_{Bg})|_2 at Each Frame on Logplot for Ball Video')
ylabel('L2 Error')
xlabel('Video Frame Number')
axis tight

saveas(fig1111, 'errorball.png')

%% Video 2: Cat
w = 144;
h = 256;
framerate = 29.9887;
dt = 1/framerate;

Xname = 'X20190312_125426.mat';

load(Xname)

frames = size(X,2);

r = 20;

tic
X1 = X(:,1:end-1);
X2 = X(:,2:end);
[Phi,omega,lambda,b,Xdmd,s] = DMD(X1,X2,r,dt);
toc

X(:,end) = [];

Xsparse = X - abs(Xdmd);
R = Xsparse.*(Xsparse<0);
Xsparsedmd = Xsparse - R;
Xlowrankdmd = Xdmd + R;

fig2 = figure(2);
colormap(bone)
for i = 1:frames-1
   subplot(1,3,1)
   im = Xsparsedmd(:,i);
   %im(abs(im)<40) = 0;
   imagesc(reshape(im, [h w])); axis image
   subplot(1,3,2)
   imagesc(reshape(abs(Xdmd(:,i)), [h w])); axis image
   title(sprintf('Frame #%d', i))
   subplot(1,3,3)
   imagesc(reshape(X(:,i), [h w])); axis image
   drawnow
   if i == 350
       saveas(fig2, 'cat.png')
   end
end

fig22 = figure(22);
plot(s/sum(s), 'o')
title('Singular Values for Cat Video')
xlabel('Mode')
ylabel('Energy Captured')
saveas(fig22, 'svcat.png')

fig2222 = figure(2222);
E = zeros([1 frames-1]);
for i = 1:frames-1
    E(i) = norm(X(:,i) - (Xsparsedmd(:,i) + Xlowrankdmd(:,i)),2);
end
plot(E, 'o');
yline(mean(E), '--', {sprintf('Average=%.2f',mean(E))})
title('|X-(X_{Fg} + X_{Bg})|_2 at Each Frame for Cat video')
ylabel('L2 Error')
xlabel('Video Frame Number')
axis tight

saveas(fig2222, 'errorcat.png')


%% Video 3: Walking
w = 256;
h = 144;
framerate = 29.9887;
dt = 1/framerate;

Xname = 'X20190312_195723.mat';

load(Xname)
X = X(:,100:end-60);

frames = size(X,2);

r = 5;

tic
X1 = X(:,1:end-1);
X2 = X(:,2:end);
[Phi,omega,lambda,b,Xdmd,s] = DMD(X1,X2,r,dt);
toc

X(:,end) = [];

Xsparse = X - real(Xdmd);
R = zeros(size(Xsparse));
R(Xsparse<0) = Xsparse(Xsparse<0);
Xsparsedmd = Xsparse - R;
Xlowrankdmd = Xdmd + R;

fig3 = figure(3);
colormap(bone)
for i = 1:frames-1
   subplot(1,3,1)
   im = Xsparsedmd(:,i);
   imagesc(reshape(im, [h w])); axis image
   subplot(1,3,2)
   imagesc(reshape(real(Xdmd(:,i)), [h w])); axis image
   title(sprintf('Frame #%d', i))
   subplot(1,3,3)
   imagesc(reshape(im+real(Xdmd(:,i)), [h w])); axis image
   drawnow
   if i == 85
       saveas(fig3, 'walk.png')
   end
end

fig33 = figure(33);
plot(s/sum(s), 'o')
title('Singular Values for Walking Video')
xlabel('Mode')
ylabel('Energy Captured')
saveas(fig33, 'svwalk1.png')
%%
fig3333 = figure(3333);
E = zeros([1 frames-1]);
for i = 1:frames-1
    E(i) = norm(X(:,i) - (Xsparsedmd(:,i) + Xlowrankdmd(:,i)),2);
end
plot(E, 'o');
yline(mean(E), '--', {sprintf('Average=%.2e',mean(E))})
title('|X-(X_{Fg} + X_{Bg})|_2 at Each Frame for Walking video')
ylabel('L2 Error')
xlabel('Video Frame Number')
axis tight

saveas(fig3333, 'errorwalk.png')

%% Video 4: Walking
w = 256;
h = 144;
framerate = 29.9887;
dt = 1/framerate;

Xname = 'X20190313_165031.mat';

load(Xname)

frames = size(X,2);

r = 40;

tic
X1 = 255-X(:,1:end-1);
X2 = 255-X(:,2:end);
[Phi,omega,lambda,b,Xdmd,s] = DMD(X1,X2,r,dt);
toc

X(:,end) = [];

Xdmd = Xdmd;

Xsparse = X - real(Xdmd);
R = zeros(size(Xsparse));
R(Xsparse<0) = Xsparse(Xsparse<0);
Xsparsedmd = Xsparse - R;
Xlowrankdmd = Xdmd + R;

figure(4)
colormap(bone)
for i = 1:frames-1
   subplot(1,3,1)
   im = Xsparsedmd(:,i);
   imagesc(reshape(im, [h w])); axis image
   subplot(1,3,2)
   imagesc(reshape(real(Xlowrankdmd(:,i)), [h w])); axis image
   subplot(1,3,3)
   imagesc(reshape(X(:,i), [h w])); axis image
   title(i)
   drawnow
end

figure(44)
plot(s)