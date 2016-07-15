% Copyright © 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

function stack = tiffRead(fname,type)
% This function takes 
% 
% INPUT:
%  - name: String with the name of the file to load
%  - type: Cell containing the type of stacks to output.
%      * BLU: Blue Stack.
%      * RED: Red Stack.
%      * GRN: Green Stack.
% 
% OUTPUT:
%  - stacks: Struct with all the stacks necessary.
%

stack = struct();
info = imfinfo(fname);
N = numel(info);
S = cell(N,1);
for k = 1:N
    S{k} = imread(fname, k);
end

K = numel(type);

for k = 1:K
    option = type{k};
    switch option
        case 'BLU'
            I = 3:3:N;
            stack.BLU = cat(3,S{I});
        case 'RED'
            I = 2:3:N;
            stack.RED = cat(3,S{I});
        case 'GRN'
            I = 1:3:N;
            stack.GRN = cat(3,S{I});
        case 'MONO'
            stack.MONO = cat(3,S{:});
        case 'RGBm'
            SS = cell(N/3,1);
            for n = 1:(N/3)
                SS{n} = max(cat(3,S{3*n-2}, S{3*n-1},S{3*n}),[],3);
            end
            stack.RGBm = cat(3,SS{:});
        case 'RGBs'
            SS = cell(N/3,1);
            for n = 1:(N/3)
                SS{n} = S{3*n-2} + S{3*n-1} + S{3*n};
            end
            stack.RGBs = cat(3,SS{:});
        case 'RBm'
            SS = cell(N/3,1);
            for n = 1:(N/3)
                SS{n} = max(cat(3,S{3*n-1},S{3*n}),[],3);
            end
            stack.RBm = cat(3,SS{:});
        case 'RBs'
            SS = cell(N/3,1);
            for n = 1:(N/3)
                SS{n} = S{3*n-1} + S{3*n};
            end
            stack.RBs = cat(3,SS{:});
    end
end


end


% CREATED: 
% - Date: 10/01/2012
% - By: David Jimenez.
% 

% MODIFIED:
% - Date: 10/20/2012
% - By: David Jimenez
% - Changes: Multioption.