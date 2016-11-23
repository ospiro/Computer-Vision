vidObj=VideoReader('MajisAquarium.mov');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
numFrame=5000;
movie = zeros(vidHeight,vidWidth,3,numFrame,'uint8');
while k<numFrame+1
    movie(:,:,:,k) = readFrame(vidObj);

    k = k+1;
end

% for k=1:numFrame
%    movie(:,:,:,k) = s(k).cdata; 
% end



% for i =1:numFrame
% image(movie(:,:,:,i));%im2uint8(movie(:,:,:,i)));
% pause(0.01);
% end