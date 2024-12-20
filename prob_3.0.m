% Generate a 1000x1000 matrix X with normally distributed random numbers
X = randn(1000, 1000);

% ------------ For loop implementation ------------
% 1. Calculate matrix Y using explicit iteration
tic; % Start timer
Y_loop = zeros(size(X)); % Initialize Y matrix
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        if X(i, j) > 0
            Y_loop(i, j) = sqrt(X(i, j)) + sin(X(i, j));
        else
            Y_loop(i, j) = X(i, j)^2;
        end
    end
end
execution_time_loop_1 = toc; % End timer
disp(['Execution time for operation 1 (loop): ', num2str(execution_time_loop_1)]);

% 2. Replace elements less than row mean using explicit iteration
tic; % Start timer
for i = 1:size(X, 1)
    row_mean = mean(Y_loop(i, :)); % Calculate row mean
    for j = 1:size(X, 2)
        if Y_loop(i, j) < row_mean
            Y_loop(i, j) = row_mean;
        end
    end
end
execution_time_loop_2 = toc; % End timer
disp(['Execution time for operation 2 (loop): ', num2str(execution_time_loop_2)]);

% ------------ Vectorized implementation ------------
% 1. Calculate matrix Y using vectorized operations
tic; % Start timer
Y_vectorized = sqrt(X) + sin(X); % Apply first condition
Y_vectorized(X <= 0) = X(X <= 0).^2; % Apply second condition
execution_time_vectorized_1 = toc; % End timer
disp(['Execution time for operation 1 (vectorized): ', num2str(execution_time_vectorized_1)]);

% 2. Replace elements less than row mean using vectorized operations
tic; % Start timer
row_means = mean(Y_vectorized, 2); % Calculate row means
row_means_matrix = repmat(row_means, 1, size(X, 2)); % Replicate row means
Y_vectorized(Y_vectorized < row_means_matrix) = row_means_matrix(Y_vectorized < row_means_matrix);
execution_time_vectorized_2 = toc; % End timer
disp(['Execution time for operation 2 (vectorized): ', num2str(execution_time_vectorized_2)]);

% Compare the execution times
disp('Execution time comparison:');
disp(['Loop implementation total time: ', num2str(execution_time_loop_1 + execution_time_loop_2)]);
disp(['Vectorized implementation total time: ', num2str(execution_time_vectorized_1 + execution_time_vectorized_2)]);
