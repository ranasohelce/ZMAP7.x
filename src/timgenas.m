function timgenas(gx,gy) 
    %   To display mean Z values resulted from the genascumu at a selected
    %   time
    %                                                          R.Z. 5/94
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    
    it = t0b + 1;
    mess = findobj(allchild(groot),'flat','Name','GenAS-Grid Time Selection');
    if isempty(mess)
        mess=figure('Name','GenAS-Grid Time Selection');
    end
    clf
    set(gca,'visible','off')
    set(mess,'pos',[ 0.02  0.9 0.3 0.35])
    
    inp5=uicontrol('Style','edit','Position',[.70 .50 .22 .06],...
        'Units','normalized','String',num2str(it),...
        'callback',@callbackfun_001);
    
    txt5 = text(...
        'Position',[0.02 0.52 0 ],...
        'String','Time to display (e.g. 84.537): ');
    
    close_button = uicontrol('Units','normal','Position',...
        [.1 .7 .2 .12],'String','Close ', 'Callback',@(~,~)close());
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.35 .22 .20 .10 ],...
        'Units','normalized',...
        'callback',@redisplay_me,...
        'String','Display');
    
    
    function redisplay_me(mysrc,~)
        stri = 'Map of mean Z at time T';
        it = (it -t0b)/days(ZG.bin_dur);
        stri2 = ['ti=' num2str(it*days(ZG.bin_dur) + t0b)  ];
        meanZ_it = Zsumall(it,:);                         % pick meanZ at time it
        
        valueMap = reshape(meanZ_it,length(gy),length(gx));
        
        view_max(valueMap,gx,gy,stri,'')
        clear meanZ_it;
    end
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        it=mysrc.Value;
    end
    
end
