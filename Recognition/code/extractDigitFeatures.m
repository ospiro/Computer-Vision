function features = extractDigitFeatures(x, featureType)
% EXTRACTDIGITFEATURES extracts features from digit images
%   features = extractDigitFeatures(x, featureType) extracts FEATURES from images
%   images X of the provided FEATURETYPE. The images are assumed to the of
%   size [W H 1 N] where the first two dimensions are the width and height.
%   The output is of size [D N] where D is the size of each feature and N
%   is the number of images. 

x = squeeze(x);
%x = sqrt(x);
switch featureType
    case 'pixel'
        features = pixelFeatures(x);%pixelFeatures(x);
    case 'hog'
        features = hogFeatures(x);
    case 'lbp'
        features = lbpFeatures(x);
end


end

function features = pixelFeatures(x)
    features=zeros([784 2000]);
    for i=1:2000
        features(:,i) = sqrt(reshape(x(:,:,i),[784 1]))/norm(sqrt(reshape(x(:,:,i),[784 1])));
    end
end

function features = hogFeatures(x)
    features=[];
    numOri=8;
    binSize = 4;
    
    obins = [-1/2:1/numOri:1/2]*pi;
%     obins = (-1:1/(0.5*numOri-1):1)*180;
    hist=[];%hist = zeros([1 size(bins,2)]);
    grady = zeros([27 28 2000]);
    gradx = zeros([28 27 2000]);
%     mag = zeros([ 28 28 2000]);
%     ori = zeros([ 28 28 2000]);
    for i=1:2000
        grady(:,:,i) = diff(x(:,:,i),1,1);%imgradientxy(x(:,:,i));%imgradientxy doesn't play well with third dimension
        gradx(:,:,i) = diff(x(:,:,i),1,2);
    end
    grady(28,:,:) = 0;
    gradx(:,28,:) = 0;
    mag = sqrt(gradx.^2 + grady.^2);
    ori = atan(grady./gradx);
    ori(isnan(ori))=0;
    ori = discretize(ori,obins);
    
    
    
%     spacebins_i = [1:1/(binSize-1):1]*size(x,2);
%     spacebins_j = [1:1/(binSize-1):1]*size(x,1);
    

    
    for n=1:2000
       o_in = ori(:,:,n);
       m_in = mag(:,:,n);
       m_o = cat(3,m_in,o_in);
       fun = @(block_struct) make_hist(block_struct.data);
       grid = blockproc(m_o,[binSize binSize],fun)';
       
       feature_vec = grid';
       features = [features feature_vec(:)];
       
       
%        for k =2:length(spacebins)
%            for l=2:length(spacebins)
%             hist = [hist; make_hist(o(spacebins_i(k-1):spacebins_i(k+1)-1,spacebins_j(k-1):spacebins_j(k+1)-1),mag(spacebins_i(l-1):spacebins_i(l+1)-1,spacebins_j(l-1):spacebins_j(l+1)-1))];
%            end % TODO:is this how they should be concatenated
%        end
    end
    
    
    
    
    function h = make_hist(patch)
    %     m = bs.data;
    %     startInd = bs.location;
    %     endInd   = bs.location+bs.blockSize-1;
    %     o = o_in(startInd(1):endInd(1), startInd(2):endInd(2));
       m = patch(:,:,1);
       o = patch(:,:,2);
       h=zeros([1 size(obins,2)]);
       for bin = 1:size(obins,2)
%           mask = zeros(size(m));
          mask = (o==bin);
          mult = mask.*m;
          h(bin) = sum(sum(mult));
       end
    end
% for i=1:2000
%    hist =[hist; blockproc(@(x) make_hist(mag(:,:,i),ori(:,:,i)) x];%TODO:remove
% end
%

end

function features = lbpFeatures(x)

    features = [];
    function lbpim = lbp(im)
        lbpim = zeros(size(im));
        for i=2:27
            for j=2:27
                pp=[];
                for k =-1:1
                    for l = -1:1
                        if ~(k==0 && l==0)
                              pp=[pp sign(im(i+k,j+l)-im(i,j))];%pre-allocate for speed
                        end
                    end
                end
                p=0;
                pp(pp<0) = 0;
                for idx =1:8
                    p = p + pp(idx).*(2^(idx-1));
                end
                lbpim(i,j) = p;
            end
        end
       
        
    end

    vals = 0:255;
    for n =1:2000
        n;
%         imshow(x(:,:,n));
        grid = lbp(x(:,:,n));
%         image(grid)
        feature_vec = sqrt(histc(grid(:),vals))/norm(sqrt(histc(grid(:),vals)));
        features = [features feature_vec];
    end
    
end
    

function features = zeroFeatures(x)
features = zeros(10, size(x,4));
end
