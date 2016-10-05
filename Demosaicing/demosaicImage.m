function output = demosaicImage(im, method)
switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosacing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue; %whole channel is meanval
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);%fill in the known squares, leaving the others as meanval

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;
end
%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------

function mosim = demosaicNN(im)
mosim = repmat(im,[1 1 3]);
[imageHeight,imageWidth] = size(im);
function neighborArray = getOKNeighbors(i,j)
stepI = [-1 0 1 0];
stepJ = [0 -1 0 1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end


function neighborArray = getOKDiagNeighbors(i,j)
stepI = [-1 -1 1 1];
stepJ = [-1 1 -1 1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end

    



%%%%%%%%%%%red channel%%%%%%%%%%%%%%%%%%%%%%%%%
%red into blue
redIm = mosim(:,:,1);
for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [-1 -1 1 1; -1 1 -1 1];
        if i==imageHeight||j==imageWidth
        nearest = getOKDiagNeighbors(i,j);
        end
        redIm(i,j) = redIm(i+nearest(1,1),j+nearest(2,1)); 
    end
end
%red into green
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
            nearest = [-1 0 1 0;0 -1 0 1];
            if i==imageHeight || j == imageWidth ||i==1||j==1
            nearest = getOKNeighbors(i,j);
            end
            for count = 1:size(nearest,2)
                if mod(i+nearest(1,count),2)==1 % is red
                    redIm(i,j) = redIm(i+nearest(1,count),j+nearest(2,count));
                    break;
                end
            end
        end
    end
end

%merge changes
mosim(:,:,1) = redIm;

%%%%%%%%%%%%%%%blue channel%%%%%%%%%%%%%%%%%%%%%

%blue into red
blueIm = mosim(:,:,3);
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [-1 -1 1 1; -1 1 -1 1];
        if i==imageHeight || j == imageWidth ||i==1||j==1
            nearest = getOKDiagNeighbors(i,j);
        end
        blueIm(i,j) = blueIm(i+nearest(1,1),j+nearest(2,1)); 
    end
end

%blue into green
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
            nearest = [-1 0 1 0;0 -1 0 1];
            if i==imageHeight || j == imageWidth ||i==1||j==1
            nearest = getOKNeighbors(i,j);
            end
            for count = 1:size(nearest,2)
                if mod(i+nearest(1,count),2)==0 % is blue
                    blueIm(i,j) = blueIm(i+nearest(1,count),j+nearest(2,count));
                    break;
                end
            end
        end
    end
end
mosim(:,:,3) = blueIm;

%%%%%%%%%%%%%%%%%%%%green channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%
greenIm = mosim(:,:,2);

%green into red
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==imageHeight||j==imageWidth||i==1||j==1
        nearest = getOKNeighbors(i,j);
        end
        greenIm(i,j) = greenIm(i+nearest(1,1),j+nearest(2,1));
    end
end

%green into blue
for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==imageHeight||j==imageWidth
        nearest = getOKNeighbors(i,j);
        end
        greenIm(i,j) = greenIm(i+nearest(1,1),j+nearest(2,1));
    end
end
mosim(:,:,2) = greenIm;

end
%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
mosim = repmat(im,[1 1 3]);
[imageHeight,imageWidth] = size(im);
function neighborArray = getOKNeighbors(i,j)
stepI = [-1 0 1 0];
stepJ = [0 -1 0 1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end


function neighborArray = getOKDiagNeighbors(i,j)
stepI = [-1 -1 1 1];
stepJ = [-1 1 -1 1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end

   
%%%%%%%%%%%red channel%%%%%%%%%%%%%%%%%%%%%%%%%
%red into blue
redIm = mosim(:,:,1);

for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [-1 -1 1 1; -1 1 -1 1];
        if i==imageHeight || j == imageWidth
            nearest = getOKDiagNeighbors(i,j);
        end
        neighborvals = [];
        for count = 1:size(nearest,2);
            neighborvals = [neighborvals, redIm(i+nearest(1,count),j+nearest(2,count))];
        end  
        redIm(i,j) = mean(neighborvals); 
    end
end
%red into green
nearest = [-1 0 1 0;0 -1 0 1];
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
            nearest = [-1 0 1 0;0 -1 0 1];
            if i==imageHeight || j == imageWidth ||i==1||j==1
                nearest = getOKNeighbors(i,j);
            end
            redvals =[];
            for count = 1:size(nearest,2)
                if mod(i+nearest(1,count),2)==1 %is red
                    redvals = [redvals, redIm(i+nearest(1,count),j+nearest(2,count))];
                end
            end
            redIm(i,j) = mean(redvals);
        end
    end
end



%merge changes
mosim(:,:,1) = redIm;

%%%%%%%%%%%%%%%blue channel%%%%%%%%%%%%%%%%%%%%%

%blue into red
blueIm = mosim(:,:,3);
nearest = [-1 -1 1 1; -1 1 -1 1];
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [-1 -1 1 1; -1 1 -1 1];
        if i==imageHeight || j == imageWidth ||i==1||j==1
            nearest = getOKDiagNeighbors(i,j);
        end
        neighborvals = [];
        for count = 1:size(nearest,2);
            neighborvals = [neighborvals, blueIm(i+nearest(1,count),j+nearest(2,count))];
        end  
        blueIm(i,j) = mean(neighborvals);  
    end
end

%blue into green
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
            nearest = [-1 0 1 0;0 -1 0 1];
            if i==imageHeight || j == imageWidth ||i==1||j==1
                nearest = getOKNeighbors(i,j);
            end
            bluevals =[];
            for count = 1:size(nearest,2)
                if mod(i+nearest(1,count),2)==0 %is blue
                    bluevals = [bluevals, blueIm(i+nearest(1,count),j+nearest(2,count))];
                end
            end
            blueIm(i,j) = mean(bluevals);
        end
    end
end
mosim(:,:,3) = blueIm;

%%%%%%%%%%%%%%%%%%%%green channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%
greenIm = mosim(:,:,2);

%green into red

for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==imageHeight || j == imageWidth ||i==1||j==1
            nearest = getOKNeighbors(i,j);
        end
        neighborvals = [];
        for count = 1:size(nearest,1);
            neighborvals = [neighborvals, greenIm(i+nearest(1,count),j+nearest(2,count))];
        end  
        greenIm(i,j) = mean(neighborvals);
    end
end

%green into blue

for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==imageHeight || j == imageWidth
            nearest = getOKNeighbors(i,j);
        end
        neighborvals = [];
        for count = 1:size(nearest,1);
            neighborvals = [neighborvals, greenIm(i+nearest(1,count),j+nearest(2,count))];
        end  
        greenIm(i,j) = mean(neighborvals);
    end
end
mosim(:,:,2) = greenIm;
end


%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
mosim = repmat(im,[1 1 3]);
[imageHeight,imageWidth] = size(im);
function neighborArray = getOKNeighbors(i,j)
stepI = [-1 0 1 0];
stepJ = [0 -1 0 1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end


function neighborArray = getOKDiagNeighbors(i,j)
stepI = [-1 -1 1 1];
stepJ = [-1 1 1 -1];
neighborArray = [];
for k = 1:4 
    if i+stepI(k) > 0 && i+stepI(k) <= imageHeight && j+stepJ(k) > 0 && j+stepJ(k) <= imageWidth
        neighborArray = [neighborArray, [stepI(k) stepJ(k)]'];
    end
end
end

    



%%%%%%%%%%%red channel%%%%%%%%%%%%%%%%%%%%%%%%%
%red into blue
redIm = mosim(:,:,1);
for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [ -1 -1 1 1; -1 1 1 -1];
        if i==1 || i==imageHeight || j==1 || j ==imageWidth
            nearest = getOKDiagNeighbors(i,j);
            neighborvals = [];
            for count = 1:size(nearest,2);
                neighborvals = [neighborvals, redIm(i+nearest(1,count),j+nearest(2,count))];
            end
            redIm(i,j) = mean(neighborvals);
        elseif abs(redIm(i+nearest(1,1),j+nearest(2,1))-redIm(i+nearest(1,3),j+nearest(2,3)))>abs(redIm(i+nearest(1,2),j+nearest(2,2))-redIm(i+nearest(1,4),j+nearest(2,4)))
            redIm(i,j)=(redIm(i+nearest(1,2),j+nearest(2,2))+redIm(i+nearest(1,4),j+nearest(2,4)))/2;
        else
            redIm(i,j)=(redIm(i+nearest(1,1),j+nearest(2,1))+redIm(i+nearest(1,3),j+nearest(2,3)))/2;
        end
    end
end
%red into green
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
            nearest = getOKNeighbors(i,j);
                redvals =[];
                for count = 1:size(nearest,2)
                    if mod(i+nearest(1,count),2)==1 %is red
                        redvals = [redvals, redIm(i+nearest(1,count),j+nearest(2,count))];
                    end
                end
            redIm(i,j) = mean(redvals);
        end
    end
end



%merge changes
mosim(:,:,1) = redIm;

%%%%%%%%%%%%%%%blue channel%%%%%%%%%%%%%%%%%%%%%

%blue into red
blueIm = mosim(:,:,3);
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [ -1 -1 1 1; -1 1 1 -1];
        if i==1 || i==imageHeight || j==1 || j ==imageWidth
            nearest = getOKDiagNeighbors(i,j);
            neighborvals = [];
            for count = 1:size(nearest,2);
                neighborvals = [neighborvals, blueIm(i+nearest(1,count),j+nearest(2,count))];
            end
            blueIm(i,j) = mean(neighborvals);
        elseif abs(blueIm(i+nearest(1,1),j+nearest(2,1))-blueIm(i+nearest(1,3),j+nearest(2,3)))>abs(blueIm(i+nearest(1,2),j+nearest(2,2))-redIm(i+nearest(1,4),j+nearest(2,4)))
            blueIm(i,j)=(blueIm(i+nearest(1,2),j+nearest(2,2))+blueIm(i+nearest(1,4),j+nearest(2,4)))/2;
        else
            blueIm(i,j)=(blueIm(i+nearest(1,1),j+nearest(2,1))+blueIm(i+nearest(1,3),j+nearest(2,3)))/2;
        end  
    end
end

%blue into green
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
for i = 1:imageHeight
    for j = 1:imageWidth
        if mask(i,j)>0
           nearest = getOKNeighbors(i,j);
                bluevals =[];
                for count = 1:size(nearest,2)
                    if mod(i+nearest(1,count),2)==0 %is blue
                        bluevals = [bluevals, blueIm(i+nearest(1,count),j+nearest(2,count))];
                    end
                end
            blueIm(i,j) = mean(bluevals);
        end
    end
end
mosim(:,:,3) = blueIm;

%%%%%%%%%%%%%%%%%%%%green channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%
greenIm = mosim(:,:,2);

%green into red
for i = 1:2:imageHeight
    for j = 1:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==1 || i==imageHeight || j==1 || j ==imageWidth
            nearest = getOKNeighbors(i,j);
            neighborvals = [];
            for count = 1:size(nearest,2);
                neighborvals = [neighborvals, greenIm(i+nearest(1,count),j+nearest(2,count))];
            end
            greenIm(i,j) = mean(neighborvals);
        elseif abs(greenIm(i+nearest(1,1),j+nearest(2,1))-greenIm(i+nearest(1,3),j+nearest(2,3)))>abs(greenIm(i+nearest(1,2),j+nearest(2,2))-greenIm(i+nearest(1,4),j+nearest(2,4)))
            greenIm(i,j)=(greenIm(i+nearest(1,2),j+nearest(2,2))+greenIm(i+nearest(1,4),j+nearest(2,4)))/2;
        else
            greenIm(i,j)=(greenIm(i+nearest(1,1),j+nearest(2,1))+greenIm(i+nearest(1,3),j+nearest(2,3)))/2;
        end  
    end
end
%green into blue
for i = 2:2:imageHeight
    for j = 2:2:imageWidth
        nearest = [-1 0 1 0;0 -1 0 1];
        if i==1 || i==imageHeight || j==1 || j ==imageWidth
            nearest = getOKNeighbors(i,j);
            neighborvals = [];
            for count = 1:size(nearest,2);
                neighborvals = [neighborvals, greenIm(i+nearest(1,count),j+nearest(2,count))];
            end
            greenIm(i,j) = mean(neighborvals);
        elseif abs(greenIm(i+nearest(1,1),j+nearest(2,1))-greenIm(i+nearest(1,3),j+nearest(2,3)))>abs(greenIm(i+nearest(1,2),j+nearest(2,2))-greenIm(i+nearest(1,4),j+nearest(2,4)))
            greenIm(i,j)=(greenIm(i+nearest(1,2),j+nearest(2,2))+greenIm(i+nearest(1,4),j+nearest(2,4)))/2;
        else
            greenIm(i,j)=(greenIm(i+nearest(1,1),j+nearest(2,1))+greenIm(i+nearest(1,3),j+nearest(2,3)))/2;
        end  
    end
end
mosim(:,:,2) = greenIm;
end
end