
%image(imcrop);
%im = im(:,:,1);
%imC = imC(:,:,1);

for j = 1:500
    im = s(j).cdata;
    fun = @(block_struct) l2diff(block_struct.data,imC);
    diff_array = blockproc(im,[20 20],fun); 
    [I,J]=ind2sub([54 96],find(diff_array==0));

    blah=im;
    
    
    for i=1:length(I)
        blah(I(i)*20:(I(i)+1)*20,J(i)*20:(J(i)+1)*20,:)=255;
    end
    image(blah);
    pause(0.1);
    
    
    
end


function patchdiff = l2diff(patch,im_c)
    patchdiff = sum(sum(sum((patch-im_c).^2)));
end



