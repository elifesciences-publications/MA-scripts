numshifts_x=2*maxshift_x+1;
numshifts_y=2*maxshift_y+1;
[y,x,z]=size(movref);
refframe=squeeze(mean(movref(:,:,(refframenum-25):(refframenum+25)),3));
corrmat=zeros(numshifts_y,numshifts_x,z);
temp_refframe=refframe(Y1:Y2,X1:X2);
temp_refframe=temp_refframe-mean(temp_refframe(:)); 
temp_refframe=reshape(temp_refframe,[size(temp_refframe,1)*size(temp_refframe,2) 1 1]);
temp_refframe=repmat(temp_refframe,[1 1 z]);
refframestd=std((temp_refframe),0,1);
for xshift=-maxshift_x:maxshift_x
    for yshift=-maxshift_y:maxshift_y
        temp_frame=movref((Y1+yshift):(Y2+yshift),(X1+xshift):(X2+xshift),:);
        temp_frame=bsxfun(@minus, temp_frame, mean(mean(temp_frame,1),2));        
        temp_frame=reshape(temp_frame,[size(temp_frame,1)*size(temp_frame,2) 1 z]);
        corrmat(yshift+maxshift_y+1,xshift+maxshift_x+1,:)=mean(temp_frame.*temp_refframe,1)./(std((temp_frame),0,1).*refframestd);
    end
end
xshifts=zeros(1,z);
yshifts=zeros(1,z);
numsamples=zeros(1,z);
correlation_threshold=0.85;
xx=-maxshift_x:maxshift_x;
xx=repmat(xx,2*maxshift_y+1,1);
yy = (-maxshift_y:maxshift_y)';
yy=repmat(yy,1,2*maxshift_x+1);
xxi=xx;
yyi=yy;
correlation_thresholds(z)=0;
for i=1:z
    thiscorr=(corrmat(:,:,i));
    thiscorr_interp=interp2(xx,yy,thiscorr,xxi,yyi);
    numsamples_hold=0;
    correlation_threshold_temp=correlation_threshold;
    while numsamples_hold<min_samples
        thiscorr_interp_temp=thiscorr_interp.*(thiscorr_interp>correlation_threshold_temp);
        numsamples(i)=sum(thiscorr(:)>correlation_threshold_temp);
        numsamples_hold=numsamples(i);
        if numsamples_hold<min_samples
            correlation_threshold_temp=correlation_threshold_temp-0.025;
        end
    end
    thiscorr_interp=thiscorr_interp.*(thiscorr_interp>correlation_threshold_temp);
    correlation_thresholds(i)=correlation_threshold_temp;   
    thiscorr_interp=thiscorr_interp/sum(thiscorr_interp(:));
       xshifts(i)=sum(thiscorr_interp(:).*xxi(:));
       yshifts(i)=sum(thiscorr_interp(:).*yyi(:));
end