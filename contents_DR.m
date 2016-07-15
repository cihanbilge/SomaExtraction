% Soma Segmentation via Anisotropic Gaussian Filters m-files
%
%--------------------------------------------------------------------------
% Cihan Bilge Kayasandik last edited: 2016-07-13


% /anigauss/
%   Collection of files to filter input with rotated anisotropic Gaussian filters.
%   This package is from Jan-Mark Geusebroek.
%   *to compile mex files type: mex -v -g anigauss_mex.c anigauss.c from matlab
% /data/
%   contains 20 2D images with their segmentation to test the algorithm.
% /fast marching tollbox/
%   Files to apply Fast Marching method to input.
%   This package is prepared by Gabriel Peyre
%   *to compile mex files type: mex mex/perform_front_propagation_2d.cpp mex/perform_front_propagation_2d_mex.cpp mex/fheap/fib.cpp
%   in matlab or run compile_mex.m file. This package is reduced only to
%   necessary files for this project. The complete package can be found
%   online.
% connComp.m
%   It takes a binary solid and returns struct containing indices
%   of the components
% dirRatio_Gaussian.m
%   It takes a binary solid and returns the Directional Ratio values for each 
%   pixel with respect using images filters with anisotropic Gaussian filters. 
%   This file calls Main_Anigauss_2d.m
% fastMarching.m 
%   It applies 2D Fast Marching method to input.
% freezeColors. Utility to lock colors of plot, enabling multiple colormaps
% per figure. Due to freezeColors  Lock colors of plot, enabling multiple
% colormaps per figure. Due to John Iversen.
% Script_Gaussian.m
%   Script showing an example of soma detection and extraction 
% Main_Anigauss_2d.m
%   Main function calls all necessary functions to segment soma regions in 
%   2D image.
% SomaDivision.m
%   File to separate contiguous somas, if there needed. 
% tiffRead.m
%   It reads tif files.


