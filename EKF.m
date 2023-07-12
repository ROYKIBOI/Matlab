% Initialize variables
dt = 0.1;               % time step
t = 0:dt:10;            % time vector
n = length(t);          % number of time steps
x_true = zeros(2,n);    % true state vector
x_true(:,1) = [0; 0];   % initial state
u = ones(1,n);          % input vector
z = zeros(1,n);         % measurement vector
Q = diag([0.1 0.1]);    % process noise covariance matrix
R = 0.1;                % measurement noise covariance matrix
P = eye(2);             % initial error covariance matrix
x_est = zeros(2,n);     % estimated state vector
x_est(:,1) = [0; 0];    % initial state estimate
H = [1 0];              % measurement model

% EKF algorithm
for i = 2:n
    % True system dynamics
    x_true(:,i) = x_true(:,i-1) + [x_true(2,i-1); -x_true(1,i-1)]*dt + sqrt(Q)*randn(2,1);
    % Measurement
    z(i) = x_true(1,i) + sqrt(R)*randn;
    % EKF prediction
    F = [1 dt; -dt 1];
    x_est(:,i) = x_est(:,i-1) + [x_est(2,i-1); -x_est(1,i-1)]*dt;
    P = F*P*F' + Q;
    % EKF update
    y = z(i) - H*x_est(:,i);
    S = H*P*H' + R;
    K = P*H'/S;
    x_est(:,i) = x_est(:,i) + K*y;
    P = (eye(2) - K*H)*P;
end

% Plot results
figure
plot(t, x_true(1,:), 'b-', t, x_est(1,:), 'r--')
xlabel('Time')
ylabel('Position')
legend('True', 'Estimated')
title('EKF Position Estimation')