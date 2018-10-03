% loadCNNH5Data_Split.m

%% load deep learning features
%h5Path = '../../Lab0_Data/';
h5Path = '/Volumes/SanDisk128B/datasets-h5/';
dbName_0 = dbName;
dbName   = [dbName_0 '.' deepModel];
if ~exist('h5Name','var')
    h5Name = dbName_0;
    h5Row  = row;
    h5Col  = col;
end
normedMat = [h5Path h5Name '_' num2str(row) 'x' num2str(col) '_Split_Norm_' deepModel];
if exist('isLocal','var') && isLocal==1
    normedMat = [normedMat '_local.mat'];
else
    normedMat = [normedMat '.mat'];
end
if exist(normedMat,'file')==2
    fprintf('Load from %s \n', normedMat);
    load(normedMat);
else % load data and normed them
    if exist('isLocal','var') && isLocal==1
        trainDataDeep = loadH5Data(h5Name,h5Row,h5Col,deepModel,h5Path,'local.Train');
        testDataDeep  = loadH5Data(h5Name,h5Row,h5Col,deepModel,h5Path,'local.Test');
    else
        trainDataDeep = loadH5Data(h5Name,h5Row,h5Col,deepModel,h5Path,'Train');
        testDataDeep  = loadH5Data(h5Name,h5Row,h5Col,deepModel,h5Path,'Test');
    end
    dim = size(trainDataDeep,2);
    % norm  
    fprintf('Norm train:\t 1');
    for tt=1:numOfAllTrain % norm
        if mod(tt,1000)==0            
            fprintf(', %d', tt);
        end
        oneSample=double(trainDataDeep(tt,:));
        trainDataDeepN(tt,:)=oneSample/norm(oneSample);
    end
    fprintf('\n');
    fprintf('Norm test:\t 1');
    for te=1:numOfAllTest % norm
        if mod(te,1000)==0            
            fprintf(', %d', te);
        end
        oneSample=double(testDataDeep(te,:));
        testDataDeepN(te,:)=oneSample/norm(oneSample);
    end
    fprintf('\n');
    trainDataDeep = trainDataDeepN;
    testDataDeep  = testDataDeepN;
    % save
    save(normedMat,'dbName','dbName_0','trainDataDeep','testDataDeep', 'dim');
end


%%
function dataDeep = loadH5Data(dbName,row,col,deepModel,path, trainOrTest)
h5File = ['.' lower(deepModel) '.' trainOrTest '.h5'];
h5     = [dbName '_' num2str(row) 'x' num2str(col) h5File];
layer  = getLayerName(deepModel);
fprintf('read h5 file: %s \n', [path h5]);
h5Data = h5read([path h5], layer);
h5disp([path h5], layer);
%dim = size(h5Data,1);
dimOfData = size(size(h5Data),2);
if dimOfData==2
    numOfAllSamples=size(h5Data,2);
    for ii=1:numOfAllSamples
        dataDeep(:,ii)=h5Data(:,ii);
    end
elseif dimOfData==4
    numOfAllSamples=size(h5Data,4);
    for ii=1:numOfAllSamples
        dataDeep(:,ii)=h5Data(:,1,1,ii);
    end
else
    disp('Unknown dim of data.');
end
dataDeep = dataDeep';
clear h5Data;
end