% 2021-11-18
% Local biharmonic for image inpainting

clear; close all

%% Barbara for a damaged5
Name = 'Barbara_damaged5';
load (Name);
forig = f;
% figure, imshow(uint8([f, I, D0*255]),[]);
% title("Damaged and Original image");
[Nx, Ny] = size(I);

%% Parameter of NLF
dt = 1e-2;%1e-4;
lambda = 0;%0.01;

%% Initialization
uv = reshape(f, Nx*Ny, 1);
u = f;
D = D0;
eps = 1e-5;
iterN = 100000;

for i=1:iterN
    
    %% Fidelity term
    uf = (f - u).*D;
    tmpf = lambda * reshape(uf, Nx*Ny, 1); % E-L fidelity
    
    %% BH
    u_xx = u([2:end end],:) + u([1 1:end-1],:) - 2*u;
    u_yy = u(:,[2:end end]) + u(:,[1 1:end-1]) - 2*u;
    u_lap = u_xx + u_yy;
    u_lap_xx = u_lap([2:end end],:) + u_lap([1 1:end-1],:) - 2*u_lap;
    u_lap_yy = u_lap(:,[2:end end]) + u_lap(:,[1 1:end-1]) - 2*u_lap;
    
    u_lap_lap = u_lap_xx + u_lap_yy;
    
    %% finite difference
    u = u - dt*u_lap_lap + lambda*uf;
    u = f.*D0 + u.*(1-D0);
    
    PSNR = psnr(u, I);
    dif = u-f;
    
    if (mod(i, 5000)==0)
        disp(['iter: ' num2str(i) '---PSNR: ' num2str(PSNR)]);
        figure(112), imshow(dif,[])
        figure(113), imshow(uint8([u, f, I]),[]); 
        title("u, f, I, inpainted result and Original image");
    end
end
