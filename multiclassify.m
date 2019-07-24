function [result] = multiclassify(TrainingSet,GroupTrain,TestSet)

    u=unique(GroupTrain);
    n=length(u);
    result = zeros(length(TestSet(:,1)),1);

    w = warning('off','all');
    %build models
    for k=1:n
        G1vAll=(GroupTrain==u(k));
        models(k) = svmtrain(TrainingSet,G1vAll,'kernel_function','rbf');
    end

    %classify test cases
    for j=1:size(TestSet,1)
        for k=1:n
            if(svmclassify(models(k),TestSet(j,:))) 
                break;
            end
        end
        result(j) = k;
    end
    warning(w);
end