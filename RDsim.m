clear
clf

%*************************************************************************
%*** (1) Parameters
%*************************************************************************
N = 10000;
%beta = [10, 0.25, 0.4, 3, 3];
beta = [10, 5, 2, 20, 3];

%*************************************************************************
%*** (2) Simulate
%*************************************************************************
running_var = linspace(0,100,N)';

leftside = running_var<=50;
rightside = abs(1-leftside);

victory = NaN(N,1);
victory=running_var>50;

y = beta(1) + beta(2)*running_var.*leftside + beta(3)...
    *running_var.*rightside + beta(4)*victory + beta(5)*randn(N,1); 
 
yhat = beta(1) + beta(2)*running_var.*leftside + beta(3)...
       *running_var.*rightside + beta(4)*victory;

scatter(running_var, y)
hold on
plot(running_var, yhat,'r', 'linewidth', 2)
xlabel('Running Variable', 'FontSize', 14)
ylabel('Outcome', 'FontSize', 14)
title('Simulated Regression Discontinuity', 'FontSize', 16)
hold off

data = [y, running_var, victory];

%results = NaN(100,3);
%cons=ones(N,1);

%for i=1:100
%    leftside = running_var<=i;
%    rightside = abs(1-leftside);
%    victory=running_var>i;

%    lrv=leftside.*running_var;
%    rrv=rightside.*running_var;
%    X=[cons, lrv, rrv, victory];
%    [B, CI]=regress(y,X);
%    results(i,1)=B(4);
%    results(i,2:3)=CI(4,:);
%end