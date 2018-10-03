%% DeepCWC.m
% Deep CWC implementation by a multi-level schema.

algName = 'DeepCWC';

numOfAllTest=size(testData,1);
numOfAllTrain=size(trainData,1);

%% Split training set based on folds
if ~exist('numOfTrainUnit','var')
    numOfTrainUnit=numOfTrain;
end
%numOfTrainUnit=3; % the train number in each step
if numOfTrainUnit>=numOfTrain
    numOfIterations = 1;
    numOfTrainUnit = numOfTrain;
else
    numOfIterations=ceil(numOfTrain / numOfTrainUnit);
end
dropouts = floor((1/numOfIterations)*numOfClasses);
%numOfIterations=5;
%fprintf('Running in %d iterations. \n',numOfIterations);

%% CRC iteratively on normal images
errorsCRC=0;
errorsDeepCRC=0;
errorsFusion=0;
disp('CRC on images ... ');
tic
for iter=1:numOfIterations % iteratively calculate contributions
    fprintf('Iteration:\t %d:%d \n',numOfIterations,iter);
    % select train index
    indexOfStart=(iter-1)*numOfTrainUnit+1;
    indexOfEnd  =(iter-0)*numOfTrainUnit;
    if indexOfEnd>numOfTrain 
        indexOfEnd=numOfTrain;
    end
    % numOfCurrentTrainUnit may be less than numOfTrainUnit
    numOfCurrentTrainUnit=indexOfEnd-indexOfStart+1;
    % prepare train data
    clear trainDataFold;
    clear trainDataDeepFold;
    for cc=1:numOfClasses % pick from each class
        foldStart=(cc-1)*numOfCurrentTrainUnit+1;
        foldEnd  =cc*numOfCurrentTrainUnit;
        trainStart=(cc-1)*numOfTrain+1;
        trainEnd  =trainStart+numOfCurrentTrainUnit-1;
        % 1. orignal images
        trainDataFold(foldStart:foldEnd,:)=trainData(trainStart:trainEnd,:);
        % 2. deep features
        trainDataDeepFold(foldStart:foldEnd,:)=trainDataDeep(trainStart:trainEnd,:);
    end
    %trainDataFold =trainData(indexOfStart:indexOfEnd,:); % train using one fold
    clear preserved; % (T*T'+aU)-1 * T
    preserved=inv(trainDataFold*trainDataFold'+0.01*eye(numOfClasses*numOfCurrentTrainUnit))*trainDataFold;
    clear preservedDeep; % (T*T'+aU)-1 * T
    preservedDeep=inv(trainDataDeepFold*trainDataDeepFold'+0.01*eye(numOfClasses*numOfCurrentTrainUnit))*trainDataDeepFold;
    clear solutionCRC;
    clear deviationCRC;
    clear solutionDeepCRC;
    clear deviationDeepCRC;
    clear deviationFusionCRC;
    for kk=1:numOfAllTest
        % 1. orignal images
        testSample=testData(kk,:);
        solutionCRC=preserved*testSample'; % CRC (T*T'+aU)^-1 * T * D(i)'
        % 2. deep features
        deepTestSample=testDataDeep(kk,:);
        solutionDeepCRC=preservedDeep*deepTestSample'; % CRC (T*T'+aU)^-1 * T * D(i)'
        for cc=1:numOfClasses
            if exist('isRGB','var') && isRGB==1
                contributionCRC(:,cc)=zeros(row*col*3,1);
            else % grey data
                contributionCRC(:,cc)=zeros(row*col,1);
            end
            contributionDeepCRC(:,cc)=zeros(dim,1);
            for tt=1:numOfCurrentTrainUnit % C(i) = sum(S(i)*T)
                contributionCRC(:,cc) = contributionCRC(:,cc)+solutionCRC((cc-1)*numOfCurrentTrainUnit+tt)*trainDataFold((cc-1)*numOfCurrentTrainUnit+tt,:)';
                contributionDeepCRC(:,cc) = contributionDeepCRC(:,cc)+solutionDeepCRC((cc-1)*numOfCurrentTrainUnit+tt)*trainDataDeepFold((cc-1)*numOfCurrentTrainUnit+tt,:)';
            end
            %deviationCRC(cc)=norm(testSample'-contributionCRC(:,cc))/norm(contributionCRC);
            %deviationDeepCRC(cc)=norm(deepTestSample'-contributionDeepCRC(:,cc))/norm(contributionDeepCRC);
            deviationCRC(cc)=norm(testSample'-contributionCRC(:,cc));%/norm(contributionCRC);
            deviationDeepCRC(cc)=norm(deepTestSample'-contributionDeepCRC(:,cc));%/norm(contributionDeepCRC);
        end
        % fusing the deviations
        deviationFusion  = deviationDeepCRC.*deviationCRC/max(deviationCRC);
        % sort the result and be ready to pick candidates
        [orderDeviationCRC    orderCRCLabels]   =sort(deviationCRC,'ascend');
        [orderDeviationDeep   orderDeepLabels]  =sort(deviationDeepCRC,'ascend'); 
        [orderDeviationFusion orderFusionLabels]=sort(deviationFusion,'ascend'); 
        % pick candidates iteratively
        if (iter == 1) % 1st iteration
            if numOfClasses-dropouts>0
                candidateCRCLabels(kk,:)   =orderCRCLabels(1:numOfClasses-dropouts);
                candidateDeepLabels(kk,:)  =orderDeepLabels(1:numOfClasses-dropouts);
                candidateFusionLabels(kk,:)=orderFusionLabels(1:numOfClasses-dropouts);
                numOfLast = numOfClasses-dropouts;
            else
                candidateCRCLabels(kk,:)   =orderCRCLabels;
                candidateDeepLabels(kk,:)  =orderDeepLabels;
                candidateFusionLabels(kk,:)=orderFusionLabels;
            end
        else % 2 - n (th) iterations
            if (iter<numOfIterations) % n-1(th) iterations
                numOfLast = numOfClasses-iter*dropouts;
            end % use the last one when in the last iteration
            tempCadidateLabels = intersect(orderCRCLabels,candidateCRCLabels(kk,1:numOfLast),'stable');
            candidateCRCLabels(kk,1:numOfLast-dropouts)=tempCadidateLabels(1,1:numOfLast-dropouts);
            tempCadidateLabels = intersect(orderDeepLabels,candidateDeepLabels(kk,1:numOfLast),'stable');
            candidateDeepLabels(kk,1:numOfLast-dropouts)=tempCadidateLabels(1,1:numOfLast-dropouts);
            tempCadidateLabels = intersect(orderFusionLabels,candidateFusionLabels(kk,1:numOfLast),'stable');
            candidateFusionLabels(kk,1:numOfLast-dropouts)=tempCadidateLabels(1,1:numOfLast-dropouts);
        end
        if numOfIterations-iter == 0 % perform classification driectly
            %[min_value labelCRC]=min(deviationCRC); % min    
            %numOfLast = size(candidateCRCLabels,2);
            %candidateCRCLabels(kk,:)   =orderCRCLabels(1,1:numOfLast);
            %candidateDeepLabels(kk,:)  =orderDeepLabels(1,1:numOfLast);
            %candidateFusionLabels(kk,:)=orderFusionLabels(1,1:numOfLast);
            labelCRC = candidateCRCLabels(kk,1);
            if labelCRC ~= testLabel(kk)
                errorsCRC=errorsCRC+1;
            end
            labelDeepCRC = candidateDeepLabels(kk,1);
            if labelDeepCRC ~= testLabel(kk)
                errorsDeepCRC=errorsDeepCRC+1;
            end
            labelFusion = candidateFusionLabels(kk,1);
            if labelFusion ~= testLabel(kk)
                errorsFusion=errorsFusion+1;
            end
        end
    end
end
accuracyCRC = 1-errorsCRC/numOfAllTest;
accuracyDeepCRC = 1-errorsDeepCRC/numOfAllTest;
accuracyFusion = 1-errorsFusion/numOfAllTest;
time_CRC = toc;
fprintf('\t Done in %.3f (s) with accuracy=%.4f and iterations=%d\n',time_CRC,accuracyFusion,numOfIterations);

% improvements
baseAccuracy = max(accuracyCRC,accuracyDeepCRC);
improveDist = (accuracyFusion-baseAccuracy)*100/baseAccuracy;
accuracy = accuracyFusion;

% result path
if ~isequal(exist(dbName, 'dir'),7)
    mkdir(dbName);
end

% save to json
jsonFile = [dbName '/' algName '_' num2str(numOfTrain) '_' ];
%jsonFile = [jsonFile num2str(accuracy,'%.4f') '_']; % the best accuracy by our method
jsonFile = [jsonFile num2str(accuracyFusion,'%.4f') '(' num2str(improveDist,'%.1f') '%)_']; % result of fusion in distances
jsonFile = [jsonFile num2str(accuracyCRC,'%.4f') '_' num2str(accuracyDeepCRC,'%.4f')];
jsonFile = [jsonFile  '.json'];
oneResult = [accuracyCRC, accuracyDeepCRC, accuracyFusion, trainIndices];
if ~exist('lastAccuracy','var')
    lastAccuracy = 0;
end
if isTuning==0 || lastAccuracy<accuracy
    lastAccuracy = accuracy;
    if exist('savejson')==2
        dbJson = savejson('', oneResult, jsonFile);
    else
        oneResult %
    end
end