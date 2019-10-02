function Xcorr_Single_Plane_Crop(maxx,maxy)
[name,path]=uigetfile('*.mat','Select plane to stabilize');
disp(name)
cd(path)
clear chone
load([name])
if exist('video','var')
    chone=video;
    clear video
end
chone=chone(:,:,:);
sizeMov=size(chone);
searchframes=[round(sizeMov(3)*.25) round(sizeMov(3)*.75)];%130213_009-010
intensity_thresh=mean(chone(:))+std(single(chone(:)));
movref = single(chone);
clear chone
movref(movref<intensity_thresh) = 0;
disp(['Took ' num2str(ww) ' seconds to threshold the image stack'])
[~,b]=min(squeeze(mean(mean((abs(diff(movref(:,:,searchframes(1):searchframes(2)),1,3)))))));
still = round(searchframes(1)+b-1);
refframenum=still;
figure
imagesc(squeeze(mean(movref(:,:,(refframenum-25):(refframenum+25)),3)))
[X1,Y1]=ginput(1);
[X2,Y2]=ginput(1);
X1=round(X1);Y1=round(Y1);X2=round(X2);Y2=round(Y2);
imagesc(squeeze(mean(movref(Y1:Y2,X1:X2,(refframenum-25):(refframenum+25)),3)));
track_subpixel_wholeframe_motion_MA_crop;
clear chone_thresh;
load([path,name],'chone');
xshifts(isnan(xshifts))=0;
yshifts(isnan(yshifts))=0;
save([path,name(1:(end-10)),'_XCshifts_',name((end-4)),'.mat'],'xshifts', 'yshifts', '-v7.3');
video=uint16(playback_wholeframe_subpix(chone,xshifts,yshifts));
save([path,name(1:(end-10)),'_XC_',name((end-4)),'.mat'],'video', 'sizeMov', '-v7.3');
clear video;
yy = toc;
disp(['Took ' num2str(yy) ' seconds to apply the shifts to the stack'])
close all;
