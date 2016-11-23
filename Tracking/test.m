vidObj=VideoReader('Clownfishes_in_Anemone.mp4');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
while k<501
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end

im = s(1).cdata;
imC = im(339:474,905:1225,:);
imC = imC(1:20,1:20,:);
% for i =1:100
% image(s(i).cdata);
% pause(0.1);
% end