% The code is used in Fusion-MFP to predict drug-target interactions
% The gold standard dataset used can be download at http://web.kuicr.kyoto-u.ac.jp/supp/yoshi/drugtarget/
% drug descriptors are obtained by PaDEL-Descriptor (version-2.21) (http://padel.nus.edu.sg)
% target descritpros are obtained by PROFEAT (http://bidd2.nus.edu.sg/)
% libsvm (version-3.23) is used in this code (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
% The "filepath_drug" and "filepath_target" in "feature_check" should be changed according the location of your "drug/target descriptor file"


clear
% The file "Adjacency matrix of the gold standard drug-target interaction
% data" are used in this codes, and are renamed with their subdataset name.

% % % % % % % % % % % % % % % %
% %  subdataset and parameters selection 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % cluster_index=0, means that random cross validation is used
% % cluster_index=1, means that cluster (kmeans) cross validation is based on feature pair 1
% % cluster_index=2, means that cluster (kmeans) cross validation is based on feature pair 2
% % cluster_index=3, means that cluster (kmeans) cross validation is based on feature pair 3
% % The cluster_index had been optimized based on their mean and standard deviation of predictions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % The "M" listed below make the code easier to run, 
% % and they can also be obtained from the function "Feature_screen"
% % If the function "Feature_screen" is used, you can ignore the "M" below.
% % For Enzyme,thre=[0,0,0] [rate_12,rate_13,rate_23]
% % For GPCR,thre=[0.0142,0,0.0110]
% % For Ion channel,thre=[0,0.0407,0.0339]
% % For Nuclear receptor,thre=[0,0,0] 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % These "c" and "gamma" can be obtained by "Parameter_adjust",
% % and also can be used directly with values below
% % If the codes of "Parameter_adjust" is used, you can ignore values below
% % % % % % % % % % % % % % % % 

% NAME='Enzyme';cluster_index=0;M=[1,1;2,3;7,5];c=10;gamma=-7;
% NAME='GPCR';cluster_index=2;M=[1,1;5,5;10,3];c=9;gamma=-6;
NAME='Ion_channel';cluster_index=3;M=[1,5;2,3;8,6];c=10;gamma=-7;
% NAME='Nuclear_receptor';cluster_index=1;M=[1,1;3,3;7,2];c=4;gamma=-10;


fp_n=3;             % define the number of feature pairs used
Fea=cell(fp_n,6);   % "Fea" is used to save the correlated data information

% % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Feature pairs screening
% % 
% % "M" is the arrangement of feature pairs used later
% % thre_1, indicate the coincidence rate between feature pair 1 and feature pair 2
% % thre_2, indicate the coincidence rate between feature pair 1 and feature pair 3
% % thre_3, indicate the coincidence rate between feature pair 2 and feature pair 3
% % % % % % % % % % % % % % % % % % % % % % % % % % 

% [M,thre_1,thre_2,thre_3]=Feature_screen(NAME); 

nflag=0;
for qm=1:fp_n
    dr_i=M(qm,1);
    ta_i=M(qm,2);
    nflag=nflag+1;
    [Pos_set,Neg_set,Unlabel_set,drug_data,target_data,UNL_NAME]=Data_generation(NAME,dr_i,ta_i);   % Generation of basic subdatasets
    Fea{nflag,1}=Pos_set;           % positive samples
    Fea{nflag,2}=Unlabel_set;       % unlabeled samples
    Fea{nflag,3}=size(Pos_set,2);   % number of positive samples
    Fea{nflag,4}=Neg_set;           % negative samples based on distance calculation
    Fea{nflag,5}=drug_data;         % drug features
    Fea{nflag,6}=target_data;       % target features
end

Preprocess_dataset;     % the generation of "train", "validation" and "test"

% % % % % % % % % % % % % % % % % 
% % Parameters adjustment for SVM
% % % % % % % % % % % % % % % % % 

% Parameter_adjust;

% "Weight sequence" and "PSO" are two independent optimization methods in Fusion-MFP
% This means that you can use "weight sequence" or "PSO", or both

% % % % % % % % % % % % % % % % % % % % 
% Optimization based on Weight-sequence
% % % % % % % % % % % % % % % % % % % % 

Weight_optimize;

% % % % % % % % % % % % % % % % % % % % 
% Optimization based on PSO algorithm
% % % % % % % % % % % % % % % % % % % % 

% PSO_optimize;

% % % % % % % % % % % % % % % % % 
% Test for all unlabeled samples
% % % % % % % % % % % % % % % % % 

% Test_Unlabel;
