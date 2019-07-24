function result = classifier(testing)
    filename = 'training - Copy.xlsx';
    training = xlsread(filename, 1, 'D:N');
    training_label = xlsread(filename, 1, 'O:O');

    result = multiclassify(training,training_label,testing(1,:));
end