clear all%%Clear all variables
close all%%Close all open figures
clc%%clear command window

while true  
% % capturing screenshot and saving it to sdcard of the android device
    system('adb shell screencap -p /sdcard/stickscreen/screen.png');

% %  pulling image to your working directory
    system('adb pull /sdcard/stickscreen/screen.png');
 
% % reading pulled image from working directory 
im=imread('screen.png');

% % storing size of screenshot captured
[M N]=size(im(:,:,1));

im(1:200,:,:)=255;
im(1600:M,:,:)=255;

% % displaying the image pulled
% figure(1)
% imshow(im);

% % extracting R G B components of the image
R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);

out=zeros(M,N);
% % converting to binary image
out=im2bw(rgb2gray(im),0.8);
out=~out;
out=imfill(out,'holes');
% figure(2)
% imshow(out);

% % calculating region properties
stats=regionprops(out);
[G H]=size(stats);

% % calculating maximum area
maxA=0;
maxO=1;
for O=1:G
    if O~=1
        if stats(O).Area>maxA
            maxO=O;
            maxA=stats(O).Area;
        end;
    else
        maxO=1;
        maxA=stats(O).Area;
    end;
end;

% % getting coordinates of maximum size object
XY=stats(maxO).BoundingBox;

X0=floor(XY(1,1));
Y0=floor(XY(1,2));

% % calculating the maximum box width
s=max([XY(1,3) XY(1,4)]);

% % calculating the diagonal coordinates
X1=s+X0+50;
Y1=s+Y0+50;
X0=X0-50;
Y0=Y0-50;

% % swipe duration
dur='100';

% % generating swipe gesture
cmd=['adb shell input swipe ' ' ' num2str(X0) ' ' num2str(Y0) ' ' num2str(X1) ' ' num2str(Y1) ' ' dur];

system(cmd);

% % Removing the scrrenshot saved in sdcard to save space   
system('adb shell rm /sdcard/stickscreen/screen.png');

% % Time delay
pause(1);
end;    
