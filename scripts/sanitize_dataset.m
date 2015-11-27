function T = sanitize_dataset(dataset_filename, filter_by_asnum, mlabservernames, client_addresses)

% dataset_filename = 'dataset_ita.20120701_20140630.csv';
% mlabservernames = {'mlab1-trn01', 'mlab2-trn01' 'mlab3-trn01', 'mlab1-mil01', 'mlab2-mil01', 'mlab3-mil01'};
% filter_by_asnum = '3269';

%% Load CSV file
% Here is a snip of the file, only speedtest results for "country EQUAL TO
% 'IT'"
tic;
fprintf('Reading table ...');
T = readtable(dataset_filename,'Delimiter',';');
n = height(T);
elapsed = toc;
fprintf(' of %d rows in %.2f seconds\n', n, elapsed);

%% Add column with downloadspeed in Mbit/s
T.download_speed_mbits = T.download_speed * 8 / 1000000;
T.upload_speed_mbits = T.upload_speed * 8 / 1000000;


% Show part of table content 
T(1:20,:)


%% Ensure we have the desired data
% - Italian MLAB servers: trnX and milX

T.mlabservername = categorical(T.mlabservername);
if length(mlabservernames)
rows = zeros(height(T),1);
for i = 1:length(mlabservernames)
    rows_ = T.mlabservername == mlabservernames{1,i};
    rows = rows | rows_;
end
T = T(rows,:);
end
mlab = sortrows(tabulate(T.mlabservername),-2);
mlab(1:10,:)



%% Select only selected ASNUM  data 
T.asnum = categorical(T.asnum);

if length(filter_by_asnum)
rows = zeros(height(T),1);
for i = 1:length(filter_by_asnum)
    rows_ = T.asnum == filter_by_asnum{1,i};
    rows = rows | rows_;
end
T = T(rows,:);
end
asnum = sortrows(tabulate(T.asnum),-2);
asnum(1:end,:)

addresses = categorical(T.client_address);
if length(client_addresses)
rows = zeros(height(T),1);
for i = 1:length(client_addresses)
    rows_ = addresses == client_addresses{1,i};
    %find(rows_)
    rows = rows | rows_;
end
T = T(~rows,:);
end
client_address = sortrows(tabulate(T.client_address),-2);
client_address(1:10,:)
end