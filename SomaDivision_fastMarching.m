function dividedSomas = SomaDivision_fastMarching(segmentedImage,soma,k, FSIZEx)
% This function returns the first cut of the soma detection. It normally
% returns regions that are contained inside a soma, but are not necessarily
% the entire soma region. It also eliminates false soma parts, and fills
% possible holes left in those regions.
%
% INPUT:
% - segmentedImage: The segmented version of the image
% - soma : cell contaiing the soma indices
% - k : (count+1) of contiguous somas if number of cont. soma is 1 then
%       k=2;(I think that k must be equal to number of contiguous somas)
% - FSIZEx: filter length
% OUPUT:
%  - dividedSomas: cell of soma regions.
%

% mean to find the single soma size
if (k~=0)
    v=zeros(1, length(soma));
    for i=1:length(soma)
        v(1,i) = length(soma{i});
    end
    v= sort(v,'descend');
    
    nSoma = v(1, k+1:end);
    
    meanS = mean(nSoma);
    stdS = std(nSoma);
    
    threshold = meanS + 3*stdS;
    %threshold=10;
    sz = numel(soma);
    idx =zeros(1,sz);
    
    for i = 1: sz
        if numel(soma{i}) >= threshold
            idx(1,i) = i;
        end
    end
    
    nzidx = find(idx ~= 0);
    
    somaImage = zeros(size(segmentedImage));
    
    for i=1: length(nzidx)
        
        somaImage(soma{nzidx(i)})=1;
    end
    [~, dR, drA]=dirRatio_Gaussian(double(somaImage),double(somaImage),double(FSIZEx), double(ceil(FSIZEx/10)),10, .85,0);
    
    
    mask = zeros(size(segmentedImage));
    maskIdx = find(dR>0.89);
    mask(maskIdx)=1;
    
    %to eliminate the single soma regions
    IdxSoma = find(somaImage==1);
    [C,is] = intersect(IdxSoma, maskIdx);
    
    mask = zeros(size(segmentedImage));
    mask(IdxSoma(is)) = 1;
    
    % eliminate the parts which are not likely to be soma part ie if the
    % card of  that component less than some threshold eliminating it.
    THR4 = 50;
    CC1 = connComp(mask);
    RemainComp = cat(1, CC1.compIdx{CC1.compCard > THR4});
    firstSomaParts = zeros(size(segmentedImage));
    firstSomaParts(RemainComp) = 1;
    CC = connComp(firstSomaParts);

    result = cell(1,length(CC.compNum));

    phim=2*dR;
    CC = connComp(firstSomaParts);
    for i = 1:CC.compNum
        phi = ones(size(segmentedImage));
        phi(CC.compIdx{i}) = -1;
        sizem=[size(image)];
        %define end points as the background in the segmentation
        end_pointss= find(segmentedImage==0);
        [K, L]=ind2sub(sizem,end_pointss);
        end_points=[K'; L'];
        %options.end_points=end_points;%use this one if you want
        %evolving to stop when it reaches the end_points, In that case
        %you need to change options.nb_iter_max to options.end_points
        %in the main file.
        
        %start points are boundary of detected somas
        start_pointss= find(edge(phi==-1,'canny'));
        [I,J] = ind2sub(sizem,start_pointss);
        start_points=[I';J'];
        %Y=[];
        %p1=1;
        nb_iter_max=ceil(numel(start_pointss));
        options.nb_iter_max = nb_iter_max;
        %options.end_points = end_points;
        [~,S] = perform_fast_marching(phim,somaImage, start_points,end_points,nb_iter_max, options);
        
        %intersection = intersect(find(S<=0), end_pointss);
        p =.50; % p is the percentage of increase in contour
        while(p >0.0001)
            
            if(nb_iter_max == 1*ceil(numel(start_pointss)))
                
                [~,S] = perform_fast_marching(phim,somaImage, start_points,end_points,nb_iter_max, options);
                
            end
            
            somaIndFirst = find((S<=0));
            
            intersectionFirst = intersect(somaIndFirst, find(somaImage == 1));
            
            nb_iter_max = nb_iter_max +5*ceil(numel(start_pointss));
            
            [~,S] = perform_fast_marching(phim,somaImage, start_points,end_points,nb_iter_max, options);
            
            somaIndSecond = find((S<=0));
            
            intersectionSecond = intersect(somaIndSecond, find(somaImage == 1));
            length(intersectionSecond);
            
            ContourDifference = setdiff(intersectionSecond, intersectionFirst);
            
            p2 = length(ContourDifference)/length(intersectionFirst);
            
            p=abs(p2-p1);
            
            p1=p2;

        end
        
        somaIndSecond = find(S<=0);
        intersectionSecond = intersect(somaIndSecond, find(segmentedImage == 1));
        
        S=intersectionSecond;
        
        mask = zeros(512,512);
        mask(S) =1;
        mask(find(phi==-1))=1;
        CCmask = connComp(mask);
        result{i} = CCmask.compIdx{1};
    end
    %soma=result;
    dividedSomas = cell(1,CC.compNum + length(soma) - length(nzidx));
    for i=1:CC.compNum
        dividedSomas{1,i} = result{1,i};
    end
    for i=CC.compNum+1 : CC.compNum + length(soma) - length(nzidx)
        dividedSomas{1,i} = soma{1,i+length(nzidx) - CC.compNum};
    end
    
else
    dividedSomas=soma;
end
end

% created by Burcin Ozcan - 8 December 2014
% modified by Cihan Bilge Kayasandik - 13 July 2016