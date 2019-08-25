function [ Uall, Vall] = sp1m( data, C, SEED, ALPHA, scaler, CLUSTER_PERCENT)
% Sequential Possibilistic One-Means Clustering with Dynamic Eta (SP1M-DE)
% @author: Wenlong Wu
% @date: 10/25/2018
% @email: ww6p9@mail.missouri.edu
% @University of Missouri-Columbia
% @Paper: https://ieeexplore.ieee.org/abstract/document/8491499
% @Revised: 08/25/2019

% function@input: data
% function@output: Uall(membership), Vall(cluster centers)

%% some hyper-parameters
N = size(data, 1); % data number and dimension 
fzr=1.5; % fuzzifier
epsilon=0.01; % epsilon threshold
Uall=[]; % membership matrix
Vall=[]; % cluster center

%% 
% This part is only for 2 dimension 
r1=max(data(:,1))-min(data(:,1));
r2=max(data(:,2))-min(data(:,2));
eta_max=sqrt(r1^2+r2^2) / 2; % the max radius of the data range
steps=100; % the number of eta steps
eta_base=eta_max/steps;
eta=zeros(1,C)*inf; % initial the eta
u=zeros(C, N);
d=zeros(C, N);

U_count=zeros(1,C);
stop_count=0;
stop_code=0;

%%
% the main loop
for iter=1:C
    %-------------------------loop 2---------------------------------------
    while(1)
    % propabilities to choose cluster center
    SEED=SEED+1;
    selected_v = random_select(data, iter, Uall, SEED);
    v(iter, :) = selected_v;

    %---------------------------loop 1 < P1M >------------------
    while(1)
        
    % estimate dynamic eta
    [estimated_eta, found] = dynamic_estimate_eta(v(iter,:), data, eta_base, scaler,ALPHA);
    
    eta(iter) = estimated_eta;
    
    % compute d
    d(iter,:) = pdist2(data,v(iter,:)).^2;
    
    % compute u(v,X)
     u(iter,:) = 1 ./ (1+(d(iter,:)/eta(iter)).^(1/(fzr-1)));
    
    % compute v(u,X) / for 2 dimensions    
    v_up = (u(iter,:)>ALPHA) .* u(iter,:) .^ fzr * data;
    v_down = sum((u(iter,:)>ALPHA) .* u(iter,:) .^ fzr);
    count = sum((u(iter,:)>ALPHA));
    v_new(iter,:)=v_up / v_down;
    
    v_diff=pdist2(v(iter,:), v_new(iter,:))^2;
    v(iter,:)=v_new(iter,:);
    
%     plot(v(iter,1), v(iter,2), 'xr');
    if(count < N * CLUSTER_PERCENT)
        found = false;
        break;
    end
    
    % if cluster center doesn`t move, break the while
    if v_diff < epsilon
        break;
    end

    end
    
    %%
    %----------------------------loop 1 < P1M > end-------------------

    % termination calculation
    stop_count=stop_count+1;
    U_count(iter) = 0;
    
    if(iter > 1)
        U_count(iter) = sum(max(Uall)>ALPHA);
    end
    
    if stop_count>N-U_count(iter)
        stop_code=1;
        break;
    end
    
    if(found==false)
       continue; 
    end
   
    % remove the coincident cluster center
    vw=zeros(1,iter-1);
    if iter>1
        for j=1:iter-1
           vw(j)=pdist2(v(iter,:),Vall(j,:))^2;
        end
        vw_min=min(vw);
%         if vw_min> (sum(eta(1:iter))/iter)^2  % threshold
        if vw_min> (max(eta(1:iter))) * 1.5
            break;
        end
    else
        break;
    end
    
    U_count(iter)=0;
    end
    %-----------------------------loop 2 end-------------------------------
    if stop_code == 1
        break; % stop the program
    end
    
    Uall=[Uall;u(iter,:)];
    Vall=[Vall;v(iter,:)];
    stop_count=0;
    plot(v(iter,1),v(iter,2),'.r','MarkerSize',30);drawnow;
    
end

end

