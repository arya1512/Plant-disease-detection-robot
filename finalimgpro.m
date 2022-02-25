A=imread('clean.jpg');
A_gray=rgb2gray(A);
A_hsv=rgb2hsv(A);
A_v=A_hsv (:,:,3);
A_v=histeq(A_v);
A_hsv(:,:,3)=A_v;
A_enhanced=hsv2rgb(A_hsv);
A_lab= rgb2lab(A);
ab = A_lab(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);                                 
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
    color = A;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
Agg=rgb2gray(segmented_images{2});
otsu_level= graythresh(Agg);
A_thresh=im2bw(A_lab,1/255);
A_thresh=~A_thresh;
se=strel ('disk',20);
A_erosion= imerode (A_thresh,se);
subplot(3,3,1), imshow(A), title('original');
subplot(3,3,2), imshow(A_gray), title('gray model');
subplot(3,3,3), imshow(A_hsv), title('hsv model');
subplot(3,3,4), imshow(A_enhanced), title('enhanced');
subplot(3,3,5), imshow(A_lab), title('lab model');
subplot(3,3,6), imshow(A_thresh), title('thresholding');
subplot(3,3,7), imshow(segmented_images{1}), title('objects in cluster 1');
subplot(3,3,8), imshow(segmented_images{2}), title('objects in cluster 2');
subplot(3,3,9), imshow(segmented_images{3}), title('objects in cluster 3');
if(A_erosion==0)
    {
     fprintf('leaf is affected')  
     }
else
    {
    fprintf('leaf is not  affected')
    }
    
end


   
 