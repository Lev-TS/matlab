% Load the saved viewership data
load('viewdata.mat'); % Assumes viewdata is stored as a variable in viewdata.mat

% Convert viewdata matrix into a table for easier handling
viewdataTable = array2table(viewdata, 'VariableNames', {'VideoLength', 'Views', 'MinutesWatched'});

% Add a new column PercentViewed
viewdataTable.PercentViewed = (viewdataTable.MinutesWatched ./ viewdataTable.Views) ./ viewdataTable.VideoLength;

% Add a new column VideoType
viewdataTable.VideoType = cell(size(viewdataTable, 1), 1); % Initialize as a cell array
for i = 1:height(viewdataTable)
    if viewdataTable.VideoLength(i) < 1.5
        viewdataTable.VideoType{i} = 'short';
    elseif viewdataTable.VideoLength(i) <= 2.25
        viewdataTable.VideoType{i} = 'medium';
    else
        viewdataTable.VideoType{i} = 'long';
    end
end

% Calculate mean percentage viewed for each video type
videoTypes = unique(viewdataTable.VideoType); % Get unique video types
meanPercentViewed = zeros(size(videoTypes)); % Initialize array for mean percentages
for i = 1:length(videoTypes)
    meanPercentViewed(i) = mean(viewdataTable.PercentViewed(strcmp(viewdataTable.VideoType, videoTypes{i})));
end

% Create a new table to store the results
resultsTable = table(videoTypes, meanPercentViewed, 'VariableNames', {'VideoType', 'MeanPercentViewed'});

% Display the results
disp(resultsTable);
