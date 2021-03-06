function showmovi() 
    %  this is the file showmovi.m. It displays a movie with the variable
    %  name 'm'.
    %   Stefan Wiemer 11/94
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    
    
    % This is the info window text
    %
    ttlStrmov='The Movie Window                                ';
    hlpStr1mov= ...
        ['                                                '
        ' This window displays a movie, a series of      '
        ' equivally spaced time cuts. Dispalyed are      '
        ' z-values of the selected function (e.g AS(t))  '
        ' in map view. The colorbar scaling is the same  '
        ' for eah frame, the maximum and minimum are the '
        ' overll maximum for all frames.                 '
        ' Menu options:                                  '
        '                                                '
        ' Circle: select the ni closest earthquakes to a '
        '       point selected with the mouse.           '
        ' Play:  Plays the movie. First the movie is     '
        '       loaded into the memory, then it is played'
        '       n-times (depending on the setting of the '
        '       <# of run> input box)                    '
        ' Speed: This is the number of frames per second '
        '       displayed. Your computer may not be able '
        '       to display the movie in high speed.       '
        ' Forward one frame (>) : Displays the next frame'
        ' Backward one frame: Displays the previous frame'
        ' Colormap: Seelect one of the colormaps in the  '
        '       pulldownmenu.                            '
        '                                                '];
    
    % find out if figure exists
    mov=findobj('Type','Figure','-and','Name','Movie Window');
    
    
    % Set up the Movie window Enviroment
    %
    %if isempty(mov)
    mov =   figure_w_normalized_uicontrolunits( ...
        'Name','Movie Window',...
        'NumberTitle','off', ...
        'NextPlot','new', ...
        'Visible','on', ...
        'Position',fs_m);
    
    %end % if exist
    
    figure(mov);
    set(gca,'NextPlot','add')
    mov = gcf;
    whitebg(color_fbg);
    h = gcf;
    speed = 0.5;
    clf reset
    drawnow;
    set(gcf,'resize','off');
    set(gca,'pos',rect1)
    
    axis off;
    cur_color = 'jet';
    colormap(jet);
    m0 = uicontrol('style','text','unit','norm','pos',[.06 .5 .8 .1]);
    set(m0,'string','Please Wait .... loading Data');
    set(m0,'background',color_fbg);
    drawnow;
    
    delete(m0);
    [a1,b1] = size(m);
    
    m1 = 'Loading movie to the Graphics Server ... please wait';
    
    movie(m(:,1),1,30);
    
    rect = [0.15 0.90 0.50 0.05 ];
    axes('position',rect)
    pco2 = pcolor([ZG.minc:0.1:ZG.maxc ; ZG.minc:0.1:ZG.maxc]);
    set(gca,'visible','on')
    h4 = gca;
    set(h4,'YTick',[-10 10])
    set(h4,'XTick',[-1000 1000])
    set(h4,'FontWeight','bold')
    shading flat
    
    rect = [0.15 0.90 0.50 0.05 ];
    pco5 = axes('position',rect);
    h5 = gca;
    axis([ ZG.minc ZG.maxc 0 1  ])
    set(h5,'YTick',[-10 10])
    set(h5,'FontWeight','bold')
    
    %rect = rect1;
    rect = [0.05 0.20 0.82 0.73 ];
    
    pco6 = axes('position',rect1);
    axis([min(gx) max(gx) min(gy)  max(gy) ])
    set(gca,'NextPlot','add')
    h6 = gca;
    hmo = gca;
    set(h6,'FontWeight','bold')
    
    movie(m(:,1),1,30);
    
    cs = uicontrol('style','popupmenu','string','HSV|Hot|Cool|Pink|Bone|Gary|Jet');
    set(cs,'unit','norm','pos',[.763 .05 .202 .05],...
        'callback',@callbackfun_001);
    h2 = uicontrol('style','text','unit','norm','string','Colormap');
    set(h2,'pos',[.763 .1 .2 .05],'background',color_fbg);
    
    
    frame_slide = uicontrol('style','slider','max',b1,'min',1,'uni','norm');
    set(frame_slide,'value',1,'pos',[.750 .25 .04 .5], 'callback',@callbackfun_002);
    frame = uicontrol('style','edit','value',10,'string',num2str(i), 'Callback', @callbackfun_003);
    flabel = uicontrol('style','text','units','norm','pos',[.55 .13 .2 .05]);
    set(flabel,'string','Speed','background',color_fbg);
    set(frame,'units','norm','pos',[.60 .07 .1 .05],'min',0.1,'max',30);
    
    uicontrol('style','text','units','norm','pos',[.80 .90 .20 .05],...
        'String','Forward 1 ','background',color_fbg);
    uicontrol('style','text','units','norm','pos',[.80 .80 .20 .05],...
        'String','Backward 1 ','background',color_fbg);
    
    next = uicontrol('style','pushbutton','unit','norm','pos',[0.75 .90 .04 .05]);
    set(next,'string','>','ForeGroundColor','k');
    set(next, 'callback',@callbackfun_004);
    bac = uicontrol('style','pushbutton','unit','norm','pos',[0.75 .80 .04 .05]);
    set(bac,'string','<');
    set(bac, 'callback',@callbackfun_005);
    time = uicontrol('style','edit','value',3,'string',num2str(3), 'Callback', @callbackfun_006);
    set(time,'units','norm','pos',[.23 .07 .1 .05],'min',1,'max',1000);
    tlabel = uicontrol('style','text','units','norm','pos',[.18 .13 .2 .05]);
    set(tlabel,'string','# of runs','background',color_fbg);
    start = uicontrol('style','pushbutton','unit','norm','pos',[.06 .05 .15 .1]);
    set(start,'interruptible','yes','string','Play');
    set(start, 'callback',@callbackfun_007);
    mc = 'close(gcf)';
    
    circ = uicontrol('units','norm','pos',[.40 .10 .10 .1],'style','pushbutton');
    set(circ,'string','Circle', 'callback',@callbackfun_008);
    
    set_ni = uicontrol('style','edit','value',100,'string',num2str(100));
    
    set(set_ni, 'Callback', @callbackfun_009);
    
    set(set_ni,'units','norm','pos',[.40 .02 .15 .05],'min',10,'max',10000);
    nilabel = uicontrol('style','text','units','norm','pos',[.36 .02 .04 .05]);
    set(nilabel,'string','ni:','background',color_fbg);
    
    
    uicontrol('Units','normal',...
        'Position',[.0 .95 .08 .06],'String','Close ',...
        'callback',@callbackfun_010)
    
    uicontrol('Units','normal',...
        'Position',[.0 .85 .08 .06],'String','Info ',...
        'callback',@callbackfun_011)
    
    uicontrol('Units','normal',...
        'Position',[.0 .75 .08 .06],'String','Refresh ',...
        'callback',@callbackfun_012);
    
    %si = signatur('ZMAP','',[0.01 0.02]);
    %set(si,'Color','k')
    
    axes(h6);
    watchoff(mess)
    watchoff(mov)
    
    
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        v = get(cs,'value');
        cur_color=lower(v);
        colormap(cur_color);
        movie(m(:,i),1,1);
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        i=(get(frame_slide,'Value'));
        movie(m(:,i),1,1);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        speed=str2double(frame.String);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        i=i+1;
        if i > b1
            i=b1;
        end
        movie(m(:,i),1,1);
        frame_slide.Value=i;
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        i=i-1;
        if i < 1
            i=1;
        end
        movie(m(:,i),1,1);
        frame_slide.Value=i;
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        set(time,'Value',str2double(get(time,'string')));
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        disp(m1);
        movie(m,fix(get(time,'value')*15/size(m,2)),speed);
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        circmo;
    end
    
    function callbackfun_009(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ni=str2double(set_ni.String);
        set_ni.String=num2str(ni);
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        clear m;
        close(mov);
        
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmaphelp(ttlStrmov,hlpStr1mov);
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        showmovi;
    end
    
end
