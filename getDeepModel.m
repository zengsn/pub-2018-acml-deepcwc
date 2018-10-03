% getLayerName.m
function deepModel = getDeepModel(modelId)
mmm=modelId; 
if mmm==1
    deepModel = 'VGG_16.fc7';
elseif mmm==2
    deepModel = 'VGG_16.fc6';
elseif mmm==3
    deepModel = 'VGG_16.fc8';
elseif mmm==4
    deepModel = 'VGG_19.fc8';
elseif mmm==5
    deepModel = 'VGG_19.fc7';
elseif mmm==6
    deepModel = 'VGG_19.fc6';
elseif mmm==7
    deepModel = 'Inception_ResNet_v2.Logits';
elseif mmm==8
    deepModel = 'Inception_ResNet_v2.AuxLogits';
elseif mmm==9
    deepModel = 'Inception_ResNet_v2.global_pool';
elseif mmm==10
    deepModel = 'Inception_v4.Logits';
elseif mmm==11
    deepModel = 'Inception_v4.AuxLogits';
elseif mmm==12
    deepModel = 'Inception_v4.global_pool';
elseif mmm==13
    deepModel = 'ResNet_v1_101.logits';
elseif mmm==14
    deepModel = 'ResNet_v1_101.global_pool';
elseif mmm==15
    deepModel = 'ResNet_v1_101.spatial_squeeze';
elseif mmm==16
    deepModel = 'ResNet_v2_101.logits';
elseif mmm==17
    deepModel = 'ResNet_v2_101.global_pool';
elseif mmm==18
    deepModel = 'ResNet_v2_101.spatial_squeeze';
else
    disp('ERROR!!!');
end
end