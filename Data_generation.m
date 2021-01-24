function [Pos_set,Neg_set,Unlabel_set,drug_data,target_data,UNL_NAME] = Data_generation(NAME,dr_i,ta_i)
% Function "Data_generation" is used for the generation of Pos_set and Unlabel_set
% based on subdataset named as "NAME" and drug_feature_number (dr_i) and target_feature_number (ta_i)
% Input: NAME = {Enzyme,GPCR,Ion,Nuclear},dr_i = {1,2,...,12},ta_i = {1,2,...,6}
% Output: Pos_set is the positive samples and Unlabel_set is the unlabeled
% sample, which are described by drug_feature dr_i and target_feature ta_i

DATA=importdata([NAME,'.txt']);                                             % load the subdataset file which is defined as ".txt"
feature_check;                                                              % Define the location of feature description files to load later

[z_target,z_drug]=size(DATA.data);                                          % z_target, z_drug represent the total number in the subdataset

Drug=cell(z_drug,2);
Target=cell(z_target,2);
for i=1:z_drug
    Drug{i,1}=DATA.textdata{1,i+1};
end
for j=1:z_target
    Target{j,1}=DATA.textdata{j+1,1};
end

descriptor_drug=importdata([filepath_drug,'/',D_list{dr_i,1},'.csv']);      % load drug-descriptor files
descriptor_target=importdata([filepath_target,'/',T_list{ta_i,1},'.csv']);  % load target-descriptor files

z_dim_drug=size(descriptor_drug.data,2);                                    % dimension of drug-descriptor
z_dim_target=size(descriptor_target.data,2);                                % dimension of target-descriptor

z_pos=sum(DATA.data(:));
z_unlabel=z_drug*z_target-z_pos;
Pos_set=zeros(z_pos,2);
POS_NAME=cell(z_pos,1);

Unlabel_set=zeros(z_unlabel,2);
UNL_NAME=cell(z_unlabel,1);
loc_t=zeros(z_target,1);
loc_d=zeros(z_drug,1);
k1=1;k2=1;
for i=1:z_target
    loc_t(i,1)=find((strcmp(descriptor_target.textdata(:,1),Target{i,1})));
end

for j=1:z_drug
    loc_d(j,1)=find(strcmp(descriptor_drug.textdata(:,1),['AUTOGEN_',Drug{j,1}]));
end
mean_pos=zeros(1,z_dim_drug+z_dim_target);
for i=1:z_target
    for j=1:z_drug
        if DATA.data(i,j)==1
            Pos_set(k1,:)=[loc_d(j,1),loc_t(i,1)];
            POS_NAME{k1,1}=[Drug{j,1},Target{i,1}];
            mean_pos=mean_pos+[descriptor_drug.data(loc_d(j,1)-1,:),descriptor_target.data(loc_t(i,1)-1,:)];
            k1=k1+1;
        else
            Unlabel_set(k2,:)=[loc_d(j,1),loc_t(i,1)];
            UNL_NAME{k2,1}=[Drug{j,1},Target{i,1}];
            k2=k2+1;
        end
    end
end

mean_pos=mean_pos/z_pos;

dis_unl=zeros(z_unlabel,1);
for i=1:z_unlabel
    dis_unl(i,1)=sum((mean_pos-[descriptor_drug.data(Unlabel_set(i,1)-1,:),descriptor_target.data(Unlabel_set(i,2)-1,:)]).^2);
end

[mt,nt]=sort(dis_unl);
TNEG=Unlabel_set(nt,:);
Neg_set=TNEG((z_unlabel-z_pos+1):z_unlabel,:);
drug_data=descriptor_drug.data;
target_data=descriptor_target.data;

end

