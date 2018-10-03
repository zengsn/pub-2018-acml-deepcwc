% getLayerName.m
function layerName = getLayerName(deepModel)
if strcmp(deepModel,'ResNet_v1_101.logits')    % ResNet_v1_101
    layerName='/resnet_v1_101/logits';
elseif strcmp(deepModel,'ResNet_v1_101.global_pool')    % ResNet_v1_101
    layerName='/global_pool';
elseif strcmp(deepModel,'ResNet_v1_101.spatial_squeeze')    % ResNet_v1_101
    layerName='/resnet_v1_101/spatial_squeeze';
elseif strcmp(deepModel,'ResNet_v2_101.logits')% ResNet_v2_101
    layerName='/resnet_v2_101/logits';
elseif strcmp(deepModel,'ResNet_v2_101.global_pool')    % ResNet_v1_101
    layerName='/global_pool';
elseif strcmp(deepModel,'ResNet_v2_101.spatial_squeeze')    % ResNet_v1_101
    layerName='/resnet_v2_101/spatial_squeeze';
elseif strcmp(deepModel,'Inception_v4.Logits') % Inception-v4
    layerName='/Logits';
elseif strcmp(deepModel,'Inception_v4.AuxLogits') % Inception-v4
    layerName='/AuxLogits';
elseif strcmp(deepModel,'Inception_v4.global_pool') % Inception-v4
    layerName='/global_pool';
elseif strcmp(deepModel,'Inception_ResNet_v2.Logits') % Inception-v4
    layerName='/Logits';
elseif strcmp(deepModel,'Inception_ResNet_v2.AuxLogits') % Inception-v4
    layerName='/AuxLogits';
elseif strcmp(deepModel,'Inception_ResNet_v2.global_pool') % Inception-v4
    layerName='/global_pool';
elseif strcmp(deepModel,'VGG_16.fc8') % vgg_16
    layerName='/vgg_16/fc8';
elseif strcmp(deepModel,'VGG_16.fc7') % vgg_16
    layerName='/vgg_16/fc7';
elseif strcmp(deepModel,'VGG_16.fc6') % vgg_16
    layerName='/vgg_16/fc6';
elseif strcmp(deepModel,'VGG_19.fc8') % vgg_16
    layerName='/vgg_19/fc8';
elseif strcmp(deepModel,'VGG_19.fc7') % vgg_16
    layerName='/vgg_19/fc7';
elseif strcmp(deepModel,'VGG_19.fc6') % vgg_16
    layerName='/vgg_19/fc6';
else
    disp(['Unknown model: ' deepModel]);
    layerName = 'Unknown';
end
end