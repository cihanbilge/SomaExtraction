
function [segm, filledSegmentedImage1,filledSegmentedImage2] = segmentImage(image,indices,model,THR,THR3)
% This function returns the predicted labels and probabilities for the
% image to be analyzed.
%
% INPUT:
% - image: It is the projected and denoised version of the image to be
%          analyzed.i.e.2D image. It may be a 2D matrix of any size.
% - indices: This is the set of indices for which the features will be
%            generated.
% - model: variable containing the SVM classifier and its specifications.
% _ THR: Threshold for initial soma detection. To fill the possible gaps
%         in the image(espacially here to fill in soma)
% - THR3 : to eliminate components for further fill gaps.
% OUTPUT:
% - segmentedImage: this is the 2D segmentation of the given image.

[feats,M,~] = gen2DFeats(image,indices,model);

N = numel(indices);
mini = repmat(M(2,:),N,1);
maxi = repmat(M(1,:),N,1);
feats = (feats-mini)./(maxi-mini);

%tic;
[labl,~,~] = svmpredict(double(indices), double(feats), model.svm, '-b 1');
%toc;

segm = image*0;
segm(indices) = (labl+1)/2;

compImage = eliminateComp(segm,THR3);


%Filling holes left inside cell body by first segmentation.
medianFilter = ones(4)/16;
convolvedSegm = convn(compImage,medianFilter,'same');
T= uint8((convolvedSegm>THR) & (convolvedSegm<1)&(compImage<1));
tempSegmentedImage = uint8(T | compImage);
filledSegmentedImage1 = uint8(tempSegmentedImage | segm);
%SegmentedImage =segm;
medianFilter = ones(6)/36;
convolvedSegm = convn(compImage,medianFilter,'same');
T= uint8((convolvedSegm>THR) & (convolvedSegm<1)&(compImage<1));
tempSegmentedImage = uint8(T | compImage);
filledSegmentedImage2 = uint8(tempSegmentedImage | segm);

end
