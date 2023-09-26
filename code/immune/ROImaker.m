function y=ROImaker(I,MMMM)
y1=I.*MMMM;
colors=[ 0.9 .8 .8];

y2=zeros(size(I,1),size(I,2),3);


y2(:,:,1)=colors(1,1).*(1-MMMM);
y2(:,:,2)=colors(1,2).*(1-MMMM);
y2(:,:,3)=colors(1,3).*(1-MMMM);


y=y1+y2;
% 
% for i=1:size(E,1)
%     for j=1:size(E,2)
%         if HQC(i,j)==0 || E(i,j)+S(i,j)==0
%             y(i,j,1)=colors(3,1);
%             y(i,j,2)=colors(3,2);
%             y(i,j,3)=colors(3,3);
%         end
%     end
% end
% imshow(y)
