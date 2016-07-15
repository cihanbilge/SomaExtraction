% Copyright � 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

function S = connComp(B)
% This function takes a binary solid and returns struct containing indices
% of the components, as well as other fields.
% 
% INPUT:
%  - B: Binary Solid.
% 
% OUTPUT:
%  - S: Struct containing different pieces of information.
%     * solSize: The size of B.
%     * compNum: Number of Connected Components.
%     * compCard: Array with the cardinality of each component.
%     * compCoord: Cell with array of coordinates of each component of B.
%     * compIdx: Cell with array of indices of each component of B.
%     * coordMin: Minimum on each coordinate of the 
%

CC = bwconncomp(B,8);
numPixels = cellfun(@numel,CC.PixelIdxList);
[V I] = sort(numPixels,'descend');
S = struct();
S.solDim = length(CC.ImageSize);
S.solSize = CC.ImageSize;
S.compNum = CC.NumObjects;
S.compCard = V';
S.compIdx = cell(S.compNum,1);
S.compCoord = cell(S.compNum,1);
R = cell(S.solDim,1);
S.coordMin = NaN(S.solDim,S.compNum);
S.coordMax = NaN(S.solDim,S.compNum);

for k = 1:S.compNum
    S.compIdx{k} = CC.PixelIdxList{I(k)};
    [R{1:S.solDim}] = ind2sub(S.solSize,S.compIdx{k});
    S.compCoord{k} = [R{1:S.solDim}].';
    S.coordMin(:,k) = cellfun(@min,R);
    S.coordMax(:,k) = cellfun(@max,R);
end

end


% CREATED: 
% - Date: 09/06/2012
% - By: David Jimenez.
% 
