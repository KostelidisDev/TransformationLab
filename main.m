%% Clear Workspace
close all;
clear;
clc;

%% User Configurable Variables
input_image_file = 'Demo.scaled.jpeg';
% A 2-D array (Nx2),
% the first col is the scale
% the second col is the rotation
transformations = [
    0.25 0;
    0.75 0;
    1.25 0;
    1.75 0;
    1 10;
    1 20;
    1 30;
    1 40;
    0.25 40;
    0.75 30;
    1.25 20;
    1.75 10
    ];

%% Main Script
% Print script info
fprintf("********************************************************\n");
fprintf("TransformationLab\n");
fprintf("Developed by Iordanis Kostelidis <iordkost@ihu.gr>\n");
fprintf("********************************************************\n");

% Load RGB image
fprintf("Loading %s image file as RGB... ", input_image_file);
rgb_input_image = imread(input_image_file);
fprintf("Done\n");

% Convert RGB to Grayscale image
fprintf("Converting %s image file as to grayscale on memory... ", input_image_file);
input_image = rgb2gray(rgb_input_image);
fprintf("Done\n");

clear input_image_file;
clear rgb_input_image;

fprintf("Extracting KAZE features... ")
[kazeFeatures, kazePoints] = extractFeatures( ...
    input_image, ...
    detectKAZEFeatures(input_image) ...
    );
fprintf("Done\n")

fprintf("Extracting ORB features... ")
[orbFeatures, orbPoints] = extractFeatures( ...
    input_image, ...
    detectORBFeatures(input_image) ...
    );
fprintf("Done\n")

% A 2-D array (Nx6)
% Scale, Rotate, Estimated Scale, Estimated Rotate, Error Scale, Error Rotate
kaze_results = zeros(length(transformations), 6);

% A 2-D array (Nx6)
% Scale, Rotate, Estimated Scale, Estimated Rotate, Error Scale, Error Rotate
orb_results = zeros(length(transformations), 6);

result_labels = {'Scale', 'Rotate', 'Estimated_Scale', 'Estimated_Rotate', 'Diff_Scale', 'Diff_Rotate'};

for transformation_index = 1:length(transformations)
    transformation = transformations(transformation_index,:);
    transformation_scale = transformation(1);
    transformation_rotate = transformation(2);
    clear transformation;

    transformed_image = input_image;

    if transformation_scale ~= 1
        fprintf("\t Scaling to %f...", transformation_scale)
        transformed_image = imresize(input_image, transformation_scale);
        fprintf(" Done\n")
    end

    if transformation_rotate > 0
        fprintf("\t Rotating to %f...", transformation_rotate)
        transformed_image = imrotate( ...
            transformed_image, ...
            transformation_rotate ...
            );
        fprintf("Done\n")
    end

    fprintf("\t \t Extracting KAZE features... ");
    [kazeTransformedFeatures,kazeTransformedPoints] = extractFeatures( ...
        transformed_image, ...
        detectKAZEFeatures(transformed_image) ...
        );
    fprintf("Done\n");

    fprintf("\t \t Estimating KAZE geometric transformation... ");
    [~, kazeS, kazeTheta, ~, ~] = tl_geometric_estimator( ...
        kazeFeatures, ...
        kazePoints, ...
        kazeTransformedFeatures, ...
        kazeTransformedPoints ...
        );
    fprintf("Done\n");
    clear kazeTransformedFeatures kazeTransformedPoints;
    fprintf("\t \t Estimated KAZE scale=%f and rotate=%f\n", kazeS, kazeTheta);
    kaze_results(transformation_index,:) = tl_result( ...
        transformation_scale, ...
        transformation_rotate, ...
        kazeS, ...
        kazeTheta ...
        );

    fprintf("\t \t Extracting ORB features... ");
    [orbTransformedFeatures,orbTransformedPoints] = extractFeatures( ...
        transformed_image, ...
        detectORBFeatures(transformed_image) ...
        );
    fprintf("Done\n");

    fprintf("\t \t Estimating ORB geometric transformation... ");
    [~, orbS, orbTheta, ~, ~] = tl_geometric_estimator( ...
        orbFeatures, ...
        orbPoints,  ...
        orbTransformedFeatures, ...
        orbTransformedPoints ...
        );
    fprintf("Done\n");
    clear orbTransformedFeatures orbTransformedPoints;
    fprintf("\t \t Estimated ORB scale=%f and rotate=%f\n", orbS, orbTheta);
    orb_results(transformation_index,:) = tl_result( ...
        transformation_scale, ...
        transformation_rotate, ...
        orbS, ...
        orbTheta ...
        );

    fprintf("\n\n");

    clear orbS orbTheta;
    clear kazeS kazeTheta;
    clear transformed_image;
    clear transformation_scale transformation_rotate;
end

clear orbFeatures orbPoints;
clear kazeFeatures kazePoints;
clear transformation_index transformations;
clear input_image;

kaze_results_table = array2table(kaze_results, 'VariableNames', result_labels);
orb_results_table = array2table(orb_results, 'VariableNames', result_labels);

fprintf("KAZE Results\n")
disp(kaze_results_table);
figure('Name', 'KAZE Results', 'NumberTitle', 'off');
uitable('Data', kaze_results_table, ...
    'ColumnName', result_labels, ...
    'Units', 'Normalized', ...
    'Position', [0 0 1 1]);

fprintf("ORB Results\n")
disp(orb_results_table);
figure('Name', 'ORB Results', 'NumberTitle', 'off');
uitable('Data', orb_results_table, ...
    'ColumnName', result_labels, ...
    'Units', 'Normalized', ...
    'Position', [0 0 1 1]);

clear kaze_results_table orb_results_table result_labels;