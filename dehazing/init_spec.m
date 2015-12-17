
%% Initialization of the blobs
function D = init_spec(I)
%I = im2double(imread('Spec_haze_sim_3.png'));
% D = zeros(size(I,1),size(I,2));
D = I(:,:,1).^2 + I(:,:,2).^2 + I(:,:,3).^2;
D = D/max(max(D));
% D(D<0.15)=0;
D(D>0.55) = 1;
D(D<1) = 0;
h = fspecial('gaussian',3,0.8);
D = imfilter(D,h,'replicate');
% % x = imfuse(D,I,'montage','scaling','none');
% imshow(x);
% check the size of the connected components
cc = bwconncomp(D); 
for i = 1:length(cc.PixelIdxList)
    if(length(cc.PixelIdxList{i}) > 300)
        D(cc.PixelIdxList{i}) = 0;
    end  
%     if(length(cc.PixelIdxList{i}) < 50)
%         D(cc.PixelIdxList{i}) = 0;
%     end  
end   
D(D>0)=1;
se = strel('ball',15,15);
D = imdilate(D,se);
D = D - min(min(D));
D(D>0.001) = 1;
end