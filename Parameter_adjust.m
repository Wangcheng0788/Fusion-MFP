% % The code is used to adjust and select the optimized c and gamma in SVM

PARA_adjust=zeros(441,4);
tflag=0;
for c=-10:10
    c;
    for gamma=-10:10
        gamma;
        tflag=tflag+1;
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
        for w1=0:0.1:1
            for w2=0:0.1:(1-w1)
                dec=w1*dec_op{1,1}+w2*dec_op{1,2}+(1-w1-w2)*dec_op{1,3};
                decT=w1*dec_test{1,1}+w2*dec_test{1,2}+(1-w1-w2)*dec_test{1,3};
                para_test=AUC_cal(decT,Test_label);
                Optim_AUC=[Optim_AUC;[w1,w2,(1-w1-w2),AUC_cal(dec,Vali_label),para_test]];
            end
        end
        [r,loc]=max(Optim_AUC(:,4));            % record the highest AUC values
        [r_test,loc]=max(Optim_AUC(:,5)); 
        PARA_adjust(tflag,:)=[c,gamma,r,r_test];
    end
end
[r_p,loc_p]=max(PARA_adjust(:,4));
c=PARA_adjust(loc_p,1);
gamma=PARA_adjust(loc_p,2);
[c,gamma]
