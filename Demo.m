% Fourier Interpolation demo code.

InterpN = [2,3]; % produce 2 series of interpolation, one of 2 fold, one of 3 fold.
fpath = '.';% input file path;
fname = 'demo.tif';% input file name
mvlength = 20; % input TIFF movie length.
outputPath = '.'; % output path
outputName = 'InterpDemo.tif'; % output file name
xy_fInterp_forTIFF(InterpN, fpath, fname, mvlength, outputPath, outputName)

% specifics of function xy_fInterp_forTIFF
%% This code performs fourier interpolation of each frame from the input TIFF file,
% and produce an output TIFF file consists of the interpolated frames from the input.
% Author: Xiyu Yi @ UCLA
% Email: chinahelenyxy@gmail.com
%% 
% Mirror extension of each frame was performed prior to Fourier interpolation to 
% avoid ringing artifacts. Fourier interpolation was implemented with transformation 
% matrix operation, where the Fourier transformation matrix was constructed with the original 
% matrix size without interpolation grids, and the inverse Fourier transformation matrix 
% encodes the extra interpolation position coordinates. 
% This way we create a mathematical equivalence of zero-padding fourier interpolation, 
% but avoid actual zero-padding in the Fourier space in order to reduce the physical 
% memory occupation for the operation.
%
% The resulting TIFF file can be applied for SOFI processing to produce fSOFI results.
%
% InterpN:  
%     [integer], or an array of integers. 
%     InterpN describes the number of pixels to be interpolated between two 
%     adjacent pixels. when InterpN is an array, a list of output movies will be produced
%     with each one given the result corresponding to each element of
%     InterpN.
%
%     Note here that interpolation doesn' extend over the edgeo f the 
%     matrix, therefore the total number of pixels in the resulting matrix is 
%     not an integer fold of the original size of the matrix. For example, if 
%     the original matrix size of each frame is xdim and ydim for x and y 
%     dimensions respectively. After interpolation, the size of the resulting 
%     matrix will be ((xdim-1)*f + 1) for x dimension, and ((ydim-1)*f + 1) 
%     for y dimension.
%
% fpath:
%     [string] the directory of the input file .
% fname:
%     [string] file name of the input file. It has to be a TIFF movie.
% mvlength
%     [integer number] total number of frames of the input TIFF movie.
% outputPath
%     [string] path of the output file.
% outputName
%     [string] name of the output file. with .tif file extension.