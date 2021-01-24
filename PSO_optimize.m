% The code is used to optimized prediction based on PSO


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

if cluster_index==0
    dec_op=dec_vali;
elseif cluster_index==1
    dec_op=dec_cvali_1;
elseif cluster_index==2
    dec_op=dec_cvali_2;
else
    dec_op=dec_cvali_3;
end


z_pso=size(dec_op{1,1},1);
G=[];
P=[];

dim=fp_n;
num_seed=20*dim+1;      % the number of particles

pbest=zeros(num_seed,1);
plocation=zeros(dim,num_seed);
seed=zeros(dim,num_seed);
vi=zeros(dim,num_seed);
for k=1:num_seed
    vi(:,k)=rand(dim,1);           % initialize speed for each seeds
    vi(:,k)=vi(:,k)/sum(vi(:,k));
    seed(:,k)=rand(dim,1);         % initialize location for each seeds
    seed(:,k)=seed(:,k)/sum(seed(:,k));
end
Q=zeros(num_seed,1001);
for i=1:num_seed
    dec=zeros(z_pso,1);
    for j=1:dim
        dec(:,1)=dec(:,1)+seed(j,i)*dec_op{1,j};
    end
    pbest(i,1)=pbest(i,1)+AUC_cal(dec(:,1),Vali_label);     % initialize the local-best
    pbest(i,1)=pbest(i,1)/5;
    Q(i,1)=pbest(i,1);
    plocation(:,i)=seed(:,i);
end
[gbest,loc]=max(pbest);         % initialize the global-best
glocation=seed(:,loc);
V=zeros(dim,1);

w=1;c1=2;c2=2;      % initialize parameters in PSO

% % Update pbest and gbest in PSO

P=[P,pbest];
G=[G,gbest];
DREA=zeros(dim,100);
for flag=1:100
    flag;
    for i=1:num_seed
        V=w*V+c1*rand(1,1)*(plocation(:,i)-seed(:,i))+c2*rand(1,1)*(glocation-seed(:,i));
        V=V/max((max(V)-min(V)),sum(V));
        seed(:,i)=seed(:,i)+V;
        seed(:,i)=seed(:,i)/max((max(seed(:,i))-min(seed(:,i))),sum(seed(:,i)));
        dec=zeros(z_pso,5);
        t=0;
        for j=1:dim
            if seed(j,i)<0
                seed(j,i)=0;
                V(j)=-V(j);
            elseif seed(j,i)>1
                seed(j,i)=1;
                V(j)=-V(j);
            end
            dec(:,1)=dec(:,1)+seed(j,i)*dec_op{1,j};
        end
        t=t+AUC_cal(dec(:,1),Vali_label);
        Q(i,flag+1)=t;
        if t>pbest(i,1)
            pbest(i,1)=t;
            plocation(:,i)=seed(:,i);
        end
    end
    [m,loc]=max(pbest);
    if m>gbest
        gbest=m;
        glocation=seed(:,loc);
    end
    DREA(:,flag)=glocation;
    P=[P,pbest];
    G=[G,gbest];
end
% plot(1:101,P);hold on
% plot(1:101,G);hold off

w1=glocation(1,1);
w2=glocation(2,1);
w3=glocation(3,1);
[w1,w2,w3]          % the optimized weight vector
decV=w1*dec_op{1,1}+w2*dec_op{1,2}+w3*dec_op{1,3};
[para_vali,xx_vali,yy_vali,tp,tn,fp,fn]=AUC_cal(decV,Vali_label);
decT=w1*dec_test{1,1}+w2*dec_test{1,2}+w3*dec_test{1,3};
[para_test,xx_test,yy_test,tp,tn,fp,fn]=AUC_cal(decT,Test_label);
[gbest,para_test]   % the optimized prediction for validation and test



% % plot(xx_vali,yy_vali);hold on
% % plot(xx_test,yy_test);hold off
