% im = imread('ca-nn-dmsc.jpg','jpg');
% im = im2double(im);
% im = im(:,:,1);
normfactor = 1/(2*pi);
gaussFilt = zeros(5,5);

%create gaussian filter
for i = 1:5
    for j = 1:5
        x = j-3;
        y = 3-i;
        gaussFilt(i,j) = normfactor*exp(-0.5*(x^2 + y^2));
    end
end
% imFiltGauss = filter2(gaussFilt,im,'same');

%loop to compare i iterations of const filter with gauss filter
constFilt = (1/25)*ones(5,5);
repConstFilt = constFilt;
resids = zeros(100);
for i = 1:100
    repConstFilt = filter2(repConstFilt,constFilt,'same');
    sum(sum((repConstFilt-gaussFilt).^2))
end
% figure
% plot(1:100,resids);
% imshow(im);
% pause(2);
% imshow(imFiltGauss);
% pause(2);
% imshow(imFiltConst);
%         
%     