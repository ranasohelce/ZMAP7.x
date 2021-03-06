report_this_filefun(mfilename('fullpath'));

% Now lets plot the color-map of the z-value
%
figure

set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','SortMethod','childorder')

rect = [0.18,  0.10, 0.7, 0.75];
rect1 = rect;

% set values greater tresh = nan
%
re4 = re3;l = r > tresh; re4(l) = zeros(1,length(find(l)))*nan;

% plot image
%
orient portrait
set(gcf,'PaperPosition', [2. 1 7.0 5.0])

axes('position',rect);hold on
pco1 = pcolor(gx,gy,(re4));
axis([ min(gx) max(gx) min(gy) max(gy)]); axis image; hold on
shading interp;
caxis([0.40 1.00])
if exist('pro', 'var')
    l = pro > 0;
    pro2 = pro;
    pro2(l) = pro2(l)*nan;
    %cs =contour(gx,gy,pro,[ 99 100],'w--');

    % cs =contour(gx,gy,pro,[95 99],'k');
    %[cs, hc] =contour(gx,gy,pro,[ 99 100],'w-');
end % if exist pro
h = jet(64);h = [  h(64:-1:1,:)]; colormap(h)
%end
if fre == 1
    caxis([fix1 fix2])
end

set(gca,'Color',[0.9 0.9 0.9])
%brighten(0.5)
%xlabel('Distance in [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
%ylabel('depth in [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
%set(gca,'XTickLabels',[])
set(gca,'YTickLabels',[12 10 8 6 4 2])

if exist('maex', 'var')
    pl = plot(maex,-maey,'*k');
    set(pl,'MarkerSize',6,'LineWidth',2)
end
overlay

set(gca,'visible','on','FontSize',10,'FontWeight','normal',...
    'FontWeight','normal','LineWidth',1.0,...
    'Box','on','TickDir','out')
h1 = gca;hzma = gca;

% Create a colobar
%
%h5 = colorbar('vertical');
%set(h5,'Pos',[0.25 0.25 0.03 0.25],...
%'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m,'TickDir','out')


% Make the figure visible
%


axes(h1)
