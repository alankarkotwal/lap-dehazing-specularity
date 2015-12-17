function [out1,out2] = gen_spec(clean)
% generate the specular map
% O = im2double(imread('Original.png'));
O = clean;
p = zeros(size(O,1),size(O,2));
J = O;
for k=1:size(J,1)
for kk=1:size(J,2)
p(k,kk) = mvnpdf([k,kk],[50,30],[2,0;0,2])*5;
end
end
for k=1:size(J,1)
for kk=1:size(J,2)
p(k,kk) = p(k,kk) + mvnpdf([k,kk],[90,90],[3,0;0,1])*5;
end
end
for k=1:size(J,1)
for kk=1:size(J,2)
p(k,kk) = p(k,kk) + mvnpdf([k,kk],[40,100],[1,0;0,3])*5;
end
end

p(p>0.37) = 1;
% p(p>0.1 && p<0.2) = 0.5;
for k=1:size(J,1)
for kk=1:size(J,2)
if (p(k,kk)<0.2 && p(k,kk)>0.1)
p(k,kk) = 0.5;
end
if (p(k,kk)<0.37 && p(k,kk)>0.2)
p(k,kk) = 0.6 + p(k,kk);
end
end
end
for k=1:size(J,1)
for kk=1:size(J,2)
if (p(k,kk)<0.2 && p(k,kk)>0.1)
p(k,kk) = 0.5;
end
if (p(k,kk)<0.37 && p(k,kk)>0.2)
p(k,kk) = 0.6 + p(k,kk);
end
end
end

O(:,:,1) = O(:,:,1) + p;
O(:,:,2) = O(:,:,2) + p;
O(:,:,3) = O(:,:,3) + p;
% imshowpair(O,p,'montage','scaling','none')
out1 = O;
out2 = p;
end