% detects soma regions by using directional ratio.
function [firstSomaParts,dirRatio, dirRatio_alternative,nSomas,m]=dirRatio_Gaussian(segmentedImage,filterx, filtery, nBands, th,k)
sz=size(segmentedImage);
filtIm=zeros(sz(1),sz(2),(nBands));
segmentedImage=double(segmentedImage);
sx=double(filterx);
sy=double(filtery);
for i=1:nBands
    filtIm(:,:,i)=anigauss_mex(segmentedImage,sx,sy,double(180*i/nBands),0,0);
end

maxF = max(filtIm,[],3);
minF=min(filtIm,[],3);

dirRatio= (minF)./maxF;

firstSomaParts=zeros(size(segmentedImage));
firstSomaParts(dirRatio>=th)=1;
dirRatio_alternative = (minF.^3)./maxF;



THR4=250;
CC1 = connComp(firstSomaParts); 
RemainComp1 = cat(1, CC1.compIdx{CC1.compCard > THR4});
firstSomaParts1 = zeros(size(segmentedImage));
firstSomaParts1(RemainComp1) = 1;
firstSomaParts=firstSomaParts1;

CC3 = connComp(firstSomaParts); nSomas=CC3.compNum;

if (filterx==double(9))
    %as=2821;
    as=1961;
else
    %as=3901;
    as=3853;
end

a=length(find(firstSomaParts>0));
b=as*2/3*CC3.compNum;
m=(a >=b);
if (m==1 && k==1)
    
    numel(a);
    sx=double(6/4*filterx);
    sy=double(6/4*filtery);
    for i=1:nBands
        filtIm(:,:,i)=anigauss_mex(segmentedImage,sx,sy,double(180*i/nBands),0,0);
    end

    maxF = max(filtIm,[],3);
    minF=min(filtIm,[],3);

    dirRatio = (minF)./maxF;
    dirRatio=dirRatio.*segmentedImage;
    firstSomaParts=zeros(size(segmentedImage));
    firstSomaParts(dirRatio>=th)=1;
    THR4=250;
    CC1 = connComp(firstSomaParts); 
    RemainComp1 = cat(1, CC1.compIdx{CC1.compCard > THR4});
    firstSomaParts = zeros(size(segmentedImage));
    firstSomaParts(RemainComp1) = 1;
    CC4 = connComp(firstSomaParts); nSomas=CC4.compNum;
end
if (k==1)
    dirRatio=dirRatio.*segmentedImage;
    dirRatio_alternative=dirRatio_alternative.*segmentedImage;
end
end


% CREATED: 
% - Date: 2016-07-13
% - By: Cihan Bilge Kayasandik.
% 

