function view_av2(lab1,valueMap) 
    % subroutine to plot a-value and others run by calc_across
    % This subroutine is based on view_bv2.m and
    % was created by Thomas van Stiphout 3/04
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals

    
    report_this_filefun();
    ZG.someColor = 'k';
    
    bmapc=findobj('Type','Figure','-and','Name','a-value cross-section');
    
    % Set up the Seismicity Map window Enviroment
    %
    if isempty(bmapc)
        bmapc = figure_w_normalized_uicontrolunits( ...
            'Name','a-value cross-section',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',position_in_current_monitor(ZG.map_len(1), ZG.map_len(2)));
        
        lab1 = 'a-value';
        create_my_menu();
        colormap(jet)
        bOverlayTransparentStdDev = false;
    end   % This is the end of the figure setup
    
    % plot the color-map of the z-value
    %
    figure(bmapc);
    delete(findobj(bmapc,'Type','axes'));
    reset(gca)
    cla
    set(gca,'NextPlot','replace')
    watchon;
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','SortMethod','childorder')
    
    rect = [0.15,  0.10, 0.8, 0.75];
    rect1 = rect;
    
    % set values greater ZG.tresh_km = nan
    %
    re4 = valueMap;
    re4(r > ZG.tresh_km) = nan;
    
    % plot image
    %
    orient portrait
    %set(gcf,'PaperPosition', [2. 1 7.0 5.0])
    
    axes('position',rect)
    set(gca,'NextPlot','add')
    pco1 = pcolor(gx,gy,re4);
    
    axis([ min(gx) max(gx) min(gy) max(gy)])
    axis image
    
    if bOverlayTransparentStdDev
        mTransparentStdDev = mAverageStdDev;
        vSelection = mAverageStdDev <= 0.05;
        mTransparentStdDev(vSelection) = 1;
        vSelection = (mAverageStdDev > 0.05) & (mAverageStdDev <= 0.1);
        mTransparentStdDev(vSelection) = 0.75;
        vSelection = (mAverageStdDev > 0.1) & (mAverageStdDev <= 0.15);
        mTransparentStdDev(vSelection) = 0.5;
        vSelection = (mAverageStdDev > 0.15) & (mAverageStdDev <= 0.2);
        mTransparentStdDev(vSelection) = 0.25;
        vSelection = mAverageStdDev > 0.2;
        mTransparentStdDev(vSelection) = 0;
        set(pco1, 'FaceALpha', 'flat', 'AlphaData', mTransparentStdDev, 'AlphaDataMapping', 'none');
    end
    bOverlayTransparentStdDev = false;
    
    set(gca,'NextPlot','add')
    shading(ZG.shading_style)
    
    % make the scaling for the recurrence time map reasonable
    if lab1(1) =='T'
        ZG.freeze_colorbar = false;
        re = valueMap(~isnan(valueMap));
        caxis([min(re) 5*min(re)]);
    end

    fix_caxis.ApplyIfFrozen(gca); 
    
    title([name ';  '   num2str(t0b,4) ' to ' num2str(teb,4) ],'FontSize',ZmapGlobal.Data.fontsz.m,...
        'Color','w','FontWeight','bold')
    
    xlabel('Distance [km]','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Depth [km]','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    
    % plot overlay
    %
    ploeqc = plot(newa(:,end),-newa(:,7),'.k');
    set(ploeqc,'Tag','eqc_plot','MarkerSize',ZG.ms6,'Marker',ty,'Color',ZG.someColor,'Visible','on')
    
    try
        
        if exist('vox', 'var')
            plovo = plot(vox,voy,'^r');
            set(plovo,'MarkerSize',8,'LineWidth',1,'Markerfacecolor','w','Markeredgecolor','r')
            axis([ min(gx) max(gx) min(gy) max([ 1 max(gy)]) ])
            
        end
        
        if exist('maix', 'var')
            pl = plot(maix,maiy,'*k');
            set(pl,'MarkerSize',12,'LineWidth',2)
        end
        
        if exist('maex', 'var')
            pl = plot(maex,-maey,'hm');
            set(pl,'LineWidth',1,'MarkerSize',12,...
                'MarkerFaceColor','w','MarkerEdgeColor','k')
            
        end
        
        if exist('wellx', 'var')
            set(gca,'NextPlot','add')
            plwe = plot(wellx,-welly,'w')
            set(plwe,'LineWidth',2);
        end
        
    catch
    end
    
    h1 = gca;
    hzma = gca;
    
    % Create a colorbar
    %
    
    h5 = colorbar('horz');
    apo = get(h1,'pos');
    set(h5,'Pos',[0.35 0.07 0.4 0.02],...
        'FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s,'TickDir','out')
    
    rect = [0.00,  0.0, 1 1];
    axes('position',rect)
    axis('off')
    %  Text Object Creation
    txt1 = text(...
        'Position',[ 0.2 0.07 ],...
        'HorizontalAlignment','right',...
        'FontSize',ZmapGlobal.Data.fontsz.s,....
        'FontWeight','normal',...
        'String',lab1);
    
    
    % Make the figure visible
    %
    axes(h1)
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
        'FontWeight','normal','LineWidth',1,...
        'Box','on','TickDir','out','Ticklength',[0.02 0.02])
    %whitebg(gcf,[0 0 0])
    set(gcf,'Color',[ 1 1 1 ])
    figure(bmapc);
    watchoff(bmapc)
    
    
    %% ui functions
    function create_my_menu()
        add_menu_divider();
        
        add_symbol_menu('eqc_plot');
        
        options = uimenu('Label',' Select ');
        uimenu(options,'Label','Refresh ','MenuSelectedFcn',@callbackfun_001)
        uimenu(options,'Label','Select EQ in Circle (const N)',...
            'MenuSelectedFcn',@callbackfun_002)
        uimenu(options,'Label','Select EQ in Circle (const R)',...
            'MenuSelectedFcn',@callbackfun_003)
        uimenu(options,'Label','Select EQ in Circle - Overlay existing plot',...
            'MenuSelectedFcn',@callbackfun_004)
        uimenu(options,'Label','Select Eqs in Polygon - new',...
            MenuSelectedField(),{@(~,~)cb_selectPoly(false)});
        uimenu(options,'Label','Select Eqs in Polygon - hold',...
            MenuSelectedField(),{@(~,~)cb_selectPoly(true)});
        
        % Menu 'Maps'
        op1 = uimenu('Label',' Maps ');
        % A-Value map calculated by the MaxLikelihoodA...
        uimenu(op1,'Label','a-value map ',...
            'MenuSelectedFcn',@callbackfun_007)
        % B-Value map (fixed b-value by input from calc_avalgrid.m
        uimenu(op1,'Label','b-value map ',...
            'MenuSelectedFcn',@callbackfun_008)
        % Magnitude of completeness calculated by MaxCurvature
        uimenu(op1,'Label','Magnitude of completness map ',...
            'MenuSelectedFcn',@callbackfun_009)
        % Resolution estimation by mapping the needed radius to cover ni
        % earthquakes
        uimenu(op1,'Label','Resolution map',...
            'MenuSelectedFcn',@callbackfun_010)
        % Earthquake density map
        uimenu(op1,'Label','Earthquake density map',...
            'MenuSelectedFcn',@callbackfun_011)
        % Mu-value of the normal CDF
        uimenu(op1,'Label','Mu-value of the normal CDF',...
            'MenuSelectedFcn',@callbackfun_012)
        %  Sigma-value of the normal CDF
        uimenu(op1,'Label','Sigma-value of the normal CDF',...
            'MenuSelectedFcn',@callbackfun_013)
        
        
        add_display_menu(3)
    end
    
    %% callback functions
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        view_av2;
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        cicros(1);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        cicros(2);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        ZG=ZmapGlobal.Data;
        ZG.hold_state=true;
        cicros(0);
    end
    
    function cb_selectPoly(h_state)
        ZG=ZmapGlobal.Data;
        ZG.hold_state=h_state;
        [newa2,pl]=crosssel(newa);
        set(pl,'MarkerSize',5,'LineWidth',1)
        ZG.newt2=newa2;
        ZG.newcat=newa2;
        bdiff(newa2);
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1 ='a-value';
        valueMap = aValueMap;
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='b-value';
        valueMap = bValueMap;
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_009(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1 = 'Mcomp';
        valueMap = MaxCMap;
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Radius in [km]';
        valueMap = reso;
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='log(EQ per km^2)';
        valueMap = log10(ni./(reso.^2*pi));
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Mu-Value';
        valueMap = MuMap;
        view_av2(lab1,valueMap);
    end
    
    function callbackfun_013(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Sigma-Value';
        valueMap = SigmaMap;
        view_av2(lab1,valueMap);
    end
    
end

