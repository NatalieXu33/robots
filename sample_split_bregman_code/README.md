README for mrics.m by Tom Goldstein (tagoldst@math.ucla.edu) 
This file contains methods for performing compressed sensing
recontructions of images from k-space data using the Split Bregman 
method.  This first file in this folder, "mrics.m" is a method for MRI Compressed Sensing.

The second file, "test_mrics.m," demonstrates how this code is properly used.

To use the mrics method, simply add this "m" file to your current directory, 
and then call the following method:
   
  u = mrics(R,F, mu, lambda, gamma, nInner, nOuter);
   
The inputs to this function are described below:
  
R - This is a matrix which determines which elements of K-Space
are known.  Take R(m,n)=0 if Fourier mode (m,n) is unknown,
and R(m,n)=1 is the corresponding mode is known.

F - This is the K-Space (Fourier) data.  In other words, F is the 
Fourier transform of the image you wish to recover.  If a
Fourier mode is known, then it should have a non-zero value.
If a Fourier mode is unknown, then simple set the corresponding
entry in this matrix to zero.  If you have set the values
in this matrix properly, then you should have (R.*F==F).
The method will automatically scale this data so that moderate
values of the function paramters (see below) will be
appropriate.

mu- The parameter on the fidelity term in the Split Bregman method.
The method automatically scales the input data so that extreme value
of this variable are not necessary.  For this reason, mu=1 should
work for many applications.

lambda - The coefficient of the constraint term in the Split Bregman
model.  Becuase of the way that the data is scaled, I suggest using
lambda=mu=1.

gamma - This is a regularization parameter.  I suggest that you take
gamma = mu/100.

nInner - This determines how many "inner" loops the Split Bregman method
performs (i.e. loop to enforce the constraint term).  I suggest
using nInner = 30 to be safe.  This will usually guarantee good
convergence, but will make things a bit slow.  You may find that you
can get away with nInner = 5-10

nOuter - The number of outer (fidelity term) Bregman Iterations.  This
parameter depends on how noisy your data is, but I find that
nOuter=5 is usually about right.

I STRONGLY suggest that you run the script "test_mrics.m" to test this method.  The code in this file will demonstrate how this code is properly used.

If you have difficulty getting the method to converge, or you get strange results, this is probably because you have bad values for the paramters.  I this is the case, I suggest that you try different values of mu (e.g. different order of magnitude) and take lambda=mu, and gamma = mu/100.