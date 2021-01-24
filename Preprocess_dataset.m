% % The code is used to generate "train", "validation" and "test" for models

z_pos=size(Pos_set,1);
z_unlabel=size(Unlabel_set,1);
cn=3;   % cn=3 is the number of clusters in kmeans

% divide with 3:1:1, that are Train:Vali:Test
[postrain_seq,posvali_seq,postest_seq]=Fold_div_vali((1:z_pos)',5);
[negtrain_seq,negvali_seq,negtest_seq]=Fold_div_vali((1:z_pos)',5);


z_train=size(postrain_seq,1);
z_vali=size(posvali_seq,1);z_c_vali=ceil(z_vali/cn);  
z_test=size(postest_seq,1);


Train_label=[ones(z_train,1);zeros(z_train,1)];
Vali_label=[ones(z_vali,1);zeros(z_vali,1)];
Test_label=[ones(z_test,1);zeros(z_test,1)];
Cluster_label=[ones(z_vali,1);zeros(z_c_vali*cn,1)];

model=cell(1,fp_n);
Train=cell(1,fp_n);
Vali=cell(1,fp_n);
C_Vali_1=cell(1,fp_n);C_Vali_2=cell(1,fp_n);C_Vali_3=cell(1,fp_n); 
Cluster_1=cell(1,fp_n);Cluster_2=cell(1,fp_n);Cluster_3=cell(1,fp_n);
C_Vali_class=cell(1,fp_n);
Test=cell(1,fp_n);

Train_S=cell(1,fp_n);
Vali_S=cell(1,fp_n);
Test_S=cell(1,fp_n);

Vali_neg=cell(1,fp_n);
Test_neg=cell(1,fp_n);

Vali_NEG_multi=[];
Test_NEG_multi=[];

dec_op=cell(1,fp_n);    
dec_test=cell(1,fp_n);


for t=1:fp_n
    Vali_neg{1,t}=Fea{t,4}(negvali_seq,:);      
    Vali_NEG_multi=[Vali_NEG_multi;Vali_neg{1,t}];  % union of all validation negative samples
    Test_neg{1,t}=Fea{t,4}(negtest_seq,:);
    Test_NEG_multi=[Test_NEG_multi;Test_neg{1,t}];  % union of all test negative samples
end
Vali_Adjust=ran_select(Vali_NEG_multi,z_vali,2);    % random select negative samples from Validation
Test_Adjust=ran_select(Test_NEG_multi,z_test,2);    % random select negative samples from Test

Cluster_generate;       % generate cluster validation based on cluster_index

for t=1:fp_n
    Vali_S{1,t}=Fea{t,1}(posvali_seq,:);            % (Validation) positive descriptors are recorded
    Vali{1,t}=[[Fea{t,5}(Vali_S{1,t}(:,1)-1,:),Fea{t,6}(Vali_S{1,t}(:,2)-1,:)];[Fea{t,5}(Vali_Adjust(:,1)-1,:),Fea{t,6}(Vali_Adjust(:,2)-1,:)]];    % (Validation) negative descriptors are recorded
    Test_S{1,t}=Fea{t,1}(postest_seq,:);            % (Test) positive descriptors are recorded
    Test{1,t}=[[Fea{t,5}(Test_S{1,t}(:,1)-1,:),Fea{t,6}(Test_S{1,t}(:,2)-1,:)];[Fea{t,5}(Test_Adjust(:,1)-1,:),Fea{t,6}(Test_Adjust(:,2)-1,:)]];    % (Test) negative descriptors are recorded
    Train_S{1,t}=[Fea{t,1}(postrain_seq,:);Fea{t,4}(negtrain_seq,:)];               % (Train) positive descriptors are recorded
    Train{1,t}=[Fea{t,5}(Train_S{1,t}(:,1)-1,:),Fea{t,6}(Train_S{1,t}(:,2)-1,:)];   % (Train) negative descriptors are recorded
end
