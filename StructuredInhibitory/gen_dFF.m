Fs=8;
dFF=zeros(size(F));
numframes=size(F,3);
numwindow=Fs*300;
window=round(numframes/numwindow);
for j=1:size(F,2)
    junk=FminusN(:,j);    
    junk2=zeros(size(junk));
    for k=1:length(junk)
        cut=junk(max(1,k-window):min(numframes,k+window));
        cutsort=sort(cut);
        a=round(length(cut)*.08);
        junk2(k)=cutsort(a);
    end
    dFF(:,j)=(junk-junk2)./junk2;
    F0=mean(junk2);
end
