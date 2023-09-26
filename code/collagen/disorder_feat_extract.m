function  [orient_occur_feats]=contrast_entropy(orients,areas,orient_num,orient_cooccur_scheme)              
           for pair1 = 1:orient_num % find out how often each pair of bins co-occur
            for pair2 = pair1:orient_num   
                if ~isempty(find(orients== pair1)) && ~isempty(find(orients== pair2))
                    if pair1~=pair2
                        switch  orient_cooccur_scheme
                            case 1
                        p_orient_occur(pair1,pair2)=sum(areas(find(orients== pair1)))* sum(areas(find(orients== pair2)));
                            case 2
                        p_orient_occur(pair1,pair2)=sum(orients==pair1)* sum(orients==pair2);
                        end
                    else
                        iden_angle_num=sum(orients==pair1);
                        if iden_angle_num==1
                        p_orient_occur(pair1,pair2)=0;
                        else
                            
                          switch orient_cooccur_scheme
                              case 1
                            ind_permutation=nchoosek(find(orients== pair1),2);
                            p_orient_occur(pair1,pair2)=sum(areas(ind_permutation(:,1)).*areas(ind_permutation(:,2)));
                              case 2
                            p_orient_occur(pair1,pair2)=nchoosek(sum(orients== pair1),2);

                          end
                       end
                    end
                end
            end
           end

        orient_occur_matrix = p_orient_occur./sum(p_orient_occur(:)); % normalize co-occurence matrix
        orient_occur_feats = haralick_no_img_v2(orient_occur_matrix); 
        
       