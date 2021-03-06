function lammap() 
    % This is  the m file lammap.m. It will display a map view of the
    % seismicity in Lambert projection and ask for two input
    % points select with the cursor. These input points are
    % the endpoints of the crossection.
    %
    % Stefan Wiemer 2/95
    % turned into function by Celso G Reyes 2017
    
    global mapl
    global h2 newa
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    %
    % Find out if figure already exists
    %
    mapl=findobj('Type','Figure','-and','Name','Seismicity Map (Lambert)');
    
    
    % Set up the Seismicity Map window Enviroment
    %
    if isempty(mapl)
        mapl = figure_w_normalized_uicontrolunits( ...
            'Name','Seismicity Map (Lambert)',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',position_in_current_monitor(ZG.map_len(1), ZG.map_len(2)));
        
        
        drawnow
    end % if figure exist
    
    figure(mapl);
    delete(findobj(mapl,'Type','axes'));
    
    plotmap();
    %{
    if isempty(coastline)
        coastline = [ZG.primeCatalog.Longitude(1) ZG.primeCatalog.Latitude(1)]
    end
    set(gca,'NextPlot','add')
    if length(coastline) > 1
        lc_map(coastline(:,2),coastline(:,1),s3_north,s4_south,s1_east,s2_west)
        g = allchild(gca);
        set(g,'Color','k')
    end
    set(gca,'NextPlot','add')
    if length(faults) > 10
        lc_map(faults(:,2),faults(:,1),s3_north,s4_south,s1_east,s2_west)
    end
    set(gca,'NextPlot','add')
    if ~isempty(mainfault)
        lc_map(mainfault(:,2),mainfault(:,1),s3_north,s4_south,s1_east,s2_west)
    end
    lc_event(ZG.primeCatalog.Latitude,ZG.primeCatalog.Longitude,'.k')
    if ~isempty(ZG.maepi)
        lc_event(ZG.maepi.Latitude,ZG.maepi.Longitude,'xm')
    end
    if ~isempty(main)
        lc_event(main(:,2),main(:,1),'+b')
    end
    %title(strib,'FontWeight','bold',...
    %'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k')
    %}
    
    uic = uicontrol('Units','normal',...
        'Position',[.05 .00 .40 .06],'String','Select Endpoints with cursor');
    
    titStr ='Create Crossection                      ';
    
    messtext= ...
        ['                                                '
        '  Please use the LEFT mouse button              '
        ' to select the two endpoints of the             '
        ' crossection                                    '
        ];
    
    msg.dbdisp(messtext, titStr);
    
    
    [xsecx xsecy,  inde] = mysect(ZG.primeCatalog.Latitude',ZG.primeCatalog.Longitude',ZG.primeCatalog.Depth,ZG.xsec_defaults.WidthKm);
    
    %if ~isempty(ZG.maepi)
    % [maex, maey] = lc_xsec2(ZG.maepi.Latitude',ZG.maepi.Longitude',ZG.maepi.Depth,ZG.xsec_defaults.WidthKm,leng,lat1,lon1,lat2,lon2);
    %end
    
    if ~isempty(main)
        [maix, maiy] = lc_xsec2(main(:,2)',main(:,1)',main(:,3),ZG.xsec_defaults.WidthKm,leng,lat1,lon1,lat2,lon2);
        maiy = -maiy;
    end
    delete(uic)
    
    uic3 = uicontrol('Units','normal',...
        'Position',[.80 .88 .20 .10],'String','Make Grid',...
        'callback',@cb_make_grid);
    
    uic4 = uicontrol('Units','normal',...
        'Position',[.80 .68 .20 .10],'String','Make b cross ',...
        'callback',@cb_make_b_cross);
    uic5 = uicontrol('Units','normal',...
        'position',[.8 .48 .2 .1],'String','Select Eqs',...
        'callback',@cb_select_eq);
    
    figure(mapl);
    uic2 = uicontrol('Units','normal',...
        'Position',[.70 .92 .30 .06],'String','New selection ?',...
        'callback',@cb_new_selection);
    set_width = uicontrol('style','edit','value',ZG.xsec_defaults.WidthKm,...
        'string',num2str(ZG.xsec_defaults.WidthKm), 'background','y',...
        'units','norm','pos',[.90 .00 .08 .06],'min',0,'max',10000,...
        'callback',@callbackfun_005);
    
    wilabel = uicontrol('style','text','units','norm','pos',[.60 .00 .30 .06]);
    set(wilabel,'string','Width in km:','background','y');
    
    % create the selected catalog
    %
    newa  = ZG.primeCatalog.subset(inde);
    newa = [newa xsecx'];
    % call the m script that produces a grid
    sel = 'in';
    
    function cb_make_grid(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        magrcros();
    end
    
    function cb_make_b_cross(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        bcross();
    end
    
    function cb_select_eq(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        newa2=crosssel(newa);
        ZG.newcat=newa ;
        replaceMainCatalog(newa);
        zmap_update_displays();
    end
    
    function cb_new_selection(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        delete(uic2);
        lammap;
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.xsec_defaults.WidthKm=str2double(set_width.String);
    end
    
end
