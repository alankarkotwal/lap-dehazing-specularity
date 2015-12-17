% Zeeshan Lakhani
% April 16, 2007
% Computational photography: Assignment 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = textsynthext()
%call function as is
%sorry to do all process(pseudo code functions) here, but it felt good this way :)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
WindowSize = 9; %user input between 9 and 17...technically, this is halfway between pixel(in middle) and boundary of window

%read in images
Image = imread('D20.png');

Image = im2double(rgb2gray(Image)); %convert to double

%create zeropadded matrix for upsizing calculation
newImage = [zeros(11+WindowSize,11+WindowSize), zeros(11+WindowSize, size(Image,2)), zeros(11+WindowSize,11+WindowSize); ...
            zeros(size(Image,1), 11+WindowSize), Image, zeros(size(Image,1),11+WindowSize);...
            zeros(11+WindowSize,11+WindowSize), zeros(11+WindowSize, size(Image,2)), zeros(11+WindowSize,11+WindowSize)];

% 
% newImage = [ zeros(11,11)         , zeros(11, size(Image,2)), zeros(11,11); ...
%     zeros(size(Image,1), 11), Image                  , zeros(size(Image,1),11);...
%     zeros(11,11)    , zeros(11, size(Image,2)), zeros(11,11)];

SampleImage = im2col(newImage,[(2 * WindowSize + 1) (2 * WindowSize + 1)]);  %get synthesis patches in Image expanded
%obtain only synthesis patches needed
[samrows,samcols] = find(SampleImage == 0); 
SampleImage(:,samcols) = [];  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetUnfilledNeighbors
mask = logical(newImage); %get 1's for the boundaries of missing hole
se = strel('square',3); 
border_mask = imdilate(mask,se) - mask; %obtain dilation and subtract to obtain unfilled neighbors
[rows,cols] = find(border_mask); %get coordinate values
PixelList = zeros(length(rows),2); %put coordinate values in a matrix
PixelList(:,1) = rows; 
PixelList(:,2) = cols;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
ErrThreshold = 0.3; %constant given by pseudo code
MaxErrThreshold = 0.3; %constant given by pseudo code
Crop = zeros(WindowSize*2 + 1,WindowSize*2 + 1,size(PixelList,1)); %pre-allocated 3d array for each pixel's template
Template = zeros(WindowSize*2 + 1,WindowSize*2 + 1); %pre-allocated template
Sigma = (WindowSize*2 + 1)/6.4; %compute sigma...based on formula in pseudo code
% BestMatch = zeros(size(PixelList,1),1);  
%SSD = zeros(size(SampleImage,1), size(SampleImage,2));   

for loop = 1:11 %loop to extened 11 pixels around
    loop; 
    size(PixelList);
%     progress = 0;   
    for i = 1:size(PixelList,1)
        %GetNeighborhood Window
        Crop(:,:,i) = newImage(PixelList(i,1) - (WindowSize): PixelList(i,1) + (WindowSize), PixelList(i,2) - (WindowSize): PixelList(i,2) + (WindowSize)); 
        Template(:,:) = Crop(:,:,i); %get template for each pixel (window around each pixel)
        %Find Matches
        ValidMask = logical(Template); %get 1's and 0's for each window
        GaussMask = fspecial('gaussian',WindowSize*2 + 1,Sigma); %create 2d Gaussian mask
        size(GaussMask);
        dotmask = GaussMask .* ValidMask; %find dot product of Val and Gauss masks
        TotWeight = sum(sum(dotmask));  %calculate TotWeight...based on pseudo code
        %SSD
        dotmask = dotmask(:) * ones(1,size(SampleImage,2)); %replicate for calc of SSD
        tempvec = Template(:); 
        tempmtx = tempvec * ones(1,size(SampleImage,2)); %replicate each template for distance calc
        dist = (SampleImage - tempmtx).^2; %get distance
        SSD = dist.*dotmask;
        SSD = sum(SSD)./TotWeight;  %get SSD vector
        validnum = find(SSD <= min(SSD) .* (1 + ErrThreshold)); %find valid index(column) for this metric
        mid = ((WindowSize * 2 + 1).^2+1)/2; %middle row
        BestMatches = SampleImage(mid,validnum); %calculate pixel values in created SampleImage
        size(BestMatches); 
        %Random Pick
         BestMatch = BestMatches(1 + (floor(rand(1)) .* length(BestMatches))); %pick from random indices in BestMatches vec 
          %I got rid of MaxErrThreshold section...I find that it's unnecessary
%         if (BestMatch < MaxErrThreshold)
            newImage(PixelList(i,1),PixelList(i,2)) = BestMatch; %replace pixel coordinates' values with BestMatch pixel value
%             progress = 1; 
%         end
%         if (progress == 0) 
%             MaxErrThreshold = MaxErrThreshold * 1.1;
%         end
        %debug in real-time
        imagesc(newImage); 
        axis image; colormap gray; 
        drawnow; 
    end 
    %repeat PixelList operations to figure out what needs to still be filled
    mask = logical(newImage); 
    border_mask = imdilate(mask,se) - mask;
    [rows,cols] = find(border_mask); 
    PixelList = zeros(length(rows),2);
    PixelList(:,1) = rows; 
    PixelList(:,2) = cols;
end

% clf; imshow(newImage);
% size(newImage);

%get rid zeropadded (unnecessary) rows and columns...ones that just contain zeros
newImage(1:WindowSize,:) = []; newImage(:,1:WindowSize) = []; 
newImage(size(newImage,1) - WindowSize + 1: size(newImage,1), :) = []; newImage(:, size(newImage,2) - WindowSize + 1: size(newImage,2)) = []; 
clf; imshow(newImage); %show final image
size(newImage) 
imwrite(newImage,'extend.jpg'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//zeeshan lakhani