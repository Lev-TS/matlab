% Trapezoidal Method Function
function result = trapezoidal_rule(f, a, b, n)
    % Calculate step size
    h = (b - a) / (n - 1);
    
    % Generate x points
    x = linspace(a, b, n);
    
    % Evaluate function at x points
    y = f(x);
    
    % Compute trapezoidal sum
    result = (h / 2) * (y(1) + 2 * sum(y(2:end-1)) + y(end));
end

% Main Script
clc;
clear;

% Define the limits
a = 0;
b = 1;

% Number of points
n = 100; % You can adjust n for higher accuracy

% Functions to integrate
f1 = @(x) sin(x);
f2 = @(x) exp(-x);
f3 = @(x) x.^2;

% Compute integrals
integral1 = trapezoidal_rule(f1, a, b, n);
integral2 = trapezoidal_rule(f2, a, b, n);
integral3 = trapezoidal_rule(f3, a, b, n);

% Display results
fprintf('Integral of sin(x) from %d to %d is: %.6f\n', a, b, integral1);
fprintf('Integral of exp(-x) from %d to %d is: %.6f\n', a, b, integral2);
fprintf('Integral of x^2 from %d to %d is: %.6f\n', a, b, integral3);
