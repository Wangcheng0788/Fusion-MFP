function [Train,Vali,Test] = Fold_div_vali(Pos_set,mode)
%FOLD_DIV 此处显示有关此函数的摘要
%   此处显示详细说明
% Train:Vali:Test=3:1:1
z=size(Pos_set,1);

z_fold=ceil(z/mode);

ranp=randperm(z);
Pos_set=Pos_set(ranp,:);

Train=Pos_set(1:3*z_fold,:);
Vali=Pos_set((3*z_fold+1):4*z_fold,:);
Test=Pos_set((4*z_fold+1):z,:);

end

