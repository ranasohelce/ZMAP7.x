report_this_filefun(mfilename('fullpath'));

% drap a colormap onto topography
l = isnan(tmap);
tmap(l) = 1;

l = tmap< 0.1;
tmap(l) = 0;


[lat,lon] = meshgrat(tmap,tmapleg);
%[smap,smapleg] = country2mtx('switzerland',100);
%[lat0, lon0] = meshgrat(smap,smapleg);


% tmap = km2deg(tmap/1);
[X , Y]  = meshgrid(gx,gy);

%sw = interp2(lon0,lat0,smap,lon,lat);



ren = interp2(X,Y,re4,lon,lat);

mi = min(min(ren));
l =  isnan(ren);
ren(l) = mi-20;




figure

hold on; axis off
% axesm('MapProjection','eqaconic','MapParallels',[],...
%    'MapLatLimit',[s4_south s3_north],'MapLonLimit',[s2_west s1_east])
axesm miller
meshm(ren,tmapleg,size(tmap),tmap);

daspectm('m',100);
tightmap
view([0 90])
camlight; lighting phong
set(gca,'projection','perspective');

%   load worldlo
%   h = displaym(POline); set(h(1),'color',[0.9 0.9 0.9],'Linewidth',1.7)
%   h2 = displaym(PPpoint);
%   h = displaym(PPtext); trimcart(h);



% pl = plotm(ma(:,2),ma(:,1),'hw');
%  set(pl,'LineWidth',1.5,'MarkerSize',12,...
% 'MarkerFaceColor','w','MarkerEdgeColor','k')
%load coast.mat
%c = coast;
% plotm(c(:,1), c(:,2),'k','Linewidth',1);
% zdatam(handlem('allline'),10000) % keep line on surface
%zdatam(handlem('alltext'),10000) % keep line on surface




j = jet;
%j = j(64:-1:1,:);
j = [ [ 0.9 0.9 0.9 ] ; j];
caxis([ min(min(re4)) max(max(re4)) ]);

colormap(j); brighten(0.1);

axis off; set(gcf,'color','k')

setm(gca,'ffacecolor','k')
setm(gca,'fedgecolor','w','flinewidth',3);

setm(gca,'mlabellocation',60)
setm(gca,'meridianlabel','on')
setm(gca,'plabellocation',60)
setm(gca,'parallellabel','on')
setm(gca,'Fontcolor','w','Fontweight','bold','FontSize',16,'Labelunits','dm')

h5 = colorbar;
set(h5,'position',[0.8 0.35 0.01 0.3],'TickDir','out','Ycolor','w','Xcolor','w',...
    'Fontweight','bold','FontSize',16);
set(gcf,'Inverthardcopy','off');







