% % The code is used to generate cluster validation based on cluster_index


NEG_Vali_1=[Fea{1,5}(Vali_NEG_multi(:,1)-1,:),Fea{1,6}(Vali_NEG_multi(:,2)-1,:)];
[idx_1,C_1]=kmeans(NEG_Vali_1,cn);
for x=1:size(idx_1,1)
    if idx_1(x,1)==1
        C_Vali_class{1,1}=[C_Vali_class{1,1};Vali_NEG_multi(x,:)];
    elseif idx_1(x,1)==2
        C_Vali_class{1,2}=[C_Vali_class{1,2};Vali_NEG_multi(x,:)];
    else
        C_Vali_class{1,3}=[C_Vali_class{1,3};Vali_NEG_multi(x,:)];
    end
end
for y=1:cn
    if size(C_Vali_class{1,y},1)<z_c_vali
        xc=ceil(z_c_vali/size(C_Vali_class{1,y},1));
        for hf=1:(xc-1)
            C_Vali_class{1,y}=[C_Vali_class{1,y};C_Vali_class{1,y}];
        end
    end
end

C_Vali_Adjust=[];
for y=1:cn
    C_Vali_class{1,y}=C_Vali_class{1,y}(randperm(size(C_Vali_class{1,y},1)),:);
    C_Vali_Adjust=[C_Vali_Adjust;C_Vali_class{1,y}(1:z_c_vali,:)];
end
for y=1:cn
    C_Vali_1{1,y}=[Fea{y,5}(C_Vali_Adjust(:,1)-1,:),Fea{y,6}(C_Vali_Adjust(:,2)-1,:)];
    Vali_S{1,y}=Fea{y,1}(posvali_seq,:);
    Cluster_1{1,y}=[[Fea{y,5}(Vali_S{1,y}(:,1)-1,:),Fea{y,6}(Vali_S{1,y}(:,2)-1,:)];C_Vali_1{1,y}];
end

NEG_Vali_2=[Fea{2,5}(Vali_NEG_multi(:,1)-1,:),Fea{2,6}(Vali_NEG_multi(:,2)-1,:)];
[idx_2,C_2]=kmeans(NEG_Vali_2,cn);
for x=1:size(idx_2,1)
    if idx_2(x,1)==1
        C_Vali_class{1,1}=[C_Vali_class{1,1};Vali_NEG_multi(x,:)];
    elseif idx_2(x,1)==2
        C_Vali_class{1,2}=[C_Vali_class{1,2};Vali_NEG_multi(x,:)];
    else
        C_Vali_class{1,3}=[C_Vali_class{1,3};Vali_NEG_multi(x,:)];
    end
end
for y=1:cn
    if size(C_Vali_class{1,y},1)<z_c_vali
        xc=ceil(z_c_vali/size(C_Vali_class{1,y},1));
        for hf=1:(xc-1)
            C_Vali_class{1,y}=[C_Vali_class{1,y};C_Vali_class{1,y}];
        end
    end
end

C_Vali_Adjust=[];
for y=1:cn
    C_Vali_class{1,y}=C_Vali_class{1,y}(randperm(size(C_Vali_class{1,y},1)),:);
    C_Vali_Adjust=[C_Vali_Adjust;C_Vali_class{1,y}(1:z_c_vali,:)];
end
for y=1:cn
    C_Vali_2{1,y}=[Fea{y,5}(C_Vali_Adjust(:,1)-1,:),Fea{y,6}(C_Vali_Adjust(:,2)-1,:)];
    Vali_S{1,y}=Fea{y,1}(posvali_seq,:);
    Cluster_2{1,y}=[[Fea{y,5}(Vali_S{1,y}(:,1)-1,:),Fea{y,6}(Vali_S{1,y}(:,2)-1,:)];C_Vali_1{1,y}];
end

NEG_Vali_3=[Fea{3,5}(Vali_NEG_multi(:,1)-1,:),Fea{3,6}(Vali_NEG_multi(:,2)-1,:)];
[idx_3,C_3]=kmeans(NEG_Vali_3,cn);
for x=1:size(idx_1,1)
    if idx_3(x,1)==1
        C_Vali_class{1,1}=[C_Vali_class{1,1};Vali_NEG_multi(x,:)];
    elseif idx_3(x,1)==2
        C_Vali_class{1,2}=[C_Vali_class{1,2};Vali_NEG_multi(x,:)];
    else
        C_Vali_class{1,3}=[C_Vali_class{1,3};Vali_NEG_multi(x,:)];
    end
end
for y=1:cn
    if size(C_Vali_class{1,y},1)<z_c_vali
        xc=ceil(z_c_vali/size(C_Vali_class{1,y},1));
        for hf=1:(xc-1)
            C_Vali_class{1,y}=[C_Vali_class{1,y};C_Vali_class{1,y}];
        end
    end
end

C_Vali_Adjust=[];
for y=1:cn
    C_Vali_class{1,y}=C_Vali_class{1,y}(randperm(size(C_Vali_class{1,y},1)),:);
    C_Vali_Adjust=[C_Vali_Adjust;C_Vali_class{1,y}(1:z_c_vali,:)];
end
for y=1:cn
    C_Vali_3{1,y}=[Fea{y,5}(C_Vali_Adjust(:,1)-1,:),Fea{y,6}(C_Vali_Adjust(:,2)-1,:)];
    Vali_S{1,y}=Fea{y,1}(posvali_seq,:);
    Cluster_3{1,y}=[[Fea{y,5}(Vali_S{1,y}(:,1)-1,:),Fea{y,6}(Vali_S{1,y}(:,2)-1,:)];C_Vali_1{1,y}];
end