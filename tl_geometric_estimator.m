function [T, s, theta, tx, ty] = tl_geometric_estimator( ...
    features, ...
    points, ...
    transformedFeatures, ...
    transformedPoints ...
    )
% Match common features and get the index pairs
[indexPairs, ~] = matchFeatures(features, transformedFeatures);

% Get matched points from points
matchedPoints = points(indexPairs(:,1), :);

% Get matched points from transformedPoints
matchedTransformedPoints = transformedPoints(indexPairs(:,2), :);

% Get the T table that contains the estimated geometric transformation
% between the matchedPoints (original image) and matchedTransformedPoints
% (transformed image) using the similarity method.
T = estimateGeometricTransform( ...
    matchedPoints, ...
    matchedTransformedPoints, ...
    'similarity' ...
    ).T;

% The T is a 3x3 table, with the following format
% sc    -ss     0
% ss     sc     0
% tx     ty     1

sc = T(1,1);
ss = T(2,1);

% Calculate the s (scale)
s = sqrt(sc^2 + ss^2);

% Calclate the theta (angle in degrees)
theta = rad2deg(atan2(ss, sc));

tx = T(3,1);
ty = T(3,2);
end