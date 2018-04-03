# xy_fInterp_forTIFF.m
xy_fInterp_forTIFF is a MATLAB function that performs Fourier interpolation of each frame from the input TIFF file,
and produce an output TIFF file consists of the interpolated frames from the input.

Mirror extension of each frame was performed prior to Fourier interpolation to avoid ringing artifacts. Fourier interpolation was implemented with transformation matrix operation, where the Fourier transformation matrix was constructed with the original matrix size without interpolation grids, and the inverse Fourier transform matrix encodes the extra interpolation position coordinates. This way we create a mathematical equivalence of zero-padding Fourier interpolation, but avoid actual zero-padding of the matrix before inverse Fourier transform in order to reduce the physical memory occupation for the operation.

The resulting TIFF file can be applied for SOFI processing to produce fSOFI results.

---
#### Demo.m provides an example of how to use the function.

If you find this function useful, here is how you can cite it:
https://doi.org/10.6084/m9.figshare.5830323.v1
### figshare page: https://figshare.com/articles/Fourier_interpolation_of_TIFF_stack/5830323/1
