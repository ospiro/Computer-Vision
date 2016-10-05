function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images
%   Author: Subhransu Maji


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)

imShift = im;
saveIm = im;
breakflag = 0;
shiftI = zeros(1,2);
shiftJ = zeros(1,2);
maxShift = maxShift(1);
scores1 = zeros(maxShift,maxShift);
imShift1 = imShift(:,:,1);
imShift2 = imShift(:,:,2);
imShift3 = imShift(:,:,3);
chan1mean = mean(imShift1(:));

imShift(:,:,1) = imShift(:,:,1)- circshift(imShift(:,:,1),[1 0]);
imShift(:,:,2) = imShift(:,:,2)- circshift(imShift(:,:,2),[1 0]);
imShift(:,:,3) =imShift(:,:,3)- circshift(imShift(:,:,3),[1 0]);

im = imShift;



for i = 1:2*maxShift+1
    for j = 1:2*maxShift+1
        shiftI(1) = i-(maxShift+1);
        shiftJ(1) = j-(maxShift+1);
        imShift(:,:,2) = circshift(im(:,:,2),[shiftI(1) shiftJ(1)]);
%         column2 = imShift(:,:,2);
%         column2 = column2(:);
%         column1 = imShift(:,:,1);
%         column1 = column1(:);
%         normed2 = column2./norm(column2);
%         normed1 = column1./norm(column1);
%         ncc = sum(sum(normed1.*normed2));
        scores1(i,j) = sum(sum((imShift(:,:,2)-imShift(:,:,1)).^2));% -ncc;
        imShift(:,:,2) = im(:,:,2);
    end
end
[minimum, oneDargmin] = min(scores1(:));
[argminI,argminJ] = ind2sub(size(scores1),oneDargmin);
shiftI(1) = argminI-(maxShift+1);
shiftJ(1) = argminJ-(maxShift+1);
imShift(:,:,2) = circshift(saveIm(:,:,2),[shiftI(1) shiftJ(1)]);

scores2=zeros(maxShift,maxShift);
for i = 1:2*maxShift+1
    for j = 1:2*maxShift+1
        shiftI(2) = i-(maxShift+1);
        shiftJ(2) = j-(maxShift+1);
        imShift(:,:,3) = circshift(im(:,:,3),[shiftI(2) shiftJ(2)]);
%         column3 = imShift(:,:,3);
%         column3 = column3(:);
%         column1 = imShift(:,:,1);
%         column1 = column1(:);
%         normed3 = column3./norm(column3);
%         normed1 = column1./norm(column1);
%         ncc = sum(normed1.*normed3);
        scores2(i,j) = sum(sum((imShift(:,:,3)-imShift(:,:,1)).^2));%-ncc;
        imShift(:,:,3) = im(:,:,3);
    end
end
[minimum, oneDargmin] = min(scores2(:));
[argminI,argminJ] = ind2sub(size(scores2), oneDargmin);
shiftI(2) = argminI-(maxShift+1);
shiftJ(2) = argminJ-(maxShift+1);
imShift(:,:,3) = circshift(saveIm(:,:,3),[shiftI(2) shiftJ(2)]);
imShift(:,:,1) = saveIm(:,:,1);

predShift = [shiftI' shiftJ'];