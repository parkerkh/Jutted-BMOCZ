clear; close all; clc;

% Get current path and parent directory
currentFolder = pwd;
parentFolder = fileparts(currentFolder);

% Add functions to current path
addpath(strcat(parentFolder, '\functions'))

% J-BMOCZ parameters
K = 16;
R = 1.1;
zeta = 1.2;

% Generate constellation zeros
constellationZeros = generateAllZeros(K, R, zeta);

% Declare 16-bit binary message
message = [1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1].';

% Map message to polynomial
polyTX = jbmoczMessageToPoly(message, R, zeta, K+1);

% Declare variables for plotting
theta = linspace(0, 2*pi, 1000);
Router = R * exp(1j*theta);
Rinner = 1/R * exp(1j*theta);

% Angles to sweep over
phi = linspace(0, 2 * 2*pi/K, 100);
phiSweep = [phi, fliplr(phi)];

% Template axis variables
N = 1024;
omega = linspace(-pi, pi, N);

% Open zero pattern figure
f1 = figure(1);
grid on; box on; hold on; axis square;
ax = gca; ax.GridLineStyle = ':'; ax.GridLineWidth = 1; ax.TickLabelInterpreter = 'latex';

plot(real(Router), imag(Router), 'k:', 'LineWidth', 1)
plot(real(Rinner), imag(Rinner), 'k:', 'LineWidth', 1)

xlabel('Real axis', 'Interpreter', 'latex')
ylabel('Imaginary axis', 'Interpreter', 'latex')

xticks(-1.5:0.5:1.5)
yticks(-1.5:0.5:1.5)

% Open template figure
f2 = figure(2);
grid on; box on; hold on;
ax = gca; ax.GridLineStyle = ':'; ax.GridLineWidth = 1; ax.TickLabelInterpreter = 'latex';

xlabel('$\omega$', 'Interpreter', 'latex')
ylabel('$T(\omega)$', 'Interpreter', 'latex')

xlim([-pi, pi])
ylim([1.8, 8.2])
xticks(-pi:pi/2:pi);
yticks(2:1:8);
xticklabels({'$-\pi$', '$-\pi/2$', '$0$', '$-\pi/2$', '$\pi$'});

% Initialize scatterplot and lineplot
s = scatter([], []);
p = plot([], []);

% Loop over rotation angles
for i = 1:numel(phiSweep)

    % Clear current scatterplot and lineplot
    delete(s);
    delete(p);

    % Rotate zeros
    polyRX = polyTX .* exp(1j*phiSweep(i)*(0:K)).';
    zerosRX = roots(polyRX);

    % Calculate template 
    templateRX = abs(fft(polyRX, N));

    % Update scatterplot
    figure(1);
    scatter(real(constellationZeros(:)), imag(constellationZeros(:)), sz, 'ko', 'MarkerFaceColor', 'white', 'LineWidth', 1)
    s = scatter(real(zerosRX), imag(zerosRX), 'r*', 'LineWidth', 0.75);

    % Update lineplot
    figure(2);
    p = plot(omega, fftshift(templateRX), 'r-', 'LineWidth', 1);

    % Export current figure to GIF
    exportgraphics(f1, 'zeroRotation.gif', 'Append', true);
    exportgraphics(f2, 'tempalteShift.gif', 'Append', true);

end