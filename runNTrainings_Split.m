% runNTrainings.m
% Run experiment with different number of training samples

clear all;
useDeep = 1;
useLBP  = 0;
numOfTrainUnit=2000;

%% Load original data
%loadMNIST_Split;
loadFashionMNIST_Split;
%isLocal = 1;
%loadCIFAR10RGB_Split;
%loadCIFAR100RGB_Split;
%loadSTL10RGB_Split;
%loadSVHN_Split;
%loadUCLandUse;

if useDeep==1 % deep features
    % ResNet_v1_101.global_pool
    deepModel = getDeepModel(14);
    %deepModel = getDeepModel(2);
    loadCNNH5Data_Split;
else
    dbName_0=dbName;
end

%
if useLBP == 1
    loadLBPFeatures;
end
prepareBalancedTraining;

% prepare result path
resultPath = dbName;
if ~isequal(exist(resultPath, 'dir'),7)
    mkdir(resultPath);
end

%% run test cases
DeepCWC;


