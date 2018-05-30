%% predictive_variance_example.m

% From A First Course in Machine Learning, Chapter 2.

% Simon Rogers, 01/11/11 [simon.rogers@glasgow.ac.uk]

% Revised by Sayyed Mohsen Vazirizade, Oct/10/2017 [smvazirizade@email.arizona.edu]

% Predictive variance example

clc;clear all;close all;

rng(1);

%% Sample data from the true function

% $y = 5x^3-x^2+x$

N = 100; % Number of training points

x = sort(10*rand(N,1)-5);

t = 5*x.^3 - x.^2 + x;

noise_var = 300;

t = t + randn(size(x)).*sqrt(noise_var);



% Chop out some x data

pos = find(x>0 & x<2);

x(pos) = [];

t(pos) = [];



testx = [-5:0.1:5]';



%% Plot the data

figure(1);

hold off

plot(x,t,'k.','markersize',10);

xlabel('x');

ylabel('t');



%% Fit models of various orders

orders = [1:8];

for i = 1:length(orders)

    %%

    X = [];

    testX = [];

    for k = 0:orders(i)

        X = [X x.^k];

        testX = [testX testx.^k];

    end

    w = (X'*X)\X'*t;

    ss = (1/N)*(t'*t - t'*X*w);

    testmean = testX*w;

    testvar = ss * diag(testX/(X'*X)*testX');

    % Plot the data and predictions

    figure(1);

    hold off

    plot(x,t,'k.','markersize',10);

    xlabel('x');

    ylabel('t');

    hold on

    errorbar(testx,testmean,testvar,'r')

    ti = sprintf('Order %g',orders(i));

    title(ti);
    
    pause(3)

end





%% Plot sampled functions

orders = [1:8];

%path(path,'../utilities');

for i = 1:length(orders)

    %%

    X = [];

    testX = [];

    for k = 0:orders(i)

        X = [X x.^k];

        testX = [testX testx.^k];

    end

    w = (X'*X)\(X'*t);

    ss = (1/N)*(t'*t - t'*X*w);

    %% Sample functions by sampling realisations of w from a Gaussian with

    % $\mu = \hat{\mathbf{w}},~~\Sigma =

    % \sigma^2(\mathbf{X}^T\mathbf{X})^{-1}$

    covw = ss*inv(X'*X);

    wsamp = gausssamp1(w,covw,10);

    testmean = testX*wsamp';

    % Plot the data and functions

    figure(2);

    hold off

    plot(x,t,'k.','markersize',10);

    xlabel('x');

    ylabel('t');

    hold on

    plot(testx,testmean,'k','color',[0.6 0.6 0.6])

    xlim([-1 3])

    ti = sprintf('Order %g',orders(i));

    title(ti);
    
    pause(3)

end



function g = gausssamp1(w,sigma,N,sigmachol)
%creating random w based in sigma and w_mean


if ~exist('sigmachol')

    [sigmachol,p] = chol(sigma);

    sigmachol = sigmachol';

end

q = randn(length(w),N);

g = repmat(w,1,N)+ sigmachol*q;

g = g';
end