function output = prepareData(imArray, ambientImage)
% PREPAREDATA prepares the images for photometric stereo
%   OUTPUT = PREPAREDATA(IMARRAY, AMBIENTIMAGE)
%
%   Input:
%       IMARRAY - [h w n] image array
%       AMBIENTIMAGE - [h w] image 
%
%   Output:
%       OUTPUT - [h w n] image, suitably processed
%
% Author: Subhransu Maji
%

% Implement this %
% Step 1. Subtract the ambientImage from each image in imArray
% Step 2. Make sure no pixel is less than zero
% Step 3. Rescale the values in imarray to be between 0 and 1
[h,w,n] = size(imArray);
for i = 1:n
    imArray(:,:,i) = imArray(:,:,i) - ambientImage;
end
mask = ones(h,w);
%no negatives
for i = 1:n
    mask = ones(h,w);
    im = imArray(i);
    mask(im < 0) = -1;
    im(mask < 0) = 0;
    imArray(i) = im;
end
imArray = imArray/255;
output = imArray;


    