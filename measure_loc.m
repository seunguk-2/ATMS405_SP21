
mdat2 = importdata('~/Downloads/s32_w064_1arc_v3.tif');
mdat3 = importdata('~/Downloads/s32_w065_1arc_v3.tif');

mdat4 = importdata('~/Downloads/s33_w064_1arc_v3.tif');
mdat5 = importdata('~/Downloads/s33_w065_1arc_v3.tif');
%%
mdat = [mdat3 mdat2; mdat5 mdat4];
%%
tx = -65:5/3600:-63;
ty = -31:-5/3600:-33;
[mtx, mty] = meshgrid(tx,ty);
%%
figure(1); clf
contourf(mtx,mty,mdat(1:5:end,1:5:end),128,'linest','none');hold on
colormap((m_colmap('land',128))); caxis([0 2500]);
colorbar; box off;
scatter(bal(2,1),bal(2,2),'ro');
scatter(flx([5 7],1),flx([5 7],2),'bo');
scatter(met([1 7 8],1),met([1 7 8],2),'ko');
title('Locations of measurement')
daspect([1 1 1]);

%%
imprint('~/Desktop/Loc.eps',6,6,0,300)