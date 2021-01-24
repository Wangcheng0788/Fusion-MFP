function [Din,Fin,thre] = coincidence_screen(MT)
% % The function is used to calculate and screen the lowest sum of coincidence rate with selected feature pairs
% % For each subdataset, the final selected 3 feature pairs, cannot have the same drug-descriptor or target-descriptor
thre=1;
m_thre=0;
Din=[];
Fin=[];
for di1=1:12
    for ti1=1:6
        fea1=[di1,ti1];
        for di2=1:12
            for ti2=1:6
                fea2=[di2,ti2];
                for di3=1:12
                    for ti3=1:6
                        fea3=[di3,ti3];
                        if di1~=di2 && di1~=di3 && di2~=di3 && ti1~=ti2 && ti1~=ti3 && ti2~=ti3
                            for i=1:size(MT,1)
                                if MT(i,1)==fea1(1,1) && MT(i,2)==fea1(1,2) && MT(i,3)==fea2(1,1) && MT(i,4)==fea2(1,2)
                                    m_thre=m_thre+MT(i,5);
                                elseif MT(i,1)==fea2(1,1) && MT(i,2)==fea2(1,2) && MT(i,3)==fea1(1,1) && MT(i,4)==fea1(1,2)
                                    m_thre=m_thre+MT(i,5);
                                end
                                if MT(i,1)==fea1(1,1) && MT(i,2)==fea1(1,2) && MT(i,3)==fea3(1,1) && MT(i,4)==fea3(1,2)
                                    m_thre=m_thre+MT(i,5);
                                elseif MT(i,1)==fea3(1,1) && MT(i,2)==fea3(1,2) && MT(i,3)==fea1(1,1) && MT(i,4)==fea1(1,2)
                                    m_thre=m_thre+MT(i,5);
                                end
                                if MT(i,1)==fea2(1,1) && MT(i,2)==fea2(1,2) && MT(i,3)==fea3(1,1) && MT(i,4)==fea3(1,2)
                                    m_thre=m_thre+MT(i,5);
                                elseif MT(i,1)==fea3(1,1) && MT(i,2)==fea3(1,2) && MT(i,3)==fea2(1,1) && MT(i,4)==fea2(1,2)
                                    m_thre=m_thre+MT(i,5);
                                end
                            end
                            if m_thre==0
                                Din=[Din;[di1,ti1,di2,ti2,di3,ti3]];
                            end
                            if m_thre<thre
                                Fin=[di1,ti1;di2,ti2;di3,ti3];
                                thre=m_thre;
                                m_thre=0;
                            else
                                m_thre=0;
                            end
                        end
                    end
                end
            end
        end
    end
end

end
                                
                                