function [ selected_v ] = random_select( data, iter, U, seed )
% Random select a data point to initialize cluster center
% @author: Wenlong Wu
% @date: 10/25/2018
% @email: ww6p9@mail.missouri.edu
% @University of Missouri-Columbia

    % propabilities to choose cluster center
    N = size(data, 1);
    if iter==1 
        p_trans=ones(1,N)*1/N;
    else
        p = max(U, [], 1);
        p_trans = p;
        alpha_cut = 0.5;
        p_trans(p>alpha_cut) = 0;
        p_trans(p<=alpha_cut) = 1 - p(p<=alpha_cut);
        p_trans = p_trans / (sum(p_trans));
    end

    % pick v with possibilites
    rng(seed);
    order=1:N;
    random_v=randsrc(1,1,[order; p_trans]);
    selected_v = data(random_v,:);
    
end