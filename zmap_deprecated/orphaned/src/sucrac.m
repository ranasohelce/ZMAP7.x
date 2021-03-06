% This script evaluates the percentage of space time covered by
%alarms
%
re = [];

% Stefan Wiemer    4/95

report_this_filefun(mfilename('fullpath'));

abo = abo2;

for tre2 = min(abo(:,4)):0.1:max(abo(:,4)-0.1)
    abo = abo2;
    abo(:,5) = abo(:,5)* par1/365 + a(1,3);
    l = abo(:,4) >= tre2;
    abo = abo(l,:);
    l = abo(:,3) < tresh;
    abo = abo(l,:);
    hold on

    % space time volume covered by alarms
    if isempty(abo) == 1
        Va = 0;
    else
        Va = sum(pi*abo(:,3).^2)*iala;
    end

    % All space time
    [len, ncu] = size(cumuall);

    r = loc(3,:);
    %r = reshape(cumuall(len,:),length(gy),length(gx));
    %r=reshape(normlap2,length(yvect),length(xvect));
    l = r < tresh;
    V = sum(pi*r(l).^2*(teb-t0b));
    disp([' Zalarm = ' num2str(tre2)])
    disp([' =============================================='])
    disp([' Total space-time volume (R<Rmin):  ' num2str(V)])
    disp([' Space-time volume covered with alarms (R<Rmin):  ' num2str(Va)])
    disp([' Percent of total covered with alarms (R<Rmin):  ' num2str(Va/V*100) ' Percent' ])

    re = [re ; tre2 Va/V*100 ];
end   % for tre2


figure

matdraw
axis off

uicontrol('Units','normal',...
    'Position',[.0 .65 .08 .06],'String','Save ',...
     'Callback',{@calSave9, re(:,1), re(:,2)})

rect = [0.20,  0.10, 0.70, 0.60];
axes('position',rect)
hold on
pl = semilogy(re(:,1),re(:,2),'r');
set(pl,'LineWidth',1.5)
pl = semilogy(re(:,1),re(:,2),'ob');
set(pl,'LineWidth',1.5,'MarkerSize',10)
set(gca,'YScale','log')

set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on')
grid

ylabel('Va/Vtotal in %')
xlabel('Zalarm ')
watchoff

