function newmov=playback_wholeframe_subpix(mov,xoffsets,yoffsets)
[y,x,z]=size(mov);
ny=y;nx=x;
newmov=zeros(ny,nx,z);
for i=1:z
    thisframe=double(squeeze(mov(:,:,i)));
    thisframe_interp=interp2(1:x,(1:y)',thisframe,(1:x)+xoffsets(i),((1:y)+yoffsets(i))','bicubic');
     newmov(:,:,i)=thisframe_interp(1:y,1:x);
end
