function [auc,xx,yy,tp,tn,fp,fn] = AUC_cal(dec,LABEL)
%AUC_CAL 此处显示有关此函数的摘要
%   此处显示详细说明
myNumb = length((min(dec)-1):.001:(max(dec)+1));
    TruPos = zeros(1,myNumb); TruNeg = zeros(1,myNumb);
    FalPos = zeros(1,myNumb); FalNeg = zeros(1,myNumb);
    countMan = 0;
    for moveit = (min(dec)-1):.001:(max(dec)+1)
        countMan = countMan + 1;
        TruPos(countMan) = sum(sign(dec + moveit)==1 & LABEL==1);
        FalPos(countMan) = sum(sign(dec + moveit)==1 & LABEL==0);
        TruNeg(countMan) = sum(sign(dec + moveit)==-1 & LABEL==0);
        FalNeg(countMan) = sum(sign(dec + moveit)==-1 & LABEL==1);
    end
    tp=TruPos;tn=TruNeg;
    fp=FalPos;fn=FalNeg;
    xx = FalPos/max(FalPos);
    yy = TruPos/max(TruPos);
    areaUnderROC = 0;
    old = [0 0];
    for bb = 1:myNumb
        new = [xx(bb) yy(bb)];
        if new(1) == old(1) & new(2) > old(2)
            old = new;
        elseif new(1) > old(1) & new(2) > old(2)
            areaUnderROC = areaUnderROC + ((old(2) + new(2))/2) * (new(1) - old(1));
            old = new;
        elseif new(1) > old(1) & new(2) == old(2)
            areaUnderROC = areaUnderROC + old(2) * (new(1) - old(1));
            old = new;
        end
    end
    auc=areaUnderROC;
end

