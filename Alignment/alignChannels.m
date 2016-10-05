function [imShift, predShift] = alignChannels(im, maxShift)

% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));


imShift = im;
saveIm = im;
breakflag = 0;
shiftI = zeros(1,2);
shiftJ = zeros(1,2);
maxShift = maxShift(1);

imShift1 = imShift(:,:,1);
imShift2 = imShift(:,:,2);
imShift3 = imShift(:,:,3);



%shift and subtracting to highlight edges
imShift(:,:,1) = imShift(:,:,1)- circshift(imShift(:,:,1),[0 3]);
imShift(:,:,2) = imShift(:,:,2)- circshift(imShift(:,:,2),[0 3]);
imShift(:,:,3) =imShift(:,:,3)- circshift(imShift(:,:,3),[0 3]);

im = imShift;


function predicted = alignOneChannel(k)
    scores1 = zeros(maxShift,maxShift);
    if k==2
        level = 1;
    elseif k==3
        level = 2;
    end
for i = -maxShift:maxShift
    for j = -maxShift:maxShift
        shiftI(level) = i;
        shiftJ(level) = j;
        imShift(:,:,k) = circshift(im(:,:,k),[shiftI(level) shiftJ(level)]);
        %score with residuals
        scores1(i+(maxShift)+1,j+(maxShift)+1) =  sum(sum((imShift(:,:,k)-imShift(:,:,1)).^2)); 
        imShift(:,:,k) = im(:,:,k);
    end
end
[minimum, oneDargmin] = min(scores1(:));
[argminI,argminJ] = ind2sub(size(scores1),oneDargmin);
shiftI(level) = argminI-(maxShift+1);
shiftJ(level) = argminJ-(maxShift+1);
predicted(1) = shiftI(level);
predicted(2) = shiftJ(level);
end %end function def

%give shifts for aligning channels 2 and 3 to 1.
finalpredicted2 = alignOneChannel(2);
finalpredicted3 = alignOneChannel(3);

finalShiftI = [finalpredicted2(1) finalpredicted3(1)];
finalShiftJ = [finalpredicted2(2) finalpredicted3(2)];
imShift = saveIm;

%align channels
imShift(:,:,2) = circshift(saveIm(:,:,2),[finalShiftI(1) finalShiftJ(1)]);
imShift(:,:,3) = circshift(saveIm(:,:,3),[finalShiftI(2) finalShiftJ(2)]);

%report shift vectors
predShift = [finalShiftI' finalShiftJ'];
end