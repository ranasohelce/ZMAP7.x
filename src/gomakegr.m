function gomakegr() % autogenerated function wrapper
    % This M-file displays a message, then calls makegrid to produce a grid and
    % calculate Cumulative Number curves.
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    clf
    set(gca,'visible','off');
    gh = gcf;
    
    txt4  = text(...
        'Position',[0.0 0.65 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'Please wait until cursor changes to a CROSS');
    
    txt4B = text(...
        'Position',[0.0 0.58 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'and select the edges of a polygon    ');
    txt4 = text(...
        'Position',[0.0 0.51 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'on the map (using the left mouse buton).');
    txt4B  = text(...
        'Position',[0.0 0.36 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'Mac Users: Use the character "p" on your      ');
    txt4  = text(...
        'Position',[0.0 0.29 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'keyboard. Use the right mouse button to seletct ');
    txt4B  = text(...
        'Position',[0.0 0.22 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String', 'the final point (or charcter "l")           ');
    
    pause(0.1)
    makegrid
    
end
