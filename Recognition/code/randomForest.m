
trainSet=1;
validSet=2;
features = extractDigitFeatures(data.x,'lbp');
B=TreeBagger(500,features(:, data.set==trainSet)', data.y(data.set==trainSet)');

predictions= str2num(cell2mat(B.predict(features(:,data.set==testSet)')))';

trueLabels = data.y(data.set==testSet);

accuracy = length(find(predictions==trueLabels))/length(predictions==trueLabels)
