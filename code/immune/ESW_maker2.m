function y=ESW_maker2(E,S,HQC)
colors=[.3 , 0.1 ,0.5   ;    .9,0,.52; 0.9 .8 .8];

E_vis=zeros(size(E,1),size(E,2),3);
S_vis=zeros(size(E,1),size(E,2),3);


E_vis(:,:,1)=colors(1,1)*E;
E_vis(:,:,2)=colors(1,2)*E;
E_vis(:,:,3)=colors(1,3)*E;


S_vis(:,:,1)=colors(2,1)*S;
S_vis(:,:,2)=colors(2,2)*S;
S_vis(:,:,3)=colors(2,3)*S;




y=E_vis+S_vis;

for i=1:size(E,1)
    for j=1:size(E,2)
        if HQC(i,j)==0 || E(i,j)+S(i,j)==0
            y(i,j,1)=colors(3,1);
            y(i,j,2)=colors(3,2);
            y(i,j,3)=colors(3,3);
        end
    end
end
% imshow(y)
