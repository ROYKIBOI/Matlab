% Define parameters
distance = 500;               % Distance between the drone and the cell tower in meters
frequency = 2.4e9;            % Carrier frequency in Hz
transmitPower = 30;           % Transmit power of the cell tower in dBm
shadowingStdDev = 4;          % Standard deviation of shadowing in dB
noisePower = -104;            % Noise power in dBm
bandwidth = 10e6;             % Bandwidth in Hz
antennaGain = 5;              % Antenna gain in dBi
pathLossExponent = 2;         % Path loss exponent

% Simulate signal strength and quality
signalStrength = simulateSignalStrength(distance, frequency, transmitPower, shadowingStdDev, pathLossExponent);
signalQuality = calculateSignalQuality(signalStrength, noisePower, bandwidth, antennaGain);

% Display results
disp('Signal Strength (dBm):');
disp(signalStrength);
disp('Signal Quality (SNR):');
disp(signalQuality);

% Helper functions

function signalStrength = simulateSignalStrength(distance, frequency, transmitPower, shadowingStdDev, pathLossExponent)
    % Simulate signal strength using a path loss model with log-normal shadowing
    pathLoss = 20 * log10(distance) + 20 * log10(frequency) - 27.55 - 20 * log10(3e8);
    shadowing = normrnd(0, shadowingStdDev);
    signalStrength = transmitPower - pathLoss - shadowing - pathLossExponent * 10 * log10(distance);
end

function signalQuality = calculateSignalQuality(signalStrength, noisePower, bandwidth, antennaGain)
    % Calculate signal quality (SNR) based on signal strength, noise power, bandwidth, and antenna gain
    receivedPower = 10^(signalStrength / 10);
    noiseFloor = 10^(noisePower / 10);
    interferencePower = receivedPower - noiseFloor;
    snr = interferencePower / (noiseFloor * bandwidth);
    signalQuality = snr + antennaGain;
end
