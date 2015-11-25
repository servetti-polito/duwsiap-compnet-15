%% Define dataset
clear all; close all;
dataset_filename = '../dataset_D1_telecom_20120701_20140630_full.csv';

%% Sanitize

mlabservernames = { 'mlab1-mil01', 'mlab2-mil01', 'mlab3-mil01', 'mlab1-trn01', 'mlab2-trn01', 'mlab3-trn01' };
%filter_by_asnum = {'30722'};
filter_by_asnum = {'3269'};

T = sanitize_dataset(dataset_filename, filter_by_asnum, mlabservernames, {});

%% Scatter plot 
% Plot some data
figure;
scatter(T.download_speed_mbits,T.upload_speed_mbits,5,'k'); 
xlabel('Download speed mbit/s');
ylabel('Upload speed mbit/s');

%% Build histogram

maxval_dw = max(T.download_speed_mbits);
%edges = [ 0 1 2 3 4 5 6 7.1 8.5 10.3 12.6 15.6 19.4 24.0 30.0 37.6 47.3 59.6 75.2 95.0 120.1 maxval ];
edges_dw_telecomitalia = [0:20];
size(edges_dw_telecomitalia)
size(ceil(maxval_dw))
edges_dw = [ edges_dw_telecomitalia ceil(maxval_dw) ]

[hists_dw stats_dw kk_dw] = dataset_to_histograms(T, 'id_sub', 'download_speed_mbits', edges_dw, 50);


maxval_up = max(T.upload_speed_mbits);
%edges = [ 0 1 2 3 4 5 6 7.1 8.5 10.3 12.6 15.6 19.4 24.0 30.0 37.6 47.3 59.6 75.2 95.0 120.1 maxval ];
edges_up_telecomitalia = [0:.1:1.1];
edges_up = [ edges_up_telecomitalia ceil(maxval_up) ]

[hists_up stats_up kk_up] = dataset_to_histograms(T, 'id_sub', 'upload_speed_mbits', edges_up, 50);

%% Scatter plot with means and average user histogram profile
% Grafico up vs down con in nero le singole misure e in rosso le medie
% degli utenti. Chiaramente ci sono pochi utenti "al di fuori del range che
% ci si potrebbe aspettare (down: fino a 20 mbps e up: fino a 1 mbps)


% zoom nella zona di interesse dove si vedono le due classi di adsl a 7 e
% 20 mbps (dove per? la 20 mbps non arriva mai a tale velocit?)
figure;
subplot(4,4,[2 3 4 6 7 8 10 11 12]);
scatter(T.download_speed_mbits,T.upload_speed_mbits,1,'Marker','.','MarkerEdgeColor',[1 1 1]*.8); 
hold on;
scatter([stats_dw.mean],[stats_up.mean],20,'*k');
axis([edges_dw(1) edges_dw(end-1) edges_up(1) edges_up(end-1)]);
grid on;
hold off;

subplot(4,4,[14 15 16]);
average_of_histograms = sum(hists_dw,1);
m = max(average_of_histograms(:));
bar(edges_dw(1:end-1),average_of_histograms,'histc','w');
ax = axis; ax(1)=edges_dw(1); ax(2)=edges_dw(end-1); ax(3)=0; ax(4)=m*1.1;
axis(ax);
xlabel('Download speed mbit/s');

subplot(4,4,[1 5 9]);
average_of_histograms = sum(hists_up,1);
m = max(average_of_histograms(:));
barh(edges_up(1:end-1), average_of_histograms, 'hist', 'w');
ax = axis; ax(3)=edges_up(1); ax(4)=edges_up(end-1); ax(1)=0; ax(2)=m*1.1;
axis(ax);
ylabel('Upload speed mbit/s');
