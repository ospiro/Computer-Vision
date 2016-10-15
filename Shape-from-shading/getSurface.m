function  heightMap = getSurface(surfaceNormals, method)
[h,w,n] = size(surfaceNormals);
f_x = surfaceNormals(:,:,1)./surfaceNormals(:,:,3);
f_x(isnan(f_x))=0;
f_y = surfaceNormals(:,:,2)./surfaceNormals(:,:,3);
f_y(isnan(f_y))=0;
heightMap = zeros(h,w);


%For use in the random paths method
%Random walk to (i,j), summing over corresponding partial
%as it goes
function  map = randHeightMap()
        map = zeros(h,w);
        for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_y(1,1);
                while(rightAmount < j || downAmount < i)
                    r = rand;
                    if(r<0.5 && rightAmount <j)
                        rightAmount = rightAmount + 1;
                        sum = sum+f_x(downAmount,rightAmount);
                    elseif(r>=0.5 && downAmount <i)
                        downAmount = downAmount + 1;
                        sum = sum+f_y(downAmount,rightAmount);
                    end
                end
                map(i,j) = sum;
            end
        end
end

switch method
    case 'column'
         xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap = repmat(ysum(:,1),1,w);
        
        heightMap=heightMap+xsum;
        
    case 'row'
        
         xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap = repmat(xsum(1,:),h,1);
        
        heightMap = heightMap+ysum;
        
    case 'average'
         xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap1 = repmat(xsum(1,:),h,1);
        
        heightMap1=heightMap1+ysum;
        
        heightMap2 = repmat(ysum(:,1),1,w);
        
        heightMap2=heightMap2+xsum;

        heightMap = (heightMap1+heightMap2)./2;
    case 'random'
       
       heightMap = zeros(h,w);
       for i = 1:30
           heightMap = heightMap+randHeightMap(); % see above for randHeightMap function
       end
       heightMap = heightMap./30;

end

end

