function slicemapz() 
    % SLICEMAPZ  plot multiple vertical slices through a 3D data cube
    %
    % Requires STATISTICS TOOLBOX (normcdf function)
    %
    % see also SLICEMAP
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    
    global hndl2 tgl1
    global ps1 ps2 pli magsteps_desc bvalsum3 ni zvg gz
    
    %warning off
    
    sta = 'lta';
    
    if ~exist('zv2', 'var')
        zv2= zvg ;
    end
    
    if isempty(ZG.Rconst)
        ZG.Rconst = 1000;
    end
    tgl1 = 2;
    
    my_new()
    
    %% routines
    function my_new()
        %zvg = bvg;
        R = 10;
        
        if mean(gz) < 0 ; gz = -gz; end
        ds = min(gz);
        
        tdiff = teb-t0b;
        
        lta_win = round(100/tdiff * lta_winy);
        lta_out = 100 - lta_win;
        
        
        zvg = squeeze(zv4(:,:,:,1));
        
        for j = 1:length(gz)
            zv3 = zv4(:,:,j,:);
            zv3 = squeeze(zv3);
            [l, l2] = find(isnan(zv3(:,:,1)) == 0);
            
            
            for i = 1:length(l)
                s0 = squeeze(zv3(l(i),l2(i),1:ni));
                cumu = histogram(ZG.primeCatalog.Date(s0),(t0b:(teb-t0b)/99:teb));
                s1_east = cumu(tiz:tiz+lta_win);
                s2_west = cumu; s2_west(tiz:tiz+lta_win) = [];
                var1= cov(s1_east);
                var2= cov(s2_west);
                me1= mean(s1_east);
               me_s2= mean(s2_west);
                zvg(l(i),l2(i),j) = -(me1 -me_s2)/(sqrt(var1/(length(s1_east))+var2/length(s2_west)));
            end % for i
        end % for j
        
        fix1 = min(zvg(:)); 
        fix2 = max(zvg(:));
        
        %y = get(pli,'Ydata');
        gx2 = linspace(min(gx),max(gx),100);
        gy2 = linspace(min(gy),max(gy),100);
        gz2 = linspace(min(gz),max(gz),20);
        
        [X,Y,Z] = meshgrid(gy,gx,gz);
        [X2,Y2] = meshgrid(gx2,gy2);
        Z2 = (X2*0 + ds);
        
        
        figure_w_normalized_uicontrolunits('pos', [80 200 1000 750]);
        axes('pos',[0.1 0.15 0.4 0.7]);
        set(gca,'NextPlot','add')
        
        sliceh = interp3(X,Y,Z,zvg,Y2,X2,Z2);
        pcolor(X2,Y2,sliceh);
        shading flat
        
        %axis image
        
        box on
        shading flat; set(gca,'NextPlot','add')
        hs=axis([min(gx) max(gx) min(gy) max(gy) ]);
        zmap_update_displays();
        
        caxis([fix1 fix2]);
        colormap(jet);
        
        set(hs,'TickDir','out','Ticklength',[0.02 0.02],'Fontweight','bold','Tag','hs');
        h5 = colorbar('horz');
        hsp = get(hs,'pos');
        set(h5,'pos',[0.15 hsp(2)-0.1 0.3 0.02],'Tickdir','out','Ticklength',[0.02 0.02],'Fontweight','bold');
        ti = title(['Depth: ' num2str(ds,3) ' km Time: ' num2str(t0b+tiz*tdiff/100,6)],'Fontweight','bold');
        
        uicontrol('Units','normal',...
            'Position',[.96 .93 .04 .04],...
            'String',' V1',...
            'Callback',@(~,~)callbackfun_vX('samp1'));
        uicontrol('Units','normal',...
            'Position',[.96 .85 .04 .04],'String',' V2',...
            'Callback',@(~,~)callbackfun_vX('samp2'));
        uicontrol('Units','normal',...
            'Position',[.0 .10 .12 .04],'String',' Define X-section',...
            'callback',@callbackfun_define_xsection);
        
        
        labelList={'hsv','hot','jet','cool','pink','gray','bone','invjet'};
        labelPos = [0.9 0.00 0.10 0.05];
        hndl2=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'callback',@setcolormap_callback,...
            'Tag','colormapchoices');
        
        labelList={'z-value Map',...
            'Probability Map (Quiescence)',...
            'Probability Map (increase)',...
            'Resolution Map'};
        labelPos = [0. 0.0 0.20 0.05];
        hndl3=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'callback',@callbackfun_005);
        
        
        ed1 =  uicontrol('units','norm',...
            'BackgroundColor',[0 0 0], ...
            'ForegroundColor',[0.7 0.9 0], ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.1 hsp(2)-0.1 0.04 0.04], ...
            'String',[num2str(fix1),3] , ...
            'TooltipString','Change colorbar range - minimum value  ', ...
            'Style','edit', ...
            'callback',@callbackfun_climmin) ;
        
        ed2 =  uicontrol('BackgroundColor',[0 0 0], ...
            'units','norm',...
            'ForegroundColor',[0.7 0.9 0], ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.48 hsp(2)-0.1 0.04 0.04], ...
            'String',[num2str(fix2),3] , ...
            'TooltipString','Change colorbar range - maximum value ', ...
            'Style','edit', ...
            'callback',@callbackfun_climmax) ;
        
        ed3 =  uicontrol('units','norm',...
            'BackgroundColor',[0 0 0], ...
            'ForegroundColor',[0.7 0.9 0], ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.36 0.0 0.07 0.04], ...
            'String',[num2str(lta_winy),3] , ...
            'TooltipString','Change the LTA window length (in years) ', ...
            'Style','edit', ...
            'callback',@callbackfun_008) ;
        
        ed4 =  uicontrol('units','norm',...
            'BackgroundColor',[0 0 0], ...
            'ForegroundColor',[0.7 0.9 0], ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.42 0.94 0.10 0.03], ...
            'String',[num2str(t0b+tiz*tdiff/100,6)] , ...
            'TooltipString','Change the analysis time ', ...
            'Style','edit', ...
            'callback',@callbackfun_009) ;
        
        ed5 =  uicontrol('units','norm',...
            'BackgroundColor',[0 0 0], ...
            'ForegroundColor',[0.7 0.9 0], ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.36 0.05 0.07 0.04], ...
            'String',[num2str(ni)] , ...
            'TooltipString','Change the sample size (between 10 and 300) ', ...
            'Style','edit', ...
            'callback',@callbackfun_010) ;
        
        slh1 = uicontrol('Style','slider', ...
            'units','norm',...
            'BackgroundColor',[0.7 0.7 0.70], ...
            'ListboxTop',0, ...
            'callback',@callbackfun_011, ...
            'Max',max(abs(gz)),'Min',0, ...
            'Position',[0.1 0.90 0.3 0.02], ...
            'SliderStep',[0.05 0.15], ...
            'Tag','Slider1', ...
            'TooltipString','Move the slider to select the z-value map depth');
        
        slh2 = uicontrol('units','norm',...
            'BackgroundColor',[0.7 0.7 0.70], ...
            'ListboxTop',0, ...
            'callback',@callbackfun_012, ...
            'Max',99-lta_win,'Min',0, ...
            'Position',[0.1 0.95 0.3 0.02], ...
            'SliderStep',[0.05 0.15], ...
            'Style','slider', ...
            'Tag','Slider2', ...
            'TooltipString','Move the slider to select the z-value map time');
        
        
        
        uicontrol('units','norm',...
            'BackgroundColor',[0.32 0.32 0.32], ...
            'ForegroundColor','w', ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.0 0.92 0.1 0.05], ...
            'String','Time: ' , ...
            'Style','text');
        
        
        uicontrol('units','norm',...
            'BackgroundColor',[0.32 0.32 0.32], ...
            'ForegroundColor','w', ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.0 0.87 0.1 0.05], ...
            'String','Depth: ' , ...
            'Style','text');
        
        
        uicontrol('units','norm',...
            'BackgroundColor',[0.32 0.32 0.32], ...
            'ForegroundColor','w', ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.2 0. 0.15 0.03], ...
            'String','LTA length (yrs:) ' , ...
            'Style','text');
        
        uicontrol('units','norm',...
            'BackgroundColor',[0.32 0.32 0.32], ...
            'ForegroundColor','w', ...
            'FontSize',10, ...
            'FontWeight','demi', ...
            'Position',[0.2 0.05 0.15 0.03], ...
            'String','Sample Size: ' , ...
            'Style','text');
        
        
        ax3 = axes(...
            'Units','norm', ...
            'Box','on', ...
            'Position',[0.6 0.5 0.3 0.45], ...
            'Tag','Axes1', ...
            'TickDir','out', ...
            'TickDirMode','manual','Tag','ax3');
        
        set(gca,'NextPlot','add')
        x = mean(gx); y = mean(gy) ; z = ds;
        
        l=ZG.primeCatalog.hypocentralDistanceTo(x,y,z,'kilometer'); %km
        [s,is] = sort(l);
        ZG.newt2 = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
        ZG.newt2 = ZG.newt2(1:ni,:);
        ZG.newt2.sort('Date');
        di = sort(l); Rjma = di(ni);
        
        plot(ZG.newt2.Date,(1:ZG.newt2.Count),'m-','LineWidth',2.0,'Tag','tiplo2')
        set(gca,'YLim',[0 ni+15],'Xlim',[ floor(min(ZG.primeCatalog.Date)) ceil(max(ZG.primeCatalog.Date))]);
        set(gca,'YTick',[ 0 ni/4 ni/2 ni*3/4 ni]);
        
        xlabel('Time [yrs]');
        ylabel('Cumul. Number');
        tline = [t0b+tiz*tdiff/100  0  ; t0b+tiz*tdiff/100 ni];
        set(gca,'NextPlot','add')
        pltline1 = plot(tline(:,1),tline(:,2),'k:');
        tline = [t0b+tiz*tdiff/100+lta_winy  0  ; t0b+tiz*tdiff/100+lta_winy ni];
        pltline2 = plot(tline(:,1),tline(:,2),'k:');
        
        
        
        % Plot the events on map in yellow
        axes(findobj(groot,'Tag','hs'))
        set(gca,'NextPlot','add')
        xc1 = plot(mean(gx),mean(gy),'m^','MarkerSize',10,'LineWidth',1.5);
        set(xc1,'Markeredgecolor','w','Markerfacecolor','g','Tag','xc1')
        set(xc1,'ButtonDownFcn',@(~,~)anseiswa('start1',ds));
        % plot circle containing events as circle
        xx = -pi-0.1:0.1:pi;
        plot(x+sin(xx)*Rjma/(cosd(y)*111), y+cos(xx)*Rjma/(cosd(y)*111),'k','Tag','plc1')
        
        
        
        ax4 = axes(...
            'Units','norm', ...
            'Box','on', ...
            'Position',[0.6 0.1 0.3 0.3], ...
            'Tag','Axes1', ...
            'TickDir','out', ...
            'TickDirMode','manual');
        
        bv = bvalca3(ZG.newt2.Magnitude,McAutoEstimate.auto);
        
        plb =semilogy(magsteps_desc,bvalsum3,'sb');
        set(plb,'LineWidth',1.0,'MarkerSize',4,...
            'MarkerFaceColor','g','MarkerEdgeColor','g','Tag','plb');
        text(0.6,0.8,[ 'b-value: ' num2str(bv,3)],'units','norm','color','m','Tag','teb2');
        
        
        axes(ax3)
        set(gca,'NextPlot','add')
        x = mean(gx)+std(gx)/2; y = mean(gy)+std(gy)/2 ; z = ds;
        l=ZG.primeCatalog.hypocentralDistanceTo(x,y,z,'kilometer'); %km
        [s,is] = sort(l);
        ZG.newt2 = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
        ZG.newt2 = ZG.newt2(1:ni,:);
        ZG.newt2.sort('Date');
        di = sort(l); Rjma = di(ni);
        
        plot(ZG.newt2.Date,(1:ZG.newt2.Count),'c-','LineWidth',2.0,'Tag','tiplo1')
        set(gca,'YLim',[0 ni+15],'Xlim',[ floor(min(ZG.primeCatalog.Date)) ceil(max(ZG.primeCatalog.Date))]);
        set(gca,'YTick',[ 0 ni/4 ni/2 ni*3/4 ni]);
        
        % Plot the events on map in yellow
        axes(findobj(groot,'Tag','hs'))
        set(gca,'NextPlot','add')
        xc2 = plot(mean(gx)+std(gx)/2,mean(gy)+std(gx)/2,'ch','MarkerSize',12,'LineWidth',1.0);
        set(xc2,'Markeredgecolor','w','Markerfacecolor','r','Tag','xc2')
        set(xc2,'ButtonDownFcn',@(~,~)anseiswa('start2',ds));
        % plot circle containing events as circle
        xx = -pi-0.1:0.1:pi;
        plot(x+sin(xx)*Rjma/(cosd(y)*111), y+cos(xx)*Rjma/(cosd(y)*111),'k','Tag','plc2')
        
        axes(ax4);
        set(gca,'NextPlot','add')
        
        bv = bvalca3(ZG.newt2.Magnitude,McAutoEstimate.auto);
        
        semilogy(magsteps_desc,bvalsum3,'^b','LineWidth',1.0,'MarkerSize',4,...
            'MarkerFaceColor','r','MarkerEdgeColor','r','Tag','plb2');
        text(0.6,0.9,[ 'b-value: ' num2str(bv,3)],'units','norm','color','c','Tag','teb1');
        
        xlabel('Magnitude');
        ylabel('Cumul. Number');
        set(gcf,'renderer','painters')
        set(gcf,'renderer','zbuffer')
        
        whitebg(gcf);
        
        helpdlg('You can drag the square and star to display new subvolumes. To display a different depth layer, use the slider')
    end
    
    function my_newdep()
        watchon
        if ds < min(abs(gz)) ; ds = min(abs(gz)); end
        chil = allchild(findobj(groot,'Tag','hs'));
        Z2 = (X2*0 + ds);
        sliceh = interp3(X,Y,Z,zvg,Y2,X2,Z2);
        set(chil(length(chil)),'Cdata',sliceh);
        set(ti,'string',['Depth: ' num2str(ds,3) ' km; Time: ' num2str(t0b+tiz*tdiff/100,6) ]);
        anseiswa('tipl2',ds)
        anseiswa('tipl',ds)
        if get(hndl3,'Value') > 1
            my_newtype()
        end
        
        watchoff
    end
    
    function my_newtime()
        watchon ;
        if sta == 'lta'
            tdiff = teb-t0b;
            
            lta_win = round(100/tdiff * lta_winy);
            lta_out = 100 - lta_win;
            
            
            zvg = squeeze(zv4(:,:,:,1));
            
            for j = 1:length(gz)
                zv3 = zv4(:,:,j,:);
                zv3 = squeeze(zv3);
                [l, l2] = find(isnan(zv3(:,:,1)) == 0);
                
                
                for i = 1:length(l)
                    s0 = squeeze(zv3(l(i),l2(i),1:ni));
                    cumu = histogram(ZG.primeCatalog.Date(s0),(t0b:(teb-t0b)/99:teb));
                    s1_east = cumu(tiz:tiz+lta_win);
                    s2_west = cumu; s2_west(tiz:tiz+lta_win) = [];
                    var1= cov(s1_east);
                    var2= cov(s2_west);
                    me1= mean(s1_east);
                   me_s2= mean(s2_west);
                    zvg(l(i),l2(i),j) = -(me1 -me_s2)/(sqrt(var1/(length(s1_east))+var2/length(s2_west)));
                end % for i
            end % for j
            
            chil = allchild(findobj(groot,'Tag','hs'));
            Z2 = (X2*0 + ds);
            sliceh = interp3(X,Y,Z,zvg,Y2,X2,Z2);
            set(chil(length(chil)),'Cdata',sliceh);
            set(ti,'string',['Depth: ' num2str(ds,3) ' km; Time: ' num2str(t0b+tiz*tdiff/100,6) ]);
            set(pltline1,'Xdata',[ t0b+tiz*tdiff/100   t0b+tiz*tdiff/100 ]);
            set(pltline2,'Xdata',[ t0b+tiz*tdiff/100+lta_winy   t0b+tiz*tdiff/100+lta_winy ]);
            set(slh2,'Max',99-lta_win);
            
            if get(hndl3,'Value') > 1
                my_newtype();
            end
            watchoff
        end % if sta == lta
    end
    
    function my_newclim(fix1, fix2)
        % change the colormap scale (AND draw colorbar!?)
        axes(findobj(groot,'Tag','hs'));
        caxis([fix1 fix2]);
        h5 = colorbar('horiz');
        set(h5,'pos',[0.15 hsp(2)-0.1 0.3 0.02],...
            'Tickdir','out','Ticklength',[0.02 0.02],...
            'Fontweight','bold');
    end
    
    function my_newslice()
        prev = 'ver';
        try
            x = get(pli,'Xdata');
        catch
            errordlg(' Please Define a X-section first! ');
            return;
        end
        y = get(pli,'Ydata');
        gx2c = linspace(x(1),x(2),50);
        gy2c = linspace(y(1),y(2),50);
        gz2c = linspace(min(gz),max(gz),50);
        
        dic = distance(gy2c(1),gx2c(1),gy2c(50),gx2c(50))*111;
        dic = 0:dic/49:dic;
        
        [Y2c,Z2c] = meshgrid(gy2c,gz2c);
        X2c = repmat(gx2c,50,1);
        
        [Xc,Yc,Zc] = meshgrid(gy,gx,gz);
        
        figure_w_normalized_uicontrolunits('visible','off');
        set(gca,'NextPlot','add');
        sl2 = slice(Xc,Yc,Zc,zvg,Y2c,X2c,Z2c);
        valueMap = get(sl2,'Cdata');
        close(gcf)
        figure
        axes('pos',[0.15 0.15 0.6 0.6]);
        pcolor(dic,-gz2c,valueMap);
        shading flat
        if prev == 'hor'; set(sliceh,'tag','slice'); end
        box on
        shading flat
        caxis([fix1 fix2]);
        axis image
        hsc = gca;
        set(gca,'Xaxislocation','top');
        set(gca,'TickDir','out','Ticklength',[0.02 0.02],'Fontweight','bold');
        xlabel('Distance [km]');
        ylabel('Depth [km]');
        
        
        h5 = colorbar('horz');
        hsp = get(hsc,'pos');
        set(h5,'pos',[0.20 hsp(2)-0.05 0.5 0.02],'Tickdir','out','Ticklength',[0.02 0.02],'Fontweight','bold');
        
        whitebg(gcf,[0 0 0]);
        set(gca,'FontSize',10,'FontWeight','bold')
        set(gcf,'Color','k','InvertHardcopy','off')
        slax = gca;
        in3 =get(hndl2,'Value');

        reversejet=@(n)flipud(jet(n));

        colormaps = {@hsv, @hot, @jet, @cool, @pink, @gray, @bone, @reversejet};
        
        colormap(colormaps{in3}(64));
                
        if get(hndl3,'Value') == 2
            
            chil = allchild(hsc);
            zvals = get(chil(length(chil)),'Cdata');
            l = isnan(zvals) == 0;
            zvals(l)  = log10(1- normcdf(zvals(l),mu,varz)); %
            
            set(chil(length(chil)),'Cdata',zvals);
            fix1 = -4; 
            fix2 = -1.3;
            axes(hsc)
            j = [  flipud(jet(64)) ;  zeros(1,3)+0.4; ];
            colormap(j); colorbar
            
        end
        
        if get(hndl3,'Value') == 3
            
            chil = allchild(hsc);
            zvals = get(chil(length(chil)),'Cdata');
            l = isnan(zvals) == 0;
            zvals(l)  = log10(normcdf(zvals(l),mu,varz));
            
            set(chil(length(chil)),'Cdata',zvals);
            fix1 = -4; fix2 = -1.3;
            axes(hsc)
            j = jet(64);
            j = [  j;  zeros(1,3)+0.4; ];
            colormap(j); colorbar
            
        end
        
        
        delete(ps2); delete(pli); delete(ps1);
    end
    
    function my_newtype()
        in3 =get(hndl3,'Value');
        if in3 == 1
            zvg = zv4;
            colormap(jet(64));
            fix1 = -5;
            fix2 = 5;
            my_newtime();
            my_newclim();
            return ;
        end
        if in3 == 2
            my_statsq();
            return ;
        end
        if in3 == 3
            my_statsi();
            return ;
        end
        
        if in3 == 4 ; zvg = ram ; end
        if in3 == 5 ; zvg = avm ; end
        if in3 == 6
            def = {'6'};
            m = inputdlg('Magnitude of projected mainshock?','Input',1,def);
            m1 = m{:};
            m = str2double(m1);
            zvg =(teb - t0b)./(10.^(avm-m*bvg));
            
        end
        if in3 == 7
            colormap(bone);
        end
        if in3 == 8
            colormap( flipud(jet(64)) );
        end
        
        
        chil = allchild(findobj(groot,'Tag','hs'));
        Z2 = (X2*0 + ds);
        sliceh = interp3(X,Y,Z,zvg,Y2,X2,Z2);
        set(chil(length(chil)),'Cdata',sliceh);
        fix1 = min(zvg(:)); 
        fix2 = max(zvg(:));
        set(ed1,  'String',[num2str(fix1,3)]);
        set(ed2,  'String',[num2str(fix2,3)]);
        
        my_newclim(fix1, fix2)
    end
    
    function my_statscommon(mycolormap)
        watchon
        as = zeros(1,500);
        
        for i = 1:500
            s0 = ceil(rand(ni,1)*(ZG.primeCatalog.Count-1));
            tizr = ceil(  rand(1,1)*(100 -lta_win));
            cumu = histogram(ZG.primeCatalog.Date(s0),(t0b:(teb-t0b)/99:teb));
            s1_east = cumu(tizr:tizr+lta_win);
            s2_west = cumu; s2_west(tizr:tizr+lta_win) = [];
            var1= cov(s1_east);
            var2= cov(s2_west);
            me1= mean(s1_east);
           me_s2= mean(s2_west);
            as(i) = (me1 -me_s2)/(sqrt(var1/(length(s1_east))+var2/length(s2_west)));
        end % for i
        
        mu = mean(as);
        varz = std(as);
        chil = allchild(findobj(groot,'Tag','hs'));
        zvals = get(chil(length(chil)),'Cdata');
        l = isnan(zvals) == 0;
        zvals(l)  = log10(1- normcdf(zvals(l),mu,varz));
        
        set(chil(length(chil)),'Cdata',zvals);
        watchoff
        fix1 = -4; fix2 = -1.3;
        
        axes(findobj(groot,'Tag','hs'))
        colormap(mycolormap);
        colorbar
    end
    
    function my_statsi()
        j = jet(64);
        j = [  j ;  zeros(1,3)+0.4; ];
        my_statscommon(j);
        my_newclim(fix1, fix2)
    end
    
    function my_statsq()
        j = jet(64);
        j = [  flipud(j);  zeros(1,3)+0.4; ];
        my_statscommon(j);
        my_newclim(fix1, fix2)
    end
    
    %% callbacks
    
    function callbackfun_vX(whichsamp)
        anseiswa(whichsamp,ds);
        ZG=ZmapGlobal; 
        ctp=CumTimePlot(ZG.newt2);
        ctp.plot();
    end
    
    function callbackfun_define_xsection(mysrc,myevt)
        animator('start', @my_newslice);
    end
    
    function setcolormap_callback(mysrc,~)
        cmapname = mysrc.String{mysrc.Value};
        mycolormap = colormap(cmapname);
        if cmapname == "jet"
            flipud(mycolormap);
        end
        colormap(mycolormap);
    end
    
    
    function callbackfun_005(mysrc,myevt)
        my_newtype();
    end
    
    function callbackfun_climmin(mysrc,myevt)
        fix1 =  str2double(mysrc.String); % colorbar min
        my_newclim(fix1, fix2)
    end
    
    function callbackfun_climmax(mysrc,myevt)
        fix2 = str2double(mysrc.String); %colorbar max
        my_newclim(fix1, fix2)
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lta_winy = str2num(get(ed3,'string'));
        my_newtime()
    end
    
    function callbackfun_009(mysrc,myevt)
        ti2 = str2num(get(ed4,'string'));
        tiz = floor((ti2-t0b)*100/tdiff);
        set(slh2,'value',[tiz]);
        my_newtime()
    end
    
    function callbackfun_010(mysrc,myevt)
        ni = str2num(get(ed5,'string'));
        anseiswa('tipl2',ds);
        anseiswa('tipl',ds);
        my_newtime()
    end
    
    function callbackfun_011(mysrc,myevt)
        ds = min(get(slh1,'Value'));
        my_newdep();
    end
    
    function callbackfun_012(mysrc,myevt)
        tiz = min(get(slh2,'Value'))+1;
        my_newtime();
    end
    
end
