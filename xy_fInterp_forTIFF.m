function xy_fInterp_forTIFF(InterpN, fpath, fname, mvlength, outputPath, outputName)
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

im = double(imread([fpath, '/', fname], 'Index', 1));
[xdim, ydim] = size(im); % get the image size of this frame.
mvlengthS = num2str(mvlength);
%% take fourier transform of A, manually. don't use fast fourier transform.
% calculate base vectors:
Bx = zeros(1, 2*xdim); Bx(2) = 1; Bx = fft(Bx);
By = zeros(2*ydim, 1); By(2) = 1; By = fft(By);

% 1. calculate fourier transform matrix. (without center shift)
Fx = (ones(2*xdim, 1)*Bx).^([0:1:2*xdim-1]'*ones(1, 2*xdim));
Fy = (By*ones(1, 2*ydim)).^(ones(2*ydim, 1)*[0:1:2*ydim-1]);

for ord = InterpN
% 2. calculate inverse fourier transform matrix for given fold of interpolation. 
% (without center shift, with interpolation of given fold)
iFx = (ones((2*xdim-1)*ord + 1, 1)*conj(Bx)); iFxp = ([0:1/ord:2*xdim-1]'*ones(1, 2*xdim)); iFx = (iFx.^iFxp)./(2*xdim); 
iFy = (conj(By)*ones(1, (2*ydim-1)*ord + 1)); iFyp = (ones(2*ydim, 1)*[0:1/ord:2*ydim-1] ); iFy = (iFy.^iFyp)./(2*ydim); 

% determine the output file name
    if length(InterpN)>1
        of = ['Interp',num2str(ord),'_',outputName];
    else
        of = outputName;
    end
    for i0 = 1 : mvlength
        A = double(imread([fpath, '/', fname], 'Index', i0));
        % take fourier transform:
        FA = Fx*[A,fliplr(A);flipud(A),rot90(A,2)]*Fy;  
        % [A,fliplr(A);flipud(A),rot90(A,2)] is mirror-extension of the image A to create the natural
        % peoriocity in the resulting image to avoid ringing artifacts after fourier interpolation  

        % take the inverse fourier transform.
        iFA = abs(iFx*FA*iFy);
        
        % take the region corresponding to the FOV of image A
        iFA = iFA(1:(xdim-1)*ord + 1, 1:(ydim-1)*ord + 1);
        
        % export and write into the output TIFF file.
        iFA = uint16(iFA);
        imwrite(uint16(iFA),[outputPath,'/',of], 'WriteMode', 'Append');
        
        % display processing progress message.
        disp(['fourier interpolation (Zero-padding) of frame #',num2str(i0),'/',mvlengthS,', interpolation number: ',num2str(ord)])
    end
end
end
