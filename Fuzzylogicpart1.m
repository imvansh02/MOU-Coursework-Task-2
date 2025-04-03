% Create a Mamdani-type FIS
fis = mamfis('Name', 'AmbientAssistedLivingFIS');

%% === Input Variables ===

% 1. Temperature
fis = addInput(fis, [0 40], 'Name', 'Temperature');
fis = addMF(fis, 'Temperature', 'trimf', [-10 0 20], 'Name', 'Cold');
fis = addMF(fis, 'Temperature', 'trimf', [10 20 30], 'Name', 'Comfortable');
fis = addMF(fis, 'Temperature', 'trimf', [25 35 45], 'Name', 'Hot');

% 2. Light Level
fis = addInput(fis, [0 1000], 'Name', 'Light');
fis = addMF(fis, 'Light', 'trimf', [0 100 300], 'Name', 'Dark');
fis = addMF(fis, 'Light', 'trimf', [200 500 800], 'Name', 'Dim');
fis = addMF(fis, 'Light', 'trimf', [700 900 1100], 'Name', 'Bright');

% 3. Motion Activity
fis = addInput(fis, [0 2], 'Name', 'Motion');
fis = addMF(fis, 'Motion', 'trapmf', [-1 0 0.25 0.75], 'Name', 'None');
fis = addMF(fis, 'Motion', 'trapmf', [0.25 0.75 1.25 1.75], 'Name', 'Low');
fis = addMF(fis, 'Motion', 'trapmf', [1.25 1.75 2 3], 'Name', 'High');

% 4. Noise Level
fis = addInput(fis, [0 100], 'Name', 'Noise');
fis = addMF(fis, 'Noise', 'trimf', [0 10 30], 'Name', 'Silent');
fis = addMF(fis, 'Noise', 'trimf', [20 50 80], 'Name', 'Moderate');
fis = addMF(fis, 'Noise', 'trimf', [60 90 120], 'Name', 'Loud');

% 5. Mood
fis = addInput(fis, [0 2], 'Name', 'Mood');
fis = addMF(fis, 'Mood', 'trapmf', [-1 0 0.25 0.75], 'Name', 'Sad');
fis = addMF(fis, 'Mood', 'trapmf', [0.25 0.75 1.25 1.75], 'Name', 'Neutral');
fis = addMF(fis, 'Mood', 'trapmf', [1.25 1.75 2.5 3], 'Name', 'Happy');

%% === Output Variables ===

% 1. Heater
fis = addOutput(fis, [0 100], 'Name', 'Heater');
fis = addMF(fis, 'Heater', 'trimf', [0 0 50], 'Name', 'Off');
fis = addMF(fis, 'Heater', 'trimf', [25 50 75], 'Name', 'Low');
fis = addMF(fis, 'Heater', 'trimf', [50 100 100], 'Name', 'High');

% 2. Blinds
fis = addOutput(fis, [0 2], 'Name', 'Blinds');
fis = addMF(fis, 'Blinds', 'trimf', [-0.5 0 0.5], 'Name', 'Closed');
fis = addMF(fis, 'Blinds', 'trimf', [0.5 1 1.5], 'Name', 'HalfOpen');
fis = addMF(fis, 'Blinds', 'trimf', [1.5 2 2.5], 'Name', 'Open');

% 3. Lamp
fis = addOutput(fis, [0 100], 'Name', 'Lamp');
fis = addMF(fis, 'Lamp', 'trimf', [0 0 25], 'Name', 'Off');
fis = addMF(fis, 'Lamp', 'trimf', [25 50 75], 'Name', 'Dim');
fis = addMF(fis, 'Lamp', 'trimf', [75 100 100], 'Name', 'Bright');

% 4. TV Volume
fis = addOutput(fis, [0 3], 'Name', 'TVVolume');
fis = addMF(fis, 'TVVolume', 'trimf', [-0.5 0 0.5], 'Name', 'Mute');
fis = addMF(fis, 'TVVolume', 'trimf', [0.5 1 1.5], 'Name', 'Low');
fis = addMF(fis, 'TVVolume', 'trimf', [1.5 2 2.5], 'Name', 'Medium');
fis = addMF(fis, 'TVVolume', 'trimf', [2.5 3 3.5], 'Name', 'High');

