function [features,featureNames] = getNeighborhoodMeasures(groups,neigborhoodSize,maxNumClusters)
%GETNEIGHBORHOODRICHNESSMEASURES Summary of this function goes here
%   Detailed explanation goes here
features=[];
featureNames={};

stats={'Total','Mean','Std','Median','Max','Min','Kurtosis','Skewness'};
numStats=length(stats);

%n=min(neigborhoodSize,maxNumClusters);
numGroups=length(groups);

for i=1:numGroups
    numClust=length(groups(i).clusters);
    
    if numClust==0
        featStats=zeros(1,numGroups*neigborhoodSize*numStats);
    else
        M=zeros(numClust,numGroups*neigborhoodSize);
        for j=1:numClust
            idx=0;
            numRows=size(groups(i).absoluteClosest(j).idx,1);
            if numRows>0
                for k=1:neigborhoodSize
                    if k<=maxNumClusters && k<=numRows
                        val=groups(i).absoluteClosest(j).idx(1:k,1);
                        for kk=1:numGroups
                            idx=idx+1;
                            M(j,idx)=sum(val==kk)/k;
                        end
                    else
                        for kk=1:numGroups
                            idx=idx+1;
                            M(j,idx)=M(j,idx-numGroups);
                        end
                    end
                end
            end            
        end
        
        if numClust==1
            stArr=arrayfun(@(x) getFeatureStats(x),M','uni', 0);
            featStats=zeros(1,numGroups*neigborhoodSize*numStats);
            numVal=length(stArr);
            for xx=1:numVal
                val=stArr{xx};
                for yy=1:numStats
                    ind=xx+numVal*(yy-1);
                    featStats(ind)=val(yy);
                end
            end
        else
            featStats=getFeatureStats(M);
        end
    end
    
    features=[features featStats];
    
    for st=1:numStats
        for k=1:neigborhoodSize%n
            for kk=1:numGroups
                featureNames=horzcat(featureNames,...
                    {[stats{st} 'PercentageClusters_G' num2str(kk) '_Surrounding_G' num2str(i)...
                    '_Neighborhood' num2str(k) ]});
            end
        end
    end
end

end

