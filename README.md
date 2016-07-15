# SomaExtraction

Soma segmentation of 2D images through Directional Ratio and anisotropic Gaussian filters

Overview
--------
This package provides a fast implementation for soma detection and segmentation in 2D images. 
1) The segmented binary input is processed using directional anisotropic Gaussian filters and the Directional Ratio is computed (numer of orientations is set to 10 and filter length parameter is set to 9).
2) Candidate soma regions are detected by thresholding the Directional Ratio (threshold is set to 0.85). 
3) Since this process only detects the interior of soma regions, the Fast Marching method is used to evolve the detected region. 

An image containing segmented soma regions is given as output.   

More information can be found in the papers:
"Improved detection of soma location and morphology in fluorescence microscopy images of neurons", by C. Kayasandik and D. Labate.
 
The code for the computation of Anisotropic Gaussian filters is taken from the package by Jan-Mark Geusebroek. See:
J. M. Geusebroek, A. W. M. Smeulders, and J. van de Weijer. "Fast anisotropic gauss filtering". IEEE Trans. Image Processing,vol. 12, no. 8, pp. 938-943, 2003
The code for Fast Marching method is from the tollbox of Gabriel Payre (http://www.mathworks.com/matlabcentral/fileexchange/6110-toolbox-fast-marching).
Some of our m files are adapted from prior code by David Jimenez and Burcin Ozcan.

See contents.m for list of files in the package and information about them.

Installation
------------
Since "anigauss" and "fast marching" toolboxes contain mex files, first they need to be compiled. 
In order to compile anigauss type: 
mex -v -g anigauss_mex.c anigauss.c  
In order to compile fast marching toolbox type: 
mex mex/perform_front_propagation_2d.cpp mex/perform_front_propagation_2d_mex.cpp mex/fheap/fib.cpp
(or run compile_mex.m in folder "fast marching tollbox_reduced")

How to use
--------------
After compiling mex files run install_DR_Anigauss.m to add all necessary paths. 
This file will also open the main script: Script_Gaussian.m

Test data are available in data folder in tif format. In order to read those images tiffRead.m must be used. 
Script_Gaussian.m gives an example to sue the package using one file from the data folder. Other data may be processed by changing the name of the image.
 


Feedback
--------
If you have any questions, comments or suggestions feel free to contact 

   Cihan Bilge Kayasandik <ckayasandk@gmail.com>, Demetrio Labate <dlabate@math.uh.edu>
   University of Houston, Dept. of Mathematics
   

Legal Information & Credits
---------------------------
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


 
