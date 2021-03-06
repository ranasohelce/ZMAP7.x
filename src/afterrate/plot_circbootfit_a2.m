function plot_circbootfit_a2() 
    % plot_circbootfit_a2 Selects earthquakes in the radius ra around a grid node
    % Jochen Woessner
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    
    ShapeGeneral.clearplot(); % was axes h1, tag plos1
    
    
    % interactively get the circle of interest
    shape=ShapeCircle();
    [ZG.newt2, max_km] = selectCircle(newa, shape.toStruct());
    
    fprintf('Radius of selected Circle: %s km\n', num2str(max_km) );
    
    %  Calculate distance for each earthquake from center point
    %  and sort by distance l
    % Calculate distance from center point and sort with distance
    sFigName = get(gcf,'Name')
    
    %if (sFigName == 'Omoricros-section' | sFigName == 'RC-Cross-section')
    if ~bMap    % Cross section
        ZG.newt2 = newa;
        l = sqrt(((xsecx' - xa0)).^2 + (((xsecy+ya0))).^2) ;
    else % Map view
        ZG.newt2 = a;
        l = ZG.newt2.epicentralDistanceTo(ya0,xa0);
    end
    
    ZG.newt2=ZG.newt2.subset(l); % reorder & copy
    
    % Select data in radius ra
    l3 = l <= ra;
    ZG.newt2 = ZG.newt2(l3,:); %FIXME
    
    % Select radius in time
    newt3=ZG.newt2;
    vSel = (ZG.newt2.Date <= ZG.maepi.Date + days(time));
    ZG.newt2 = ZG.newt2.subset(vSel);
    R2 = l(ni);
    fprintf('Number of selected events: %d\n', ZG.newt2.Count);
    
    
    % Sort the catalog
    ZG.newt2.sort('Date')
    R2 = ra;
    
    
    % Plot selected earthquakes
    shape.plot([],ZG.newt2); % linespec was xk, tag was plos1
    
    % Compute and Plot the forecast
    %calc_bootfitF(newt3.Date,time,timef,bootloops,ZG.maepi.Date)
    plot_bootfitloglike_a2(newt3,time,timef,bootloops,ZG.maepi);
    
    ZG.newcat = ZG.newt2;
    ctp=CumTimePlot(ZG.newt2);
    ctp.plot();
    
end
