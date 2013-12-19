% RDquadsim.m v1.00              damiancclarke             yyyy-mm-dd:2013-11-26
%---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8
%

clear
clf
%********************************************************************************
%*** (1) paramaters
%********************************************************************************
sims  =  100;
N     =  100000;
B     =  [10 30 2 3 -0.0 0.00 0.0000 0.0000 -0.00000 -0.00000 3];


%********************************************************************************
%*** (2) Simulate Linear RD with various trends
%********************************************************************************
X     =  100*rand(N,sims);
left  =  X<=50;
right =  abs(1-left);
vict  =  X>50;


y     =  B(1) + B(2)*vict + B(3)*X.*left + B(4)*X.*right...
         + B(5)*X.^2.*left + B(6)*X.^2.*right +...
         + B(7)*X.^3.*left + B(8)*X.^3.*right...
         + B(9)*X.^4.*left + B(10)*X.^4.*right + B(11)*randn(N,sims);

for quad=1:4
    clf
    yhat  = NaN(N,sims);
    C     = NaN(2+2*quad,sims);
    Clow  = NaN(2+2*quad,sims);
    Chigh = NaN(2+2*quad,sims);

    for i=1:sims
        if quad==1
            xvars      =  [ones(N,1), vict(:,i), X(:,i).*left(:,i), ...
                           X(:,i).*right(:,i)];
        elseif quad==2
            xvars      =  [ones(N,1), vict(:,i), X(:,i).*left(:,i), ...
                           X(:,i).*right(:,i), X(:,i).^2.*left(:,i), ...
                           X(:,i).^2.*right(:,i)];            
        elseif quad==3
            xvars      =  [ones(N,1), vict(:,i), X(:,i).*left(:,i), ...
                           X(:,i).*right(:,i), X(:,i).^2.*left(:,i), ...
                           X(:,i).^2.*right(:,i), X(:,i).^3.*left(:,i), ...
                           X(:,i).^3.*right(:,i)];            
        elseif quad==4
            xvars      =  [ones(N,1), vict(:,i), X(:,i).*left(:,i), ...
                           X(:,i).*right(:,i), X(:,i).^2.*left(:,i), ...
                           X(:,i).^2.*right(:,i), X(:,i).^3.*left(:,i), ...
                           X(:,i).^3.*right(:,i), X(:,i).^4.*left(:,i), ...
                           X(:,i).^4.*right(:,i)];            
        end
        [C(:,i),d] =  regress(y(:,i), xvars);
        Clow(:,i)  =  d(:,1);
        Chigh(:,i) =  d(:,2);
        %yhat(:,i)  =  xvars*C(:,i);
    end

    run_var = linspace(0,100,N)';
    l       = run_var<=50;
    r       = abs(1-l);
    v       = run_var>50;

    if quad==1
        xvars      =  [ones(N,1), v, run_var.*l, run_var.*r];
    elseif quad==2
        xvars      =  [ones(N,1), v, run_var.*l, run_var.*r,...
                       run_var.^2.*l, run_var.^2.*r];        
    elseif quad==3
        xvars      =  [ones(N,1), v, run_var.*l, run_var.*r,...
                       run_var.^2.*l, run_var.^2.*r,...
                       run_var.^3.*l, run_var.^3.*r];        
    elseif quad==4
        xvars      =  [ones(N,1), v, run_var.*l, run_var.*r,...
                       run_var.^2.*l, run_var.^2.*r,...
                       run_var.^3.*l, run_var.^3.*r,...
                       run_var.^4.*l, run_var.^4.*r];        
    end


    Bhat    = mean(C,2)
    cilow   = mean(Clow,2);
    cihigh  = mean(Chigh,2);
    yhat    = xvars*Bhat;
    cilhat  = xvars*cilow;
    cihhat  = xvars*cihigh;

    scatter(X(:,2),y(:,2))
    hold on
    plot(run_var,yhat, 'r', 'LineWidth', 2)
    %plot(run_var,cilhat, '--k', 'LineWidth', 2)
    %plot(run_var,cihhat, '--k', 'LineWidth', 2)
    hold off
    

    fprintf(['With a quadratic of order %i, the estimate for the' ...
              'discontinuity is %1.2d, (%1.2d,%1.2d)\n'], quad, ...
               Bhat(2),cilow(2),cihigh(2));
end

