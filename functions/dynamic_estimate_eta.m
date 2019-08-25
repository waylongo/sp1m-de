function [estimated_eta, found] = dynamic_estimate_eta(center, data, eta_base, scaler, ALPHA, sparse_fac)
% Dynamic estimated eta value
% @author: Wenlong Wu
% @date: 10/25/2018
% @email: ww6p9@mail.missouri.edu
% @University of Missouri-Columbia
% @Revised: 08/25/2019

d = pdist2(center, data) .^ 2;

fzr=1.5;
% dynamic eta processing
steps = 100;
eta_tmp=zeros(1,steps);
u_avg=zeros(1,steps); % define the average membership
u_avg_diff=zeros(1,steps-1);
found=true;
% ALPHA = ALPHA * 0.1; % tune ALPHA

% dynamic eta loop
for eta_step=1:steps
    eta_tmp(eta_step)=eta_base*eta_step;  % the current eta value

    % compute u(v,X)
    u = 1 ./ (1+(d ./eta_tmp(eta_step)).^(1/(fzr-1)));
    
    % calculate the membership in the circle   
    u_avg(eta_step) = sum(u(u>ALPHA)) / sum(u>ALPHA);
    
end

% difference of membership
for m=1:steps-1
    u_avg_diff(m)=u_avg(m+1)-u_avg(m);
end

% difference of difference of membership
for m=1: steps-2
    u_avg_diff_diff(m)=u_avg_diff(m+1)-u_avg_diff(m);
    if(u_avg_diff_diff > sparse_fac)  % remove noisy points
        found=false;
        break;
    end
end

[~ ,eta_times]=knee_pt(u_avg_diff,1:(steps-1));

% This is an approximate estimation of  eta
estimated_eta=(eta_times * 0.8 * scaler) * eta_base; 

end

