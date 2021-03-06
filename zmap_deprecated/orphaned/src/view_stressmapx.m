

report_this_filefun(mfilename('fullpath'));

SA = 1;


ste = [bvg(:,2) bvg(:,1)+180  bvg(:,4) bvg(:,3)+180 bvg(:,6) bvg(:,5)+180 bvg(:,7) ];
sor = ste;
ste2 = ste;
sor(:,SA*2) = sor(:,SA*2)+90;



normlap2=ones(length(tmpgri(:,1)),1)*nan;

re3=reshape(normlap2,length(yvect),length(xvect));
s11 = re3;

normlap2(ll)= bvg(:,8);
rama=reshape(normlap2,length(yvect),length(xvect));

normlap2(ll)= bvg(:,7);
r=reshape(normlap2,length(yvect),length(xvect));

normlap2(ll)= bvg(:,1);
s11=reshape(normlap2,length(yvect),length(xvect));

normlap2(ll)= bvg(:,4);
s31=reshape(normlap2,length(yvect),length(xvect));

normlap2(ll)= bvg(:,2);
s12=reshape(normlap2,length(yvect),length(xvect));

old1 = re3;

figure_w_normalized_uicontrolunits('visible','on')
plq = quiver(newgri(:,1),newgri(:,2),-cos(sor(:,1)*pi/180),sin(sor(:,1)*pi/180),0.6,'.')
set(plq,'LineWidth',0.5,'Color','k')
hold on

%pl = quiver(newgri(:,1),newgri(:,2),-cos(s(:,2)*pi/180/3),-sin(s(:,2)*pi/180),2)
%set(pl,'LineWidth',2,'Color','r')



px = get(plq,'Xdata'); py = get(plq,'Ydata');
close
figure_w_normalized_uicontrolunits('pos',[100 100 860 600])
watchon;
%whitebg(gcf);
set(gcf,'color','w');
axes('pos',[0.12 0.12 0.8 0.8]);
hold on
n = 0;
l0 = []; l1 = []; l2 = []; l3 = []; l4 = []; l5 = [];
for i = 1:3:length(px)-1
    n = n+1;j = jet;
    col = floor(ste(n,SA*2-1)/60*62)+1;
    if col > 64 ; col = 64; end
    pl = plot(px(i:i+1),py(i:i+1),'k','Linewidth',1.,'Markersize',1,'color',[ 0 0 0  ] );
    hold on
    dx = px(i)-px(i+1);
    dy = py(i) - py(i+1);
    pl2 = plot(px(i),py(i),'ko','Markersize',0.1,'Linewidth',0.5,'color',[0 0 0] );
    l0 = pl;
    pl3 = plot([px(i) px(i)+dx],[py(i) py(i)+dy],'k','Linewidth',1.,'color',[0 0 0] );


  if ste(n,1) < 40  && ste(n,3) > 45  && ste(n,5) < 20 ; set([pl pl3],'color',[0.2 0.8 0.2]); set(pl2,'color',[0.2 0.8 0.2]); l3 = pl; end
   if ste(n,1) > 52  &&                 ste(n,5) < 35 ;                 set([pl pl3],'color','r'); set(pl2,'color','r'); l1 = pl; end
  if ste(n,1) < 20  && ste(n,3) > 45  && ste(n,5) < 40 ;  set([pl pl3],'color',[0.2 0.8 0.2]); set(pl2,'color',[0.2 0.8 0.2]);l3 = pl; end
  if ste(n,1) > 40  &&                 ste(n,1) < 52  && ste(n,5) < 20 ;  set([pl pl3],'color','m'); set(pl2,'color','m'); l2 = pl; end
  if ste(n,1) < 20  &&                 ste(n,5) > 40  &&  ste(n,5) <  52 ; set([pl pl3],'color','c'); set(pl2,'color','c');l4 = pl; end
   if ste(n,1) < 35  && ste(n,5) > 52  ; set([pl pl3],'color','b'); set(pl2,'color','b');l5 = pl;  end

end

if isempty(l1) == 1; pl2 = plot(px(i),py(i),'kx','Linewidth',1.,'color','r'); l1 = pl2; set(l1,'visible','off'); end
if isempty(l2) == 1; pl2 = plot(px(i),py(i),'kx','Linewidth',1.,'color','m'); l2 = pl2; set(l2,'visible','off'); end
if isempty(l3) == 1; pl2 = plot(px(i),py(i),'kx','Linewidth',1.,'color',[0.2 0.8 0.2] ); l3 = pl2; set(l3,'visible','off'); end
if isempty(l4) == 1; pl2 = plot(px(i),py(i),'kx','Linewidth',1.,'color','c' ); l4 = pl2; set(l4,'visible','off'); end
if isempty(l5) == 1; pl2 = plot(px(i),py(i),'kx','Linewidth',1.,'color','b' ); l5 = pl2; set(l5,'visible','off'); end
if isempty(l0) == 1; l0 = plot(px(i),py(i),'kx','Linewidth',1.,'color',[0 0 0 ] );  set(l0,'visible','off'); end

legend([l1 l2 l3 l4 l5 l0],'NF','NS','SS','TS','TF','U');

hold on
axis('equal')
axis('tight')

title2([name ';  '   num2str(t0b) ' to ' num2str(teb) ],'FontSize',ZmapGlobal.Data.fontsz.s,...
    'Color','k','FontWeight','normal')

xlabel('Distance along projection [km] ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
ylabel('Depth [km] ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)


set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
    'FontWeight','normal','LineWidth',1.,...
    'Box','on','TickDir','out','Ticklength',[0.01 0.01])



matdraw

watchoff;

% view the variance map
re3 = r;sha = 'in';
%view_varmap


