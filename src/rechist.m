function rechist() 
    % this script plots the z-values from a timecut of the map
    % Stefan Wiemer  11/94
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %Find out if figure already exists
    %
    report_this_filefun();
    
    % This is the info window text
    %
    ttlStr='The Histogram Window                                ';
    hlpStr1= ...
        ['                                                '
        ' This window displays all z-values displayed in '
        ' the z-value map, therefore all the z-values at '
        ' this specific cut in time for the applied      '
        'stastitical function.                           '];
    
    
    watchon
    hi=findobj('Type','Figure','-and','Name','Histogram');
    
    %
    % Set up the Cumulative Number window
    
    if isempty(hi)
        hi= figure_w_normalized_uicontrolunits( ...
            'Name','Histogram',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'Visible','off', ...
            'Position',position_in_current_monitor(ZG.map_len(1), ZG.map_len(2)));
        
        
        
    end % if fig exist
    
    figure(hi);
    clf
    
    orient tall
    rect = [0.15,  0.55, 0.70, 0.40];
    axes('position',rect)
    set(gca,'NextPlot','add')
    [m,n] = size(valueMap);
    reall = reshape(valueMap,1,m*n);
    reall(isnan(reall)) = [];
    %[n,x] =histogram(reall,min(reall):10:5*min(reall));
    [n,x] =hist(log10(reall),30);
    bar(x,n,'k'); %change the obsolet fillbar to bar
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')
    set(gca,'XTicklabel',[]);
    ylabel('Number ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    
    rect = [0.15,  0.10, 0.70, 0.40];
    axes('position',rect)
    bar(x,cumsum(n),'k'); %change the obsolet fillbar to bar
    xlabel('Log10(Tr)','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    ylabel('Cumulat. Number ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')
    
    
    
    set(hi,'Visible','on');
    figure(hi);
    %watchoff(zmap);
    watchoff;
end
