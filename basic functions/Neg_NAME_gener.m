function [optNEG_DIS,z_pos] = Neg_NAME_gener(NAME,dr_i,ta_i)

DATA=importdata([NAME,'.txt']);

feature_check;

[z_target,z_drug]=size(DATA.data);

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

z_pos=sum(DATA.data(:));                                                    % number of positive samples
z_unlabel=z_drug*z_target-z_pos;                                            % number of unlabeled samples
Pos_set=zeros(z_pos,z_dim_drug+z_dim_target);                               % define Positive set with features
POS_NAME=cell(z_pos,1);                                                     % define Positive set with Names

Unlabel_set=zeros(z_unlabel,3);
UNL_NAME=cell(z_unlabel,1);
k1=1;k2=1;
for i=1:z_target
    loc_t=find((strcmp(descriptor_target.textdata(:,1),Target{i,1})));
    A=descriptor_target.data(loc_t-1,:);
    for j=1:z_drug
        loc_d=find(strcmp(descriptor_drug.textdata(:,1),['AUTOGEN_',Drug{j,1}]));
        B=descriptor_drug.data(loc_d-1,:);
        if DATA.data(i,j)==1
            Pos_set(k1,:)=[B,A];                                            % generate Positive set with features
            POS_NAME{k1,1}=[Drug{j,1},Target{i,1}];                         % generate Positive set with names
            k1=k1+1;
        end
    end
end
mean_pos=mean(Pos_set);                                                     % define the center of positive samples

for i=1:z_target
    loc_t=find((strcmp(descriptor_target.textdata(:,1),Target{i,1})));
    A=descriptor_target.data(loc_t-1,:);
    for j=1:z_drug
        loc_d=find(strcmp(descriptor_drug.textdata(:,1),['AUTOGEN_',Drug{j,1}]));
        B=descriptor_drug.data(loc_d-1,:);
        if DATA.data(i,j)==0
            X=[B,A];
            Unlabel_set(k2,:)=[sum((mean_pos-X).^2),loc_d,loc_t];           % calculate the distance between unlabeled sample and positive center
            UNL_NAME{k2,1}=[Drug{j,1},Target{i,1}];                         % generate Unlabeled set with names
            k2=k2+1;
        end
    end
end

[ms,ns]=sort(Unlabel_set(:,1));                                             % sort Unlabeled set based on the distances
Unlabel_set=Unlabel_set(ns,:);                                              % resort Unlabeled set
UNL_NAME=UNL_NAME(ns,:);                                                    % resort Unlabeled names

Neg_seq=Unlabel_set((z_unlabel-z_pos+1):z_unlabel,2:3);                     % the farther the distance is, the more reliable the samples are negative
optNEG_DIS=UNL_NAME((z_unlabel-z_pos+1):z_unlabel,:);                       % output the names of negative sets

end