%% === Fuzzy Rules (18 Rules) ===
ruleList = [
    % Temp, Light, Motion, Noise, Mood, Heater, Blinds, Lamp, TVVol, weight, op
     1     0      1      0      0      3      0       0     0      1     1;
     1     0      3      0      0      2      0       0     0      1     1;
     2     0      0      0      0      1      0       0     0      1     1;
     3     0      0      0      0      1      0       0     0      1     1;

     0     3      0      0      1      0      1       0     0      1     1;
     0     2      0      0      2      0      2       0     0      1     1;
     0     1      0      0      3      0      3       0     0      1     1;

     0     1      0      0      1      0      0       3     0      1     1;
     0     2      0      0      2      0      0       2     0      1     1;
     0     3      0      0      0      0      0       1     0      1     1;

     0     0      0      3      2      0      0       0     2      1     1;
     0     0      2      2      0      0      0       0     3      1     1;
     0     0      0      1      3      0      0       0     4      1     1;
     0     0      0      0      1      0      0       0     1      1     1;

     1     1      0      0      1      3      0       3     0      1     1;
     0     3      0      0      3      0      1       1     0      1     1;
     2     2      0      0      2      1      0       2     0      1     1;
     0     0      1      3      0      0      0       0     1      1     1;
];

fis = addRule(fis, ruleList);

%% Optional: View structure
 showrule(fis)
 plotfis(fis)

% Save FIS
writeFIS(fis, 'AmbientComfortFLC');

%% 
testCases = [
    10  50   0  10  0;   % Cold, dark, no motion, quiet, sad
    22 800   1  40  2;   % Comfortable, bright, low activity, moderate noise, happy
    35 200   2  90  1;   % Hot, dim, high activity, loud, neutral
    15 100   1  60  0;   % Cool, dark, low motion, loud, sad
    25 400   2  20  2;   % Warm, dim, high motion, quiet, happy
];

for i = 1:size(testCases, 1)
    result = evalfis(fis, testCases(i,:));
    fprintf('\n--- Test Case %d ---\n', i);
    fprintf('Inputs: Temp=%.1f, Light=%.0f, Motion=%d, Noise=%.1f, Mood=%d\n', ...
        testCases(i,1), testCases(i,2), testCases(i,3), testCases(i,4), testCases(i,5));
    fprintf('Heater: %.2f | Blinds: %.2f | Lamp: %.2f | TV Volume: %.2f\n', ...
        result(1), result(2), result(3), result(4));
end

%% === Surface Plots for Important Relationships ===

surfacePlots = {
    [1 5], 1, 'Heater vs Temperature & Mood';
    [2 5], 3, 'Lamp vs Light & Mood';
    [4 5], 4, 'TV Volume vs Noise & Mood';
    [2 5], 2, 'Blinds vs Light & Mood';
    [1 3], 1, 'Heater vs Temperature & Motion';
};

for i = 1:size(surfacePlots,1)
    inputIdx = surfacePlots{i,1};
    outputIdx = surfacePlots{i,2};
    titleText = surfacePlots{i,3};

    figure('Name', titleText);
    gensurf(fis, inputIdx, outputIdx);
    title(['Control Surface: ' titleText], 'FontSize', 12, 'Interpreter', 'none');
    xlabel(fis.Inputs(inputIdx(1)).Name);
    ylabel(fis.Inputs(inputIdx(2)).Name);
    zlabel(fis.Outputs(outputIdx).Name);
end

%% --- INPUT MEMBERSHIP FUNCTIONS ---
inputNames = {'Temperature', 'Light', 'Motion', 'Noise', 'Mood'};

for i = 1:length(inputNames)
    figure;
    plotmf(fis, 'input', i);
    title([inputNames{i} ' Membership Functions']);
    saveas(gcf, ['MF_' inputNames{i} '.png']);
end

%% --- OUTPUT MEMBERSHIP FUNCTIONS ---
outputNames = {'Heater', 'Blinds', 'Lamp', 'TVVol'};

for i = 1:length(outputNames)
    figure;
    plotmf(fis, 'output', i);
    title([outputNames{i} ' Membership Functions']);
    saveas(gcf, ['MF_' outputNames{i} '.png']);
end

%% Display FIS in the Fuzzy Logic Designer GUI
%fuzzyLogicDesigner('AmbientComfortFLC.fis');
