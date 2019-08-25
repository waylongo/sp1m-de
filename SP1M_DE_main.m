% Sequential Possibilistic One-Means Clustering with Dynamic Eta (SP1M-DE)
% @author: Wenlong Wu
% @date: 10/25/2018
% @email: ww6p9@mail.missouri.edu
% @University of Missouri-Columbia
% @Paper: https://ieeexplore.ieee.org/abstract/document/8491499
% @Revised: 08/25/2019

close all;clear;clc;

addpath('functions/');
DATA_PATH = "datasets/clusterData_ANFIS_noise1.csv";

data = importdata(DATA_PATH);  % import dataset

% Visualize the input data
figure(1); plot(data(:,1),data(:,2),'.');hold on;title('SP1M-DE demo');
xlim([min(data(:,1)),max(data(:,1))]);ylim([min(data(:,2)),max(data(:,2))]);

%% Parameters
% cluster number; set it to 100 if you don't know it; will auto-select
C = 100; 
SEED = 2019; % for reproducible experiments
ALPHA = 0.5; % alpha cut
CLUSTER_PERCENT = 0.02; % # of points in a cluster < CLUSTER_PERCENT, removed
sparse_fac = -0.001; % noise factor removal, detail in paper

% tune the eta scaler 
scaler = 0.3;

%% Running SP1M-DE
[U, V] = sp1m(data, C, SEED, ALPHA, scaler, CLUSTER_PERCENT, sparse_fac);

%% Visualize the clustering results

color_list = ['g','b', 'c', 'k', 'y', 'r' ];
if(size(V,1) <= size(color_list,2))
    figure;hold on; grid on;
    for i=1:size(U,2)
        [typ, idx] = max(U(:,i));
        if(typ > ALPHA * 0.2)
            plot(data(i,1), data(i,2), '.','Color', color_list(idx), 'MarkerSize', 12);hold on
        else
            plot(data(i,1), data(i,2), 'x','Color', 'm', 'MarkerSize', 4);hold on
        end
    end

    plot(V(:,1),V(:,2),'.r','MarkerSize',30);drawnow;
    title('SP1M-DE');
end
