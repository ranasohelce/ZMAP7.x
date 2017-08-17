function chooseint() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    
    sl2 = figure_w_normalized_uicontrolunits( ...
        'Name','Slice',...
        'NumberTitle','off', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','on', ...
        'Position',[ (fipo(3:4) - [600 500]) ZmapGlobal.Data.map_len]);
    
    
    
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.0 .94 0.10 .06],'String',' Topo (contour) ',...
        'callback',@callbackfun_001)
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.0 .88 0.10 .06],'String',' Topo (render) ',...
        'callback',@callbackfun_002)
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.0 .80 0.10 .06],'String',' Topo (render2) ',...
        'callback',@callbackfun_003)
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.0 .0 0.1 .04],'String','Fix View ',...
        'callback',@callbackfun_004)
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.1 .0 0.1 .04],'String','Max R ',...
        'callback',@callbackfun_005)
    
    uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
        'Position',[.9 .0 0.15 .04],'String','Fix color scale ',...
        'callback',@callbackfun_006)
    
    
    labelList=[' flat | interp | faceted '];
    labelPos = [0.9 0.93 0.10 0.05];
    hndl3=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_007);
    
    
    labelList=[' hsv | hot | jet | cool | pink | gray | bone | invjet  '];
    labelPos = [0.9 0.85 0.10 0.05];
    hndl2=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_008);
    
    labelList=[' Above  | NS | EW | angle'];
    labelPos = [0.9 0.75 0.10 0.05];
    hndl1=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_009);
    
    
    labelList=[' EQ  | No EQ '];
    labelPos = [0.9 0.65 0.10 0.05];
    hndl4=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_010);
    
    
    labelList=[' Faults  | No Faults '];
    labelPos = [0.9 0.55 0.10 0.05];
    hndl5=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_011);
    
    
    
    labelList=[' Coast  | No Coast '];
    labelPos = [0.9 0.45 0.10 0.05];
    hndl6=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_012);
    
    
    
    
    labelList=[' Main  | No Main '];
    labelPos = [0.9 0.35 0.10 0.05];
    hndl7=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_013);
    
    labelList=[' Well | No Well '];
    labelPos = [0.9 0.25 0.10 0.05];
    hndl7=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_014);
    
    
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('topo');
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('topos');
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('topos2');
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('equal');
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('setr');
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myslicer('setc');
    end
    
    function callbackfun_007(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva1'
        in3 =get(hndl3,'Value');
        if in3 == 1 ; shading flat ; end
        if in3 == 2 ; shading interp ; end
        if in3 == 3 ; shading faceted ; end
    end
    
    function callbackfun_008(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        %  case 'eva2'
        in3 =get(hndl2,'Value');
        if in3 == 1 ; colormap(hsv) ; end
        if in3 == 2 ; colormap(hot) ; end
        if in3 == 3 ; colormap(jet) ; end
        if in3 == 4 ; colormap(cool) ; end
        if in3 == 5 ; colormap(pink) ; end
        if in3 == 6 ; colormap(gray) ; end
        if in3 == 7 ; colormap(bone) ; end
        if in3 == 8; co = jet; co = co(64:-1:1,:); colormap(co) ; end
    end
    
    function callbackfun_009(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva3'
        in3 =get(hndl1,'Value');
        if in3 == 1 ; view([-90 90]) ; end
        if in3 == 2 ; view([-90 0]) ; end
        if in3 == 3 ; view([0  0]) ; end
        if in3 == 4 ; view([-120  25]) ; end
    end
    
    function callbackfun_010(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva4'
        in3 =get(hndl4,'Value');
        if in3 == 1 ; ploe = plot3(ZG.a.Latitude,ZG.a.Longitude,-ZG.a.Depth,'.w','MarkerSize',1) ; end
        if in3 == 2 ; delete(ploe);  end
    end
    
    function callbackfun_011(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva5'
        in3 =get(hndl5,'Value');
        if in3 == 1 ; plof = plot3(faults(:,2),faults(:,1),faults(:,1)*0,'m') ; end
        if in3 == 2 ; delete(plof) ; end
    end
    
    function callbackfun_012(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'ev6'
        in3 =get(hndl6,'Value');
        if in3 == 1 ; ploc = plot3(coastline(:,2),coastline(:,1),coastline(:,1)*0,'w','Linewidth',2) ; end
        if in3 == 2 ; delete(ploc) ; end
    end
    
    function callbackfun_013(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva7'
        in3 =get(hndl7,'Value');
        if in3 == 1
            epimax2 = plot3(ZG.maepi.Latitude,ZG.maepi.Longitude,-ZG.maepi.Depth,'hm');
            set(epimax2,'LineWidth',1.5,'MarkerSize',12,...
                'MarkerFaceColor','y','MarkerEdgeColor','k')
        end
    end
    
    function callbackfun_014(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        % case 'eva8'
        in3 =get(hndl7,'Value');
        if in3 == 1
            l = well(:,1) >= ax(3) & well(:,1) <= ax(4) & well(:,2) >= ax(1)  & well(:,2) <= ax(2) & ...
                -well(:,3) >= ax(5) & -well(:,3) <= ax(6) |  isinf(well(:,1)) == 1 ;
            epimax2 = plot3(well(l,2),well(l,1),-well(l,3),'w');
            set(epimax2,'LineWidth',2);
        end
        if in3 == 2 ; delete(epimax2) ; end
    end
    
end
