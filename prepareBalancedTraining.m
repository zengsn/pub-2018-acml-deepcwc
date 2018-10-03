% prepareBalancedTraining.m
%
%numOfAllTrain =
fprintf('numOfAllTrain=%d,\tnumOfAllTest=%d,\tnumOfClasses=%d\n', numOfAllTrain,numOfAllTest,numOfClasses);

%% images or LBP
if useLBP==1
    balancedMat = [path dbName_0 '_' num2str(row) 'x' num2str(col) '_Split_LBP_B.mat'];
else % image
    balancedMat = [path dbName_0 '_' num2str(row) 'x' num2str(col) '_Split_Norm_B.mat'];
end
if exist(balancedMat,'file')==2
    fprintf('Load from %s \n', balancedMat);
    load(balancedMat);
else % load data and reorder them
    indexOfTrain = 1;
    indexOfTest  = 1;
    fprintf('Prepare image data: ');
    for cc=1:numOfClasses
        fprintf('%d, ', cc);
        for trr=1:numOfAllTrain
            label = trainLabel(trr);
            if label == cc
                trainDataB(indexOfTrain,:)=trainData(trr,:);
                trainLabelB(1,indexOfTrain)=label;
                indexOfTrain = indexOfTrain + 1;
            end
        end
        for tee=1:numOfAllTest
            label = testLabel(tee);
            if label == cc
                testDataB(indexOfTest,:)=testData(tee,:);
                testLabelB(1,indexOfTest)=label;
                indexOfTest = indexOfTest + 1;
            end
        end
    end
    fprintf('done.\n');
    trainData = trainDataB;
    trainLabel_0=trainLabel;
    trainLabel= trainLabelB;
    testData  = testDataB;
    testLabel_0= testLabel;
    testLabel = testLabelB;
    dbName_1 = dbName;
    dbName   = dbName_0;
    save(balancedMat,'dbName','row','col','numOfClasses','trainData','trainLabel','trainLabel_0','numOfAllTrain','testData','testLabel','testLabel_0','numOfAllTest');
    dbName   = dbName_1;
end
%% deep features
if useDeep == 1
    dbName   = [dbName_0 '.' deepModel];
    balancedMat = [h5Path dbName_0 '_' num2str(row) 'x' num2str(col) '_Split_Norm_B_' deepModel '.mat'];
    if exist(balancedMat,'file')==2
        fprintf('Load from %s \n', balancedMat);
        load(balancedMat);
    else % load data and reorder them
        indexOfTrain = 1;
        indexOfTest  = 1;
        fprintf('Prepare deep features: ');
        for cc=1:numOfClasses
            fprintf('%d, ', cc);
            for trr=1:numOfAllTrain
                label = trainLabel_0(trr);
                if label == cc
                    %trainLabelB(1,indexOfTrain)=label;
                    trainDataDeepB(indexOfTrain,:)=trainDataDeep(trr,:);
                    indexOfTrain = indexOfTrain + 1;
                end
            end
            for tee=1:numOfAllTest
                label = testLabel_0(tee);
                if label == cc
                    %testLabelB(1,indexOfTest)=label;
                    testDataDeepB(indexOfTest,:)=testDataDeep(tee,:);
                    indexOfTest = indexOfTest + 1;
                end
            end
        end
        fprintf('done.\n');
        trainDataDeep = trainDataDeepB;
        testDataDeep  = testDataDeepB;
        save(balancedMat,'dbName','row','col','numOfClasses','trainDataDeep','trainLabel','numOfAllTrain','testDataDeep','testLabel','numOfAllTest');
    end
end
disp('Balanced training is ready.')