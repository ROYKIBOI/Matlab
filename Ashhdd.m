clc;
clear all;
close all;

%% Set parameters
framePeriod = 0.01; % Frame period (in seconds)
numPoints = 100; % Number of points to simulate
maxBandwidth = 10; % Maximum bandwidth (in Mbps)
minBandwidth = 1; % Minimum bandwidth (in Mbps)

%% Compute bandwidths to simulate
bandwidths = linspace(minBandwidth, maxBandwidth, numPoints);

%% Compute performance metrics for each bandwidth
for i = 1:length(bandwidths)
    bandwidth = bandwidths(i);
    falseAlarmThreshold = 2*0.0001*0.1/(0.1*bandwidth*1e6); % False alarm threshold
    probabilities = zeros(1, 100);
    for j = 1:100
        % Compute interference and received power
        interference = 0.5*randn();
        receivedPower = 0.1/(1 + interference + 0.0001);

        % Compute probability of false alarm
        if receivedPower >= falseAlarmThreshold
            probabilities(j) = 1;
        end
    end
    
    % Compute average probability of false alarm
    meanProbability(i) = mean(probabilities);
end

%% Plot the curves
hold on;
plot(bandwidths, meanProbability, '-.', 'LineWidth', 2);
plot(bandwidths, 0.8*ones(size(bandwidths)), '-.', 'LineWidth', 1);
plot(bandwidths, 0.6*ones(size(bandwidths)), '-.', 'LineWidth', 1);
plot(bandwidths, 0.4*ones(size(bandwidths)), '-.', 'LineWidth', 1);
xlabel('Frame Period (s)');
ylabel('Bandwidth (Mbps)');
ylim([minBandwidth, maxBandwidth]);
legend('Curve 1', 'Curve 2', 'Curve 3', 'Curve 4');
grid on;
hold off;
