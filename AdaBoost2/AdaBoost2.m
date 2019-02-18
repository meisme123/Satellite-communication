%https://www.mathworks.com/examples/statistics/community/36325-adaboost-demo
tic
clc; clear all
data=xlsread('file.xlsx');
disp(length(data))

[trset,teset ] = holdout(data,80);

X=trset(:,1:end-1);Y=trset(:,end);
Xtest=teset(:,1:end-1);Ytest=teset(:,end);
figure
hold on
scatter(X(Y==1,1),X(Y==1,2),'+')
scatter(X(Y==-1,1),X(Y==-1,2),'.')
xlabel('{x_1}')
ylabel('{x_2}')
zlabel('{x_3}')
legend('Positive Class','Negative Class')
title('Data for classification')
hold off

[x1 x2]=meshgrid(min(X(:,1)):0.01:max(X(:,1)),min(X(:,2)):0.01:max(X(:,2)));
Xn=[reshape(x1,1,size(x1,2)*size(x1,1))' reshape(x2,1,size(x2,2)*size(x2,1))'];

gda_in=fitcdiscr(X,Y);
gda_out=predict(gda_in, Xtest);

[Fmeasure(1),Accuracy(1)] = confusion_mat(Ytest, gda_out);
Fmeasure_GDA=Fmeasure(1)

Accuracy_GDA=Accuracy(1)

yn=predict(gda_in,X);
%Yn=reshape(yn,size(x1));
DecisionBoundry( X,Y,yn )
title('Decision Boundry due to GDA')


knn_in=fitcknn(X,Y,'NumNeighbors',5);
knn_out=predict(knn_in, Xtest);

[Fmeasure(2),Accuracy(2)] = confusion_mat(Ytest, knn_out);
Fmeasure_knn=Fmeasure(2)

Accuracy_knn=Accuracy(2)

yn=predict(knn_in,X);
%Yn=reshape(yn,size(x1));
DecisionBoundry( X,Y,yn )
title('Decision Boundry due to knn')




%nb_in=fitcnb(X,Y);
%nb_out=predict(nb_in, Xtest);
%[Fmeasure(3),Accuracy(3)] = confusion_mat(Ytest, nb_out);
%Fmeasure_NB=Fmeasure(3)
%Accuracy_NB=Accuracy(3)
%yn=predict(nb_in,Xn);
%Yn=reshape(yn,size(x1));
%DecisionBoundry( X,Y,Yn)
%title('Decision Boundry due to Naive bayes')


% Choose best in maxItr number of iterations
maxItr=50;
fm_=[];
for itr=1:maxItr
    [~,ada_test(:,itr)]= adaboost(X,Y, Xtest);
    fm_=[fm_; confusion_mat(Ytest, ada_test(:,itr))];
end
[fm itr]=max(fm_);
ada_out=ada_test(:,itr);

[Fmeasure(6),Accuracy(6)] = confusion_mat(Ytest, ada_out);
Fmeasure_AdaBoost=Fmeasure(6)
Accuracy_AdaBoost=Accuracy(6)

[~,yn]=adaboost(X,Y,X);

%Yn=reshape(yn,size(x1));
DecisionBoundry( X,Y,yn )
title('Decision Boundry due to AdaBoost')

figure
hold on
plot(Fmeasure,'-^')
plot(Accuracy,'--o')
text(6,0.5*(Fmeasure(6)+Accuracy(6)),'\leftarrow AdaBoost')
axis square
xlabel('Different classifiers')
ylabel('F-measure, Accuracy \rightarrow')
hold off

toc
