function output = prepareData(imArray, ambientImage)
[h,w,n] = size(imArray);
for i = 1:n
    im = imArray(:,:,i) - ambientImage;% subtract ambient
    im(im<0)=0;%to negatives
end
imArray = imArray ./ max(imArray(:));
output = imArray;


    