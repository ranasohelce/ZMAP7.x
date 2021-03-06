function plotmi(var1)

    global  a mi mif2 mif1

    report_this_filefun(mfilename('fullpath'));

    newcat2 = a;
    figNumber=findobj('Name','Misfit ','-and','Type','Figure'); %TODO make sure the space in the name is important
    figure(figNumber)
    delete(findobj(figNumber,'Type','axes'));

    rect = [0.15,  0.15, 0.75, 0.65];
    axes('position',rect)

    if var1 == 1

        [s,is] = sort(newcat2(:,1));
        newcat2 = newcat2(is(:,1),:) ;
        mi2 = mi(is(:,1),:) ;
        pl = plot(newcat2(:,1),cumsum(mi2(:,2)),'b')
        set(pl,'LineWidth',2.0)
        grid
         set(gca,'Color',color_bg);
        set(gca,'box','on',...
            'SortMethod','childorder','TickDir','out','FontWeight',...
            'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)
        xlabel('Longitude ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)

    elseif var1 == 3
        [s,is] = sort(newcat2(:,3));
        newcat2 = newcat2(is(:,1),:) ;
        mi2 = mi(is(:,1),:) ;
        pl = plot(newcat2(:,3),cumsum(mi2(:,2)),'b')
        set(pl,'LineWidth',2.0)
        grid
         set(gca,'Color',color_bg);
        set(gca,'box','on',...
            'SortMethod','childorder','TickDir','out','FontWeight',...
            'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)

        xlabel('Time in [Years]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)

    elseif var1 == 2
        [s,is] = sort(newcat2(:,var1));
        newcat2 = newcat2(is(:,1),:) ;
        mi2 = mi(is(:,1),:) ;
        pl = plot(newcat2(:,var1),cumsum(mi2(:,2)),'b')
        set(pl,'LineWidth',2.0)
        grid
         set(gca,'Color',color_bg);
        set(gca,'box','on',...
            'SortMethod','childorder','TickDir','out','FontWeight',...
            'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)

        xlabel('Latitude ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)

    elseif var1 == 4
        [s,is] = sort(newcat2(:,6));
        newcat2 = newcat2(is(:,1),:) ;
        mi2 = mi(is(:,1),:) ;
        pl = plot(newcat2(:,6),cumsum(mi2(:,2)),'b')
        set(pl,'LineWidth',2.0)
        grid
         set(gca,'Color',color_bg);
        set(gca,'box','on',...
            'SortMethod','childorder','TickDir','out','FontWeight',...
            'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)

        xlabel('Magnitude ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)

    elseif var1 == 5
        [s,is] = sort(newcat2(:,7));
        newcat2 = newcat2(is(:,1),:) ;
        mi2 = mi(is(:,1),:) ;
        pl = plot(newcat2(:,7),cumsum(mi2(:,2)),'b')
        set(pl,'LineWidth',2.0)
        grid
         set(gca,'Color',color_bg);
        set(gca,'box','on',...
            'SortMethod','childorder','TickDir','out','FontWeight',...
            'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)

        xlabel('Depth in [km] ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)


    end   % if var1

