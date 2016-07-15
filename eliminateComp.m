
function compImage = eliminateComp(image,THR)
% This function should eliminate components of the segmentation with a
% size small enough to be considered not relevant for the processing.
%
% INPUT:
%  - image: 2D image, resulting from the segmentation
%           (Filledsegmentedimage).
%  - THR: This threshold specifies the minimum cardinality of a component
%         to be processed.
%
% OUTPUT:
%  - compImage: 2D image with the smaller components removed.
% 

S = connComp(image);
k = find(S.compCard < THR,1);
k = k-1;
J = cat(1,S.compIdx{1:k});
compImage = zeros(size(image));
compImage(J) = 1;

end
