% % The code is used to optimized predictions based on Weight-sequence

for t=1:fp_n
    model{1,t}=svmtrain(Train_label,Train{1,t},strcat(['-t 2 -c ',num2str(2^(c)), ' -g ',num2str(2^(gamma)),' -w1 1 -w-1 1 -h 0 -q']));
    if cluster_index==0
        [pre_vali{1,t},acc_vali{1,t},dec_vali{1,t}]=svmpredict(Vali_label,Vali{1,t},model{1,t},strcat('-q'));
    elseif cluster_index==1
        Vali_label=Cluster_label;
        [pre_cvali_1{1,t},acc_cvali_1{1,t},dec_cvali_1{1,t}]=svmpredict(Cluster_label,Cluster_1{1,t},model{1,t},strcat('-q'));
    elseif cluster_index==2
        Vali_label=Cluster_label;
        [pre_cvali_2{1,t},acc_cvali_2{1,t},dec_cvali_2{1,t}]=svmpredict(Cluster_label,Cluster_2{1,t},model{1,t},strcat('-q'));
    else
        Vali_label=Cluster_label;
        [pre_cvali_3{1,t},acc_cvali_3{1,t},dec_cvali_3{1,t}]=svmpredict(Cluster_label,Cluster_3{1,t},model{1,t},strcat('-q'));
    end
    [pre_test{1,t},acc_test{1,t},dec_test{1,t}]=svmpredict(Test_label,Test{1,t},model{1,t},strcat('-q'));
end
Optim_AUC=[];
if cluster_index==0
    dec_op=dec_vali;
elseif cluster_index==1
    dec_op=dec_cvali_1;
elseif cluster_index==2
    dec_op=dec_cvali_2;
else
    dec_op=dec_cvali_3;
end

for w1=0:0.1:1              % Weight-sequence       
    for w2=0:0.1:(1-w1)
        dec=w1*dec_op{1,1}+w2*dec_op{1,2}+(1-w1-w2)*dec_op{1,3};
        decT=w1*dec_test{1,1}+w2*dec_test{1,2}+(1-w1-w2)*dec_test{1,3};
        para_test=AUC_cal(decT,Test_label);
        Optim_AUC=[Optim_AUC;[w1,w2,(1-w1-w2),AUC_cal(dec,Vali_label),para_test]];
    end
end
[r,loc]=max(Optim_AUC(:,4));
w1=Optim_AUC(loc,1);
w2=Optim_AUC(loc,2);
w3=Optim_AUC(loc,3);
[w1,w2,w3]          % the optimized weight vector in this code
decV=w1*dec_op{1,1}+w2*dec_op{1,2}+w3*dec_op{1,3};
[para_vali,xx_vali,yy_vali,tp,tn,fp,fn]=AUC_cal(decV,Vali_label);
decT=w1*dec_test{1,1}+w2*dec_test{1,2}+w3*dec_test{1,3};
[para_test,xx_test,yy_test,tp,tn,fp,fn]=AUC_cal(decT,Test_label);
[para_vali,para_test]   % the optimized prediction for validation and test set

% % plot(xx_vali,yy_vali);hold on
% % plot(xx_test,yy_test);hold off
