%fast marching method
function [mask, soma]=fastMarching(detectedSoma,segmentation, filled_segmentation,filtersize, m,THR)
%main file to segment soma regions
% INPUT: 
%   -detectedSoma: core soma regions that need to evolve.
%   -segmentation: segmented Image
%   -filled_segmentation: median filtered version of segmentation.
%   -filtersize: length of filter.
%   -m: input to modify filter length according to areas to evolve. 
%       m=1: area to evolve is large so larger filter length is necessary.
%       m=0: area to evolve is small so shorter filter length is necessary.
%   THR: threshold value
% OUTPUTS:
%   -mask: final image with segmented soma regions.
%   -soma: cell containing indices of segmented soma regions.

% it takes the boundary of the detected soma regions as starting point of
% evolution. Creates the velocity map of fast marhing according to
% directional ratio values of each pixel. 
CC = connComp(detectedSoma);
result=cell(CC.compNum,1);
sizem=size(segmentation);
if (m==1)
    fnewsize=1.8*filtersize;
else
    fnewsize=.8*filtersize;
end
%fast marching
segm = 2.*filled_segmentation;
segm(filled_segmentation == 0) =1;
[~, ~, dirRatio_alternative]=dirRatio_Gaussian(double(segm),double(fnewsize), ceil(fnewsize/10),10, .85,0);
map=dirRatio_alternative./20;
for i = 1:CC.compNum
    phi = ones(size(segmentation));
    phi(CC.compIdx{i}) = -1;
    %define end points as the background in the segmentation
    end_pointss= find(filled_segmentation==0);
    [K, L]=ind2sub(sizem,end_pointss);
    end_points=[K'; L'];
    
    %start points are boundary of detected somas
    start_pointss= find(edge(phi==-1,'canny'));
    [I,J] = ind2sub(sizem,start_pointss);
    start_points=[I';J'];
    Y=[];
    p1=1;
    nb_iter_max=10000*ceil(numel(start_pointss)); %max iteration number depend on detected area
    %nb_iter_max=Inf;
    options.nb_iter_max = nb_iter_max;
    %options.end_points=end_points;%use this one if you want
    %the evolving stop when it reaches the end_points, In that case
    %you need to change options.nb_iter_max to options.end_points
    %in the main file.
    [~,S] = perform_fast_marching(map,segmentation, start_points,end_points,nb_iter_max, options);
    S(phi==-1)=-1;
    
    p2 =.50; % p is the percentage of increase in contour
    %o=1;
    while(p2 >0.00001)
        start_pointss= find(edge(S==-1,'canny'));
        [I,J] = ind2sub(sizem,start_pointss);
        start_points=[I';J'];
        somaIndFirst = find((S<=0));
        intersectionFirst = intersect(somaIndFirst, find(map ~= 0));
        nb_iter_max = 100*nb_iter_max +10*ceil(numel(start_pointss));
        [~,Si] = perform_fast_marching(map,segmentation, start_points,end_points,nb_iter_max, options);
        Si(S==-1)=-1;
        S=Si;
        somaIndSecond = find((S<=0));
        intersectionSecond = intersect(somaIndSecond, find(map ~= 0));
        length(intersectionSecond);
        ContourDifference = setdiff(intersectionSecond, intersectionFirst);
        p2 = length(ContourDifference)/length(intersectionFirst);
    end
    
    somaIndSecond = find(S<=0);
    intersectionSecond = intersect(somaIndSecond, find(map ~= 0));
    
    S=intersectionSecond;
    
    mask = zeros(sizem);
    mask(S) =1;
    
    CCmask = connComp(mask);
    result{i} = find(mask);
end
soma=result;

mask= zeros(sizem);

for i=1:CC.compNum mask(soma{i})=1; end
mask(find(detectedSoma))=1;
mask=medfilt2(mask,[THR THR]);
THR4=500;
CC1 = connComp(mask);
RemainComp1 = cat(1, CC1.compIdx{CC1.compCard > THR4});
mask1 = zeros(size(detectedSoma));
mask1(RemainComp1) = 1;
mask=mask1;
end

% CREATED: 
% - Date: 2016-07-13
% - By: Cihan Bilge Kayasandik.
% 


