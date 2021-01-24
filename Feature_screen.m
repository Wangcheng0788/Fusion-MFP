function [M,thre_1,thre_2,thre_3] = Feature_screen(NAME)

% % The function is used to screen feature pairs which have lower coincidence rates
% % "NAME" is the subdataset in the Gold Standard Datasets first introduced by Yamanishi, et al.
% % "M" is the arrangement of feature pairs used later
% % thre_1, indicate the coincidence rate between feature pair 1 and feature pair 2
% % thre_2, indicate the coincidence rate between feature pair 1 and feature pair 3
% % thre_3, indicate the coincidence rate between feature pair 2 and feature pair 3

NEG_DIS=cell(72,1);                                                 % To save the name of drug-target pairs
kneg=0;
for dr_i=1:12                                                       % There are 12 drug-descriptors used
    for ta_i=1:6                                                    % There are 6 target-descriptors used
        kneg=kneg+1;
        [NEG_DIS{kneg,1},z_pos]=Neg_NAME_gener(NAME,dr_i,ta_i);     % optNEG_DIS is the name of drugs and targets
    end
end

MT=[];    
for qmi=1:72
    for qmj=1:72
        Coincidence(qmi,qmj)=(2*z_pos-size(unique([NEG_DIS{qmi,1};NEG_DIS{qmj,1}]),1))/z_pos;   % The matrix of coincidence rate
    end
end
kflag=0;
for i=1:72
    for j=(i+1):72
        kflag=kflag+1;
        MT=[MT;[ceil(i/6),mod(i,6),ceil(j/6),mod(j,6),Coincidence(i,j)]];
        if MT(kflag,2)==0
            MT(kflag,2)=6;
        end
        if MT(kflag,4)==0
            MT(kflag,4)=6;
        end
    end
end

% % "Din" restore all the pairs which coincidence rate equals to zero
% % "M" is one of "Din" which was first found if the lowest coincidence rate is zero
% % "thre" is lowest sum of the coincidence rate finally

[Din,M,thre]=coincidence_screen(MT);                                % calculate the summation of coincidence and screen the lowest three
for mi=1:size(MT,1)
    if (MT(mi,1)==M(1,1)) && (MT(mi,2)==M(1,2)) && (MT(mi,3)==M(2,1)) && (MT(mi,4)==M(2,2))
        thre_1=MT(mi,5);
    elseif (MT(mi,1)==M(1,1)) && (MT(mi,2)==M(1,2)) && (MT(mi,3)==M(3,1)) && (MT(mi,4)==M(3,2))
        thre_2=MT(mi,5);
    elseif (MT(mi,1)==M(2,1)) && (MT(mi,2)==M(2,2)) && (MT(mi,3)==M(3,1)) && (MT(mi,4)==M(3,2))
        thre_3=MT(mi,5);
    end
end
    
end

