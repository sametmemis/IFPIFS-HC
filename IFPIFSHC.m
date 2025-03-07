%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% S. Memiş, B. Arslan, T. Aydın, S. Enginoğlu, Ç. Camcı, (2021). A Classification Method
% Based on Hamming Pseudo-Similarity of Intuitionistic Fuzzy Parameterized
% Intuitionistic Fuzzy Soft Matrices. Journal of New Results in Science, 10(2), 59-76.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abbreviation of Journal Title: J. New Results in Sci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://dergipark.org.tr/en/pub/jnrs/issue/64701/981326
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.researchgate.net/profile/Samet_Memis2
% https://www.researchgate.net/profile/Burak-Arslan-15
% https://www.researchgate.net/profile/Tugce-Aydin
% https://www.researchgate.net/profile/Serdar_Enginoglu2
% https://www.researchgate.net/profile/Cetin-Camci
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Demo: 
% clc;
% clear all;
% DM = importdata('Wine.mat');
% [x,y]=size(DM);
% 
% data=DM(:,1:end-1);
% class=DM(:,end);
% if prod(class)==0
%     class=class+1;
% end
% k_fold=5;
% cv = cvpartition(class,'KFold',k_fold);
%     for i=1:k_fold
%         test=data(cv.test(i),:);
%         train=data(~cv.test(i),:);
%         T=class(cv.test(i),:);
%         C=class(~cv.test(i),:);
%     
%         sIFPIFSHC=IFPIFSHC(train,C,test,5,0.5);
%         accuracy(i,:)=sum(sIFPIFSHC==T)/numel(T);
%     end
% mean_accuracy=mean(accuracy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PredictedClass=IFPIFSHC(train,C,test,lambda1,lambda2)
[em,en]=size(train);
[tm,n]=size(test);
  for j=1:en
      ifwP(1,j,1)=1-(1-abs(corr(train(:,j),C,'Type','Pearson','Rows','complete')))^lambda1;
      ifwP(1,j,2)=(1-abs(corr(train(:,j),C,'Type','Pearson','Rows','complete')))^(lambda1*(lambda1+1));
  end
  ifwP(isnan(ifwP))=0;

data=[train;test];
for j=1:n
    data(:,j,1)=(1-(1-normalise(data(:,j))).^lambda2);
    data(:,j,2)=(1-normalise(data(:,j))).^(lambda2*(lambda2+1));
end

clear train test;
train(:,:,:)=data(1:em,:,:);
test(:,:,:)=data(em+1:end,:,:);

for k=1:tm
    a(:,:,1)=[ifwP(1,:,1) ; test(k,:,1)];
    a(:,:,2)=[ifwP(1,:,2) ; test(k,:,2)];
    for l=1:em
        b(:,:,1)=[ifwP(1,:,1) ; train(l,:,1)];
        b(:,:,2)=[ifwP(1,:,2) ; train(l,:,2)];
        Sr(l)=ifpifsHs(a,b);         
    end    
    [~,w]=max(Sr);
    PredictedClass(k,1)=C(w);
    
end
end

function na=normalise(a)
[m,n]=size(a);
    if max(a)~=min(a)
        na=(a-min(a))/(max(a)-min(a));
    else
        na=ones(m,n);
    end
end                                                                                                                                                                  

% Hamming pseudo similarity over ifpifs-matrices
function X=ifpifsHs(a,b)
if size(a)~=size(b)
else
[m,n,~]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j,1)*a(i,j,1)-b(1,j,1)*b(i,j,1))+abs(a(1,j,2)*a(i,j,2)-b(1,j,2)*b(i,j,2))+abs((1-a(1,j,1)-a(1,j,2))*(1-a(i,j,1)-a(i,j,2))-(1-b(1,j,1)-b(1,j,2))*(1-b(i,j,1)-b(i,j,2)));
    end
  end
  X=1-(d/(2*(m-1)*n));
end
end
