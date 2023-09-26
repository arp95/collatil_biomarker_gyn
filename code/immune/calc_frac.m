function frac=calc_frac(M) %% M is an arbitrary binary mask in uint format values would be aither 0 or 255


frac=sum(sum(im2double(M)))/(size(M,1)*size(M,2));