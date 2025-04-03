
clc; clear; close all;

% Load CEC benchmark functions
benchmarkFuncs = {@F1_sphere, @F6_rosenbrock, @F13_expgriewank_rosenbrock};
benchmarkNames = {'F1_Sphere', 'F6_Rosenbrock', 'F13_GriewankRosenbrock'};

% Dimensions to evaluate
dimensionSizes = [2, 10];

% Number of runs
iterations = 15;

% Initialize storage
evaluationResults = struct();

for idxFunc = 1:numel(benchmarkFuncs)
    currentFunc = benchmarkFuncs{idxFunc};
    funcName = benchmarkNames{idxFunc};

    for idxDim = 1:numel(dimensionSizes)
        D = dimensionSizes(idxDim);

        % Set bounds
        if strcmp(funcName, 'F13_GriewankRosenbrock')
            lb = -5 * ones(1, D);
            ub = 5 * ones(1, D);
        else
            lb = -100 * ones(1, D);
            ub = 100 * ones(1, D);
        end

        performanceData = struct('GA', [], 'PSO', [], 'SA', []);

        for trial = 1:iterations
            fprintf('Running %s | Dimension: %d | Trial: %d\n', funcName, D, trial);

            % GA
            gaOpts = optimoptions('ga', 'Display', 'off');
            [~, fval] = ga(@(x) currentFunc(x, D), D, [], [], [], [], lb, ub, [], gaOpts);
            performanceData.GA(end+1,1) = fval;

            % PSO
            psoOpts = optimoptions('particleswarm', 'Display', 'off');
            [~, fval] = particleswarm(@(x) currentFunc(x, D), D, lb, ub, psoOpts);
            performanceData.PSO(end+1,1) = fval;

            % SA
            saOpts = saoptimset('Display', 'off');
            [~, fval] = simulannealbnd(@(x) currentFunc(x, D), rand(1,D).*(ub-lb) + lb, lb, ub, saOpts);
            performanceData.SA(end+1,1) = fval;
        end

        % Store results
        key = sprintf('Dim%d', D);
        evaluationResults.(funcName).(key) = performanceData;

        % Display
        fprintf('\n=== %s (D=%d) ===\n', funcName, D);
        fprintf('GA  - Mean: %.4f | Std: %.4f | Best: %.4f | Worst: %.4f\n', ...
            mean(performanceData.GA), std(performanceData.GA), min(performanceData.GA), max(performanceData.GA));
        fprintf('PSO - Mean: %.4f | Std: %.4f | Best: %.4f | Worst: %.4f\n', ...
            mean(performanceData.PSO), std(performanceData.PSO), min(performanceData.PSO), max(performanceData.PSO));
        fprintf('SA  - Mean: %.4f | Std: %.4f | Best: %.4f | Worst: %.4f\n', ...
            mean(performanceData.SA), std(performanceData.SA), min(performanceData.SA), max(performanceData.SA));

        % Plot
        figure;
        hold on;
        plot(performanceData.GA, '-o', 'DisplayName', 'GA');
        plot(performanceData.PSO, '-x', 'DisplayName', 'PSO');
        plot(performanceData.SA, '-s', 'DisplayName', 'SA');
        xlabel('Run Number');
        ylabel('Objective Function Value');
        title(sprintf('Performance Comparison on %s (Dimension=%d)', funcName, D));
        legend;
        grid on;
        hold off;
    end
end
