Epsilon = 20;

% mn = min(min(min(min(movie))));
% mx = max(max(max(max(movie))));
% copymovie=movie;
% movie = uint8(floor(  (movie-mn)*255./(mx-mn) ));

background = uint8(mean(movie(:,:,:,1:1000),4));
% frames = movie(:,:,:,I);





for i =1:1000
    mask = (movie(:,:,:,i)-background)>Epsilon;
    onefish = findcomponent(mask);
    twofish=[255*onefish movie(:,:,:,i) background];
    image(twofish);
    pause(0.000001);
end


function fish = findcomponent(im)
    imageHeight = size(im,1);
    imageWidth = size(im,2);
    
    fish = zeros(size(im));
    for i = 4:imageHeight-3
        for j = 4:imageWidth-3
            patch = im(i-3:i+3,j-3:j+3,:);
            if sum(sum(sum(patch)))>69 %TODO:see if there is an objective way to choose this value
                fish(i,j,:)=1;
            end
        end
    end
end