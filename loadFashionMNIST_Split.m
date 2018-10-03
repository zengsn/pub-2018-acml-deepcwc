% loadFashionMNIST.m

dbName = 'FashionMNIST';
row=28;
col=28;

%
%path = '../../Lab0_Data/';
path = '/Volumes/SanDisk128B/datasets-mat/';
splitMat  = [path dbName '_' num2str(row) 'x' num2str(col) '_Split.mat'];
normedMat = [path dbName '_' num2str(row) 'x' num2str(col) '_Split_Norm.mat'];

if exist(normedMat,'file')==2
    fprintf('Load from %s \n', normedMat);
    load(normedMat);
else % load data and normed them
    if exist(splitMat, 'file') == 2
        fprintf('Load data from %s \n', splitMat);
        load(splitMat);
    else % load original dataset
        addpath('../../Lab0_Data/mnistHelper');
        %oriPath = '../../Lab0_Data/fashion-mnist/';
        oriPath = '/Volumes/SanDisk128B/datasets0/fashion-mnist/';
        trainImages = loadMNISTImages([oriPath 'train-images-idx3-ubyte']);
        trainLabel = loadMNISTLabels([oriPath 'train-labels-idx1-ubyte']);
        trainLabel = trainLabel';
        numOfAllTrain=size(trainLabel,2);
        trainData =trainImages';
        trainLabel=trainLabel+1;
        numOfClasses=max(trainLabel); % 10
        % load orignal test data
        testImages = loadMNISTImages([oriPath 't10k-images-idx3-ubyte']);
        testLabel  = loadMNISTLabels([oriPath 't10k-labels-idx1-ubyte']);
        testLabel  = testLabel';
        numOfAllTest = size(testLabel,2);
        testData=testImages';
        testLabel=testLabel+1;
        %minSamples=
        
        clear trainImages;
        clear testImages;
    
        % save
        save(splitMat, 'dbName','row', 'col', 'numOfClasses', 'numOfAllTrain', 'trainData', 'trainLabel', 'numOfAllTest', 'testData', 'testLabel');
        
    end
    
    % norm    
    for tt=1:numOfAllTrain % norm
        oneSample=trainData(tt,:);
        trainData(tt,:)=oneSample/norm(oneSample);
    end
    for te=1:numOfAllTest % norm
        oneSample=testData(te,:);
        testData(te,:)=oneSample/norm(oneSample);
    end
    
    % save
    save(normedMat,'dbName','row','col','numOfClasses','trainData','trainLabel','numOfAllTrain','testData','testLabel','numOfAllTest');
end

minTrain=6000;
maxTrain=6000;
trainStep=1000;
numOfTrain=minTrain;