function hybridIm = hybridImage(im1,im2,sigma1,sigma2)
im1 = im2double(im1);
im2 = im2double(im2);
normfactor1 = 1/(2*pi*sigma1*sigma1);
normfactor2 = 1/(2*pi*sigma2*sigma2);
g1 = zeros(9,9);

%create the two filters
for i = 1:9
    for j = 1:9
        x = j-5;
        y = 5-i;
        g1(i,j) = normfactor1*exp(-(1/(2*sigma1*sigma1))*(x^2 + y^2));
    end
end
g2 = zeros(9,9);
for i = 1:9
    for j = 1:9
        x = j-5;
        y = 5-i;
        g2(i,j) = normfactor2*exp(-0.5*(x^2 + y^2));
    end
end

%hybridize
[h,w,n] = size(im1);
hybridIm = zeros(h,w,n);
for i =1:n
    hybridIm(:,:,i) = filter2(g1,im1(:,:,i)) + (im2(:,:,i)-filter2(g2,im2(:,:,i))); 
end
end

%current best is (im2,im1,1.5,1.5)