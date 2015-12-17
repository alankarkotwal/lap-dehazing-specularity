function out = haze_model(J)
% for k=1:10
%     k
% name = strcat('../pseudoGT_data/out',int2str(k));
% name = strcat(name,'.png');
% J = im2double(imread('Spec_Orig.png'));
temp = im2double(imread('outtx8.png'));
temp = im2double(temp);
% A = J;
t = J;
p =0;
A = im2double(imread('A_pGT.png'));
t(:, :, 1) = temp + p*max(max(temp));
t(:, :, 2) = temp + p*max(max(temp));
t(:, :, 3) = temp + p*max(max(temp));

t = t./max(max(max(t)));
I = (1 - t).*A + t.*J;
% imshowpair(I, J, 'montage','scaling','none');
% name = strcat('p',int2str(k));
% name = strcat(name,'_40.png');
% imwrite(I, name);
out = I;
end