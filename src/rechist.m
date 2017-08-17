function rechist() % autogenerated function wrapper
    % this script plots the z-values from a timecut of the map
    % Stefan Wiemer  11/94
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %Find out if figure already exists
    %
    report_this_filefun(mfilename('fullpath'));
    
    % This is the info window text
    %
    ttlStr='The Histogram Window                                ';
    hlpStr1= ...
        ['                                                '
        ' This window displays all z-values displayed in '
        ' the z-value map, therefore all teh z-values at '
        ' this specific cut in time for the applied      '
        'stastitical function.                           '];
    
    think
    watchon
    figNumber=findobj('Type','Figure','-and','Name','Histogram');
    
    %
    % Set up the Cumulative Number window
    
    if isempty(figNumber)
        hi= figure_w_normalized_uicontrolunits( ...
            'Name','Histogram',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'Visible','off', ...
            'Position',[ 200 100 ZmapGlobal.Data.map_len]);
        
        
        
    end % if fig exist
    
    figure(hi);
    clf
    
    orient tall
    rect = [0.15,  0.55, 0.70, 0.40];
    axes('position',rect)
    hold on
    [m,n] = size(re3);
    reall = reshape(re3,1,m*n);
    l = isnan(reall);
    reall(l) = [];
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
    watchoff;done
end
