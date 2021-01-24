% % The code is used to predict all the unlabeled set, and list the top-ten

nflag=0;

dec_un=cell(1,fp_n);
dec_un{1,1}=zeros(z_unlabel,1);
dec_un{1,2}=zeros(z_unlabel,1);
dec_un{1,3}=zeros(z_unlabel,1);

for qx=1:z_unlabel
    qx;
    for t=1:fp_n
        t;
        [pre,acc,dec_un{1,t}(qx,1)]=svmpredict(zeros(1,1),[Fea{t,5}(Fea{t,2}(qx,1)-1,:),Fea{t,6}(Fea{t,2}(qx,2)-1,:)],model{1,t},strcat('-q'));
    end
end

dec_unlabel=dec_un{1,1}*w1+dec_un{1,2}*w2+dec_un{1,3}*w3;
dec_unlabel=[(1:z_unlabel)',dec_unlabel];
[ms,ns]=sort(dec_unlabel(:,2));
dec_unlabel=dec_unlabel(ns,:);

posseq=dec_unlabel((z_unlabel-9):z_unlabel,1);

UNL_NAME(posseq,:)                          % Top ten drug-target pairs
dec_unlabel((z_unlabel-9):z_unlabel,2)      % decision values of top ten drug-target pairs