clear all; clc;

stepsize = 0.1;
maxlambda1 = 100;
maxlambda2 = maxlambda1;

n = 30;
m = 100;
sparsity = 10;

[A u b] = generateData( n, m, sparsity );
Phi = @(x) x;

N1 = maxlambda1/stepsize;
N2 = maxlambda2/stepsize;

uguess = zeros(n, N1, N2);
udist = zeros(N1, N2);

for i=1:N1
    for j=1:N2
        lambda1 = stepsize*i;
        lambda2 = stepsize*j;
        H = @(x) (step*lambda1/2)*norm(A*x-b)^2;
        solver = directSolve1( A, b, lambda1, lambda2 );
        uguess( :, i, j ) = genSplitBregman( n, Phi, H, solver, lambda2 );
        udist(i,j) = norm(u-uguess(:, i, j));
    end
end

xaxis = stepsize:stepsize:maxlambda1;
yaxis = stepsize:stepsize:maxlambda2;

hold on

h = surfc( xaxis, yaxis, udist );
title('lambda test')
xlabel('lambda1');
ylabel('lambda2');
zlabel('err');

hold off

save lambdatest;