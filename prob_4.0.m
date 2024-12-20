function pi_estimation()
    % Define number of points for the simulation
    N_values = [1000, 10000, 100000];
    
    % Preallocate arrays for storing results
    pi_estimates = zeros(size(N_values));
    relative_errors = zeros(size(N_values));
    
    % MATLABs built-in value of pi
    true_pi = pi;
    
    % Loop through different numbers of points
    for idx = 1:length(N_values)
        N = N_values(idx);
        % Estimate pi using simulation
        pi_estimates(idx) = estimate_pi(N);
        % Calculate relative error
        relative_errors(idx) = abs(pi_estimates(idx) - true_pi) / true_pi;
    end
    
    % Display results
    disp('Results:');
    disp('N        Estimated Pi    Relative Error');
    for idx = 1:length(N_values)
        fprintf('%d     %.6f         %.6f\n', N_values(idx), pi_estimates(idx), relative_errors(idx));
    end
    
    % Plot estimated pi vs number of points
    figure;
    plot(N_values, pi_estimates, '-o');
    title('Estimated \pi vs Number of Points');
    xlabel('Number of Points (N)');
    ylabel('Estimated \pi');
    grid on;
    
    % Plot relative error vs number of points
    figure;
    plot(N_values, relative_errors, '-o');
    title('Relative Error vs Number of Points');
    xlabel('Number of Points (N)');
    ylabel('Relative Error');
    grid on;
end

function pi_estimate = estimate_pi(N)
    % Initialize counter for points inside the circle
    counter = 0;
    
    % Generate random points and check if they are inside the circle
    for i = 1:N
        x = rand * 2 - 1; % Random x in [-1, 1]
        y = rand * 2 - 1; % Random y in [-1, 1]
        if x^2 + y^2 <= 1
            counter = counter + 1;
        end
    end
    
    % Estimate pi using the formula
    pi_estimate = 4 * counter / N;
end
