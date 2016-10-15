function [albedoImage, surfaceNormals] = photometricStereo(imArray, lightDirs)
[h,w,n] = size(imArray);
N = zeros(h,w,3);
albedoImage = zeros(h,w);
for i = 1:h
    for j = 1:w
        I = imArray(i,j,:);
        I = I(:);
        V = lightDirs;
        g = V\I;
        rho = norm(g);
        N(i,j,:) = g/rho;
        albedoImage(i,j) = rho;
    end
end
surfaceNormals = N;

        
        