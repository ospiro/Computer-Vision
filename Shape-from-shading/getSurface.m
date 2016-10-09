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
f_x = surfaceNormals(:,:,1)/surfaceNormals(:,:,3);
f_y = surfaceNormals(:,:,2)/surfaceNormals(:,:,3);
heightMap = zeros(h,w);
switch method
    case 'column'
        heightMap = cumsum(f_x,1)+cumsum(f_y,2);
    case 'row'
        heightMap = cumsum(f_x,1)+cumsum(f_y,2);
        %%% implement this %%%
    case 'average'
        heightMap = cumsum(f_x,1)+cumsum(f_y,2);
        %%% implement this %%%
    case 'random'
        heightMap = cumsum(f_x,1)+cumsum(f_y,2);
        %%% implement this %%%
end

