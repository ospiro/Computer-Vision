function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object
[h,w,n] = size(surfaceNormals);
f_x = surfaceNormals(:,:,1)./surfaceNormals(:,:,3);
f_x(isnan(f_x))=0;
f_y = surfaceNormals(:,:,2)./surfaceNormals(:,:,3);
f_y(isnan(f_y))=0;
heightMap = zeros(h,w);
switch method
    case 'column'
        xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap = repmat(xsum(1,:),h,1);
        
        heightMap = heightMap+ysum;
        
%         for i =1:h
%             for j=1:w
%                 heightMap(i,j) = xsum(1,j) + ysum(i,j);
%             end
%         end
    case 'row'
         xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap = repmat(ysum(:,1),1,w);
        
        heightMap=heightMap+xsum;
        
%         for i =1:h
%             for j=1:w
%                 heightMap(i,j) = xsum(i,j) + ysum(i,1);
%             end
%         end
    case 'average'
         xsum = cumsum(f_x,2);
        ysum = cumsum(f_y,1);
        
        heightMap1 = repmat(xsum(1,:),h,1);
        
        heightMap1=heightMap1+ysum;
        
        heightMap2 = repmat(ysum(:,1),1,w);
        
        heightMap2=heightMap2+xsum;
        
%         for i =1:h
%             for j=1:w
%                 heightMap1(i,j) = xsum(1,j) + ysum(i,j);
%             end
%         end
%         for i =1:h
%             for j=1:w
%                 heightMap2(i,j) = xsum(1,j) + ysum(i,j);
%             end
%         end
        heightMap = (heightMap1+heightMap2)./2;
    case 'random'
%         rightvector=zeros(w)
%         i=1;
%         while( sum(rightvector)<w)
%             if(i==1)
%                 rightvector(i)=round(w*rand);
%             else
%                 rightvector(i) = round( (w-sum(rightvector(1:i-1)))*rand )
%             end
%             i = i+1
%         end
%         
%         downvector = zeros(h)
%         i=1;
%         while( sum(downvector)<h)
%             if(i==1)
%                 downvector(i)=round(h*rand);
%             else
%                 downvector(i) = round( (h-sum(downvector(1:i-1)))*rand )
%             end
%             i = i+1
%         end
            
        
        
        for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap1(i,j) = sum;
            end
        end
        
        %%%%
        for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap2(i,j) = sum;
            end
        end
%         
%         %%%%

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap3(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap4(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap5(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap6(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap7(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap8(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap9(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap10(i,j) = sum;
            end
        end
%         

for i =1:h
            for j =1:w
                rightAmount=1;
                downAmount=1;
                sum=f_x(1,1);
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
                heightMap11(i,j) = sum;
            end
        end
%         
        
        heightMap = (heightMap1+heightMap2+heightMap3+heightMap4+heightMap5+heightMap6+heightMap7+heightMap8+heightMap9+heightMap10+heightMap11)./11;
end

