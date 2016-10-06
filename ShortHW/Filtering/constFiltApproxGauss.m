clear
im = imread('cat.jpg','jpg');
im = im2double(im);
im = im(:,:,1);
normfactor = 1/(2*pi);
gaussFilt = zeros(5,5);

%create gaussian filter
for i = 1:9
    for j = 1:9
        x = j-41;
        y = 41-i;
        gaussFilt(i,j) = normfactor*exp(-0.5*(x^2 + y^2));
    end
end
%loop to compare i iterations of const filter with gauss filter. Pad array
%with zeros to avoid boundary problems with 'full'.
constFilt = (1/81)*ones(9,9);
repConstFilt = constFilt;
resids = zeros(100);
for i = 1:100
    repConstFilt = filter2(constFilt,repConstFilt,'same');
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