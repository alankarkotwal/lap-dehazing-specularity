function [out,d] = init_inpaint(input,mask)
psz=15;
addpath('../inpainting_criminisi2004-master/');
mask(mask>0)=1;
% figure; imshow(mask,[]);
[out,~,~,d] = inpainting(input,mask,psz);
end