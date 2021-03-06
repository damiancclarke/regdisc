function [beta, CI] = rd(Y, RunVar, cutoff, poly)
% rd is a regression discontinuity function that takes as arguments the
% outcome variable Y, a vector of the running variable (all
% possible values that X can take), and the cutoff point (a scalar).
% 
% We still have to let people define the trend (linear, quadratic, etc).
%
% See also regress

  cons = ones(size(RunVar));
  left = RunVar<=cutoff;
  right = RunVar>cutoff;

	if poly==1	
	  lt = left.*RunVar;
	  rt = right.*RunVar;
	elseif poly==2
	  lt = [left.*RunVar, left.*RunVar.^2];
	  rt = [right.*RunVar, right.*RunVar.^2];
	elseif poly==3
	  lt = [left.*RunVar, left.*RunVar.^2, left.*RunVar.^3];
	  rt = [right.*RunVar, right.*RunVar.^2, right.*RunVar.^3];
	elseif poly==4
	  lt = [left.*RunVar, left.*RunVar.^2, left.*RunVar.^3, ...
				left.*RunVar.^4];
	  rt = [right.*RunVar, right.*RunVar.^2, right.*RunVar.^3, ...
			 right.*RunVar.^4];
	elseif poly==5
	  lt = [left.*RunVar, left.*RunVar.^2, left.*RunVar.^3, ...
			left.*RunVar.^4, left.*RunVar.^5];
	  rt = [right.*RunVar, right.*RunVar.^2, right.*RunVar.^3, ...
			 right.*RunVar.^4, right.*RunVar.^5];
	else 
		error('Only polynomials between degree 1 and 5 can be fit')
	end


  victory = RunVar>cutoff;

  X = [cons, victory, lt, rt];
	size(X)
  [beta, CI] = regress(Y, X);

  fprintf('The effect of the treatment is %d \n', beta(2))
	size(beta)

	Yhat = X*beta;

	scatter(RunVar, Y)
	hold on
	plot(RunVar, Yhat, 'r', 'LineWidth', 2)
	line([cutoff cutoff], [min(Y) max(Y)], 'Color', 'k', ...
		'LineStyle', '--', 'LineWidth', 2)
	hold off
return
