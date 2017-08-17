function cicros2() % autogenerated function wrapper
    %   This subroutine "circle"  selects the Ni closest earthquakes
    %   around a interactively selected point.  Resets ZG.newcat and ZG.newt2
    %   Operates on "a".
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %  Input Ni:
    %
    report_this_filefun(mfilename('fullpath'));
    ZG=ZmapGlobal.Data;
    try
        delete(plos1)
    catch ME
        warning(ME)
    end
    
    axes(h1)
    
    titStr ='Selecting EQ in Circles                         ';
    messtext= ...
        ['                                                '
        '  Please use the LEFT mouse button              '
        ' to select the center point.                    '
        ' The "ni" events nearest to this point          '
        ' will be selected and displayed in the map.     '];
    
    zmap_message_center.set_message(titStr,messtext);
    
    % Input center of circle with mouse
    %
    [xa0,ya0]  = ginput(1);
    
    stri1 = [ 'Circle: lon = ' num2str(xa0) '; lat= ' num2str(ya0)];
    stri = stri1;
    pause(0.1)
    %  calculate distance for each earthquake from center point
    %  and sort by distance
    %
    n = length(newa(1,:));
    l = sqrt(((newa(:,n) - xa0)).^2 + ((newa(:,7) + ya0)).^2) ;
    [s,is] = sort(l);
    ZG.newt2 = newa(is(:,1),:) ;
    l =  sort(l);
    
    if met == 'ni'
        % take first ni and sort by time
        ZG.newt2 = ZG.newt2(1:ni,:);
        R2 = l(ni);
        
    elseif  met == 'ra'
        l3 = l <=ra;
        ZG.newt2 = ZG.newt2(l3,:);
        R2 = ra;
    end
    
    l =  sort(l);
    
    hold on
    [na,ma] = size(ZG.newt2);
    plot(ZG.newt2(:,ma),-ZG.newt2.Depth,'xk','EraseMode','back');
    set(gcf,'Pointer','arrow')
    
    %
    newcat = ZG.newt2;                   % resets ZG.newcat and ZG.newt2
    
    % Call program "timeplot to plot cumulative number
    %
    clear l s is
    timeplot(ZG.newt2)
    
end
