function plotmainmap(obj)
    % PLOTMAINMAP set up main map window
    
    % TAG : PURPOSE
    % "active quakes" : selected events
    % "big evens" : selected events, above a threshhold magnitude
    
    % %
    % this probably belongs somewhere else...
    if ~isempty(obj.shape) && ~isvalid(obj.shape)
        msg.dbdisp('shape had been deleted');
        obj.shape = ShapeGeneral();
    end
    % %
    axm = obj.map_axes;
    axm.Visible = 'off';
    if isempty(axm)||~isvalid(axm)
        error('Somehow lost track of main map');
    end
    
    % update the active earthquakes
    eq=findobj(axm,'Tag','active quakes');
    
    mainEventOpts = obj.mainEventProps; % local copy
    szFcn = str2func(mainEventOpts.MarkerSizeFcn);
    
    if mainEventOpts.UseDotsForTooManyEvents && obj.catalog.Count > mainEventOpts.HowManyAreTooMany
        mainEventOpts.Marker = '.';
    end
    if isempty(eq) 
        % CREATE the plot
        
        axm.NextPlot='add';
        dispname = replace(obj.catalog.Name,'_','\_');
        
        szFcn = str2func(mainEventOpts.MarkerSizeFcn);
        eq=scatter(axm, obj.catalog.X, obj.catalog.Y, ...
            szFcn(obj.catalog.Magnitude), getLegalColors(),...
            'Tag','active quakes',...
            'HitTest','off',...
            'DisplayName',dispname);
        eq.ZData = obj.catalog.Z;
        axm.NextPlot='replace';
        %obj.do_colorbar(axm);
        
    else
        
        % REUSE the plot
        eq.XData = obj.catalog.X;
        eq.YData = obj.catalog.Y;
        eq.ZData = obj.catalog.Z;
        eq.SizeData = szFcn(obj.catalog.Magnitude);
        eq.MarkerEdgeColor='flat';
        eq.CData = getLegalColors();
        
        % this is a kludge, because if a MarkerEdgeColor is defined that isn't specifically 'flat'
        % then it overrides the CData colors.
        if size(eq.CData(:,1)) > 1
            mainEventOpts=renameStructField(mainEventOpts,'MarkerEdgeColor','Marker_Edge_Color');
        else
            mainEventOpts=renameStructField(mainEventOpts,'Marker_Edge_Color','MarkerEdgeColor');
        end
        dispname = replace(obj.catalog.Name, '_', '\_');
        if ~strcmp(eq.DisplayName, dispname)
            eq.DisplayName = dispname;
        end
    end
    
    fix_colorbar()
        
    set_valid_properties(eq, mainEventOpts);
    
    % update the largest events
    update_large()
    
    % update the shape
    axm.NextPlot='add';
    if ~isempty(obj.shape)
        obj.shape.plot(axm);
    end
    axm.NextPlot='replace';
    
    % update the grid
    if ~isempty(obj.Grid)
        if isempty(obj.shape) && all(obj.Grid.ActivePoints(:))
            % do nothing needs to be done.
            obj.Grid.plot(obj.map_axes, 'HitTest', 'off', 'ActiveOnly');
        else
            maskedGrid = obj.Grid.MaskWithShape(obj.shape);
            if ~isequal(maskedGrid.ActivePoints, obj.Grid.ActivePoints)
                obj.Grid.ActivePoints = maskedGrid.ActivePoints;
                obj.Grid.plot(obj.map_axes, 'HitTest', 'off', 'ActiveOnly');
            end
        end
    end
    axm.Visible='on';
    
    function update_large()
        beq = findobj(axm,'Tag','big events');
        
        if ~isempty(obj.bigEvents)
            beq.XData = obj.bigEvents.X;
            beq.YData = obj.bigEvents.Y;
            beq.ZData = obj.bigEvents.Z;
            beq.SizeData=mag2dotsize(obj.bigEvents.Magnitude);
        else
            [beq.XData, beq.YData, beq.ZData, beq.SizeData]=deal([]);
        end
        
    end
    
    function c = getLegalColors()
        % because datetime isn't allowed
        switch  obj.colorField
            case '-none-'
                c=[0 0 .15];
            case 'Date'
                c=datenum(obj.catalog.Date);
            otherwise
                c=obj.catalog.(obj.colorField);
        end
    end
    
    function fix_colorbar()
        h = obj.map_axes.Colorbar;
        if isempty(h) && obj.colorField ~= "-none-"
            h = colorbar(obj.map_axes);
        end
        
        if isempty(h) || h.Label.String == string(obj.colorField)
            return
        end
        
        h.Label.String = obj.colorField;
        
        switch obj.colorField
            case '-none-'
                delete(h)
                
            case 'Depth'
                h.Direction = 'reverse';
                h.TickLabels = h.Ticks;
                
                
            case 'Date'
                    h.TickLabels   = datestr(h.Ticks,'yyyy-mm-dd');
                    h.Label.String = 'Date';
                    h.Direction    = 'normal';
                    
            otherwise
                h.Direction = 'normal';
                h.TickLabels = h.Ticks;
        end 
            
    end
    
end