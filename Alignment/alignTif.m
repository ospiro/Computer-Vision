% Path to your data directory
dataDir = fullfile('..','data','tif');

% Path to your output directory (change this to your output directory)
outDir = fullfile('..', 'output', 'tif');
if ~exist(outDir, 'file')
    mkdir(outDir);
end

% List of images
imageNames = {'lady.tif'};

% Display variable
display = true;

% Set maximum shift to check alignment for
maxShift = [150 150];

% Loop over images, untile them into images, align
for i = 1:length(imageNames),
    
    % Read image
    im = imread(fullfile(dataDir, imageNames{i}));
    
    % Convert to double
    im = im2double(im);
    
    % Images are stacked vertically
    % From top to bottom are B, G, R channels (and not RGB)
    imageHeight = floor(size(im,1)/3);
    imageWidth  = size(im,2);
    
    % Allocate memory for the image 
    channels = zeros(imageHeight, imageWidth, 3);
    
    % We are loading the color channels from top to bottom
    % Note the ordering of indices
    channels(:,:,3) = im(1:imageHeight,:);
    channels(:,:,2) = im(imageHeight+1:2*imageHeight,:);
    channels(:,:,1) = im(2*imageHeight+1:3*imageHeight,:);

    % Align the blue and red channels to the green channel
    
    %%%%%%%Coarse to fine%%%%%%%%
    
    smallIm = imresize(channels,0.2);
    [colorIm, predShift] = alignChannels(smallIm, round(maxShift/5));
    predShift = predShift*5;
    colorIm = channels;
    colorIm(:,:,2) = circshift(channels(:,:,2), [predShift(1,1) predShift(1,2)]);
    colorIm(:,:,3) = circshift(channels(:,:,3), [predShift(2,1) predShift(2,2)]);
    [colorIm, predShift2] = alignProkChannels(colorIm, [1 1]);
    predShift = predShift+predShift2;
    
    % Print the alignments
    fprintf('%2i %s shift: B (%2i,%2i) R (%2i,%2i)\n', i, imageNames{i}, predShift(1,:), predShift(2,:));
    
    % Write image output
    outimageName = sprintf([imageNames{i}(1:end-5) '-aligned.jpg']);
    outimageName = fullfile(outDir, outimageName);
    imwrite(colorIm, outimageName);
   
    % Optionally display the results
    if display
        figure(1); clf;
        subplot(1,2,1); imagesc(im); axis image off; colormap gray
        title('Input image');
        subplot(1,2,2); imagesc(colorIm); axis image off;
        title('Aligned image');
        pause(1);
    end
end
toc;

