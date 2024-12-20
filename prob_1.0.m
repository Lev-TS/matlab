% Step 1: Markov Chain Implementation
function s = generate_markov_chain(P, T, initial_state)
    % Generates a Markov chain of states based on a transition matrix.
    %
    % Inputs:
    %   P: 2x2 transition probability matrix
    %   T: Number of periods
    %   initial_state: Initial state (1 or 2)
    %
    % Output:
    %   s: Array of states (Markov chain)

    % Initialize state array
    s = zeros(T, 1);
    s(1) = initial_state;

    for t = 2:T
        u = rand; % Generate uniform random number
        if s(t-1) == 1
            if u < P(1, 1)
                s(t) = 1;
            else
                s(t) = 2;
            end
        else
            if u < P(2, 1)
                s(t) = 1;
            else
                s(t) = 2;
            end
        end
    end
end

% Step 2: AR(2) Process Implementation
function Y = generate_ar2_with_regime_switching(P, T, rho1, rho2, sigma, initial_values, initial_regime)
    % Simulates an AR(2) process with regime switching.
    %
    % Inputs:
    %   P: 2x2 transition probability matrix
    %   T: Number of periods
    %   rho1, rho2: Coefficients for two states
    %   sigma: Standard deviation for two states
    %   initial_values: Initial values for Y(1) and Y(2)
    %   initial_regime: Initial regime (1 or 2)
    %
    % Output:
    %   Y: Simulated AR(2) process

    % Initialize arrays
    Y = zeros(T, 1);
    s = generate_markov_chain(P, T, initial_regime);
    Y(1:2) = initial_values;

    for t = 3:T
        if s(t) == 1
            rho1_t = rho1(1);
            rho2_t = rho2(1);
            sigma_t = sigma(1);
        else
            rho1_t = rho1(2);
            rho2_t = rho2(2);
            sigma_t = sigma(2);
        end

        epsilon_t = randn; % Standard normal random variable
        Y(t) = rho1_t * Y(t-1) + rho2_t * Y(t-2) + sigma_t * epsilon_t;
    end
end

% Step 3: Visualization
function plot_results(s, Y)
    % Plots the Markov chain process and the AR(2) process.
    %
    % Inputs:
    %   s: Markov chain states
    %   Y: AR(2) process

    % Plot Markov chain process
    figure;
    subplot(2, 1, 1);
    plot(s, 'LineWidth', 1.5);
    title('Markov Chain Process');
    xlabel('Time');
    ylabel('State');
    ylim([0.5, 2.5]);
    yticks([1, 2]);

    % Plot AR(2) process
    subplot(2, 1, 2);
    plot(Y, 'LineWidth', 1.5);
    title('AR(2) Process');
    xlabel('Time');
    ylabel('Y_t');
end

% Example Usage
T = 100;
P = [0.9, 0.1; 0.2, 0.8]; % Transition matrix
rho1 = [0.3, 0.9]; % AR(1) coefficients for two states
rho2 = [0.2, 0.8]; % AR(2) coefficients for two states
sigma = [0.2, 0.4]; % Volatility for two states
initial_values = [0, 0]; % Initial values for Y(1) and Y(2)
initial_regime = 1; % Starting regime

% Generate AR(2) process
s = generate_markov_chain(P, T, initial_regime);
Y = generate_ar2_with_regime_switching(P, T, rho1, rho2, sigma, initial_values, initial_regime);

% Visualize results
plot_results(s, Y);
