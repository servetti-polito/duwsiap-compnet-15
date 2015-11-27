function [Hs stats keys] = dataset_to_histograms(T, field_key, field_value, edges, minsamples) 
%% Build histograms

% from Bongiorno thesis
%
% bin(ds) = ceil(ds) if ds <= 6 Mb/s
% bin(ds) = ceil(ln((ds-1.81)^4.19)) if ds > 6Mb/s
%

% maxval = max(T.download_speed_mbits);
% edges = [ 0 1 2 3 4 5 6 7.1 8.5 10.3 12.6 15.6 19.4 24.0 30.0 37.6 47.3 59.6 75.2 95.0 120.1 maxval ];


fprintf('Computing histograms ... ');

Hists = grpstats(T,{field_key}, ...
    {@(x)buildHistogram(x,edges),'mean','var',@skewness,@kurtosis,@median,'max'},'DataVars',field_value, ...
    'VarNames',{field_key,'GroupCount','hist','mean','var','skew','kur','med','max'});

% filter histogram with more than 100 counts
Hists = Hists((Hists.GroupCount > minsamples),:);

fprintf(' done\n');

keys = Hists{:,1};
Hs = Hists{:,3};
stats =  table2struct(Hists(:,[2 4:end]));

end

function h = buildHistogram(vector,edges)
    %fprintf('Number of arguments: %d\n',length(vector))
    %celldisp(varargin)
    h = histcounts(vector, edges, 'Normalization', 'probability')';
end

