classdef ZmapCatalogView
    % ZmapCatalogView provides a way to interact with one of the global catalogs without copying it
    % filters can be applied, and it can be plotted
    % if filters are changed, the plot automatically changes, too.
    % other than changing the filters and a few plotting properties, the view is read-only,
    % and depends entirely upon the global catalog upon which it is based
    %
    % obj=ZmapCatalogView(cataccessfn)
    % obj=ZmapCatalogView(cataccessfn,Name1,Property1,...), where vald property names can be seen with
    %    ZmapCatalogView.ValidProps.  Properties are case sensitive.
    %
    % ex
    %   zcv = ZmapCatalogView(@()ZmapGlobal.Data.primeCatalog) % creates a view into ZmapGlobal.Data.primeCatalog
    %   zcv.linkedplot(gca,'zcv'); %  plot onto current axis
    %   zcv.MagnitudeLims=[2 3]; %set filter to show mags >=2 and <=3.  map updates automatically*
    %
    %   minicat = zcv.Catalog(); %get the catalog that matches the filters
    %
    % *beware that there might be an issue with variable name scope.
    %
    % zcv = zcv.reset(); %return to original ranges
    %
    % Polygons
    %
    % additionally, the view can be filtered using a polygon, where polygon is a struct or class
    % with a field/property "points". points is [lon1 , lat1; ...; lonN, latN]
    %
    % ZmapCatalogView.PolygonApply(poly, in_or_out)  : creates a polygon mask
    % ZmapCatalogView.PolygonRemove : removes the polygon filter
    % ZmapCatalogView.PolygonInvert : Inverts the polygon filter
    %
    % ZmapCatalogView properties:
    %
    %     source - function that when called returns the desired catalog
    %     ViewName - name given to this view for plotting
    %     DateLims - [mindate maxdate] as dateime
    %     MagnitudeLims - [minmag maxmag]
    %     LatitudeLims- [minlat maxlat]
    %     LongitudeLims - [minlon maxlon] % doesn't take dateline into account
    %     DepthLims - [mindepth maxdepth]
    %     Marker - default marker used when plotting this view
    %     MarkerSize - default marker size for plotting
    %     MarkerFaceColor - default marker fill for plotting
    %     MarkerEdgeColor - default marker outline for plotting
    %     DisplayName - name used in the legend for this view
    %     Tag - tag used for finding plotted versions of this view via findobj
    %
    %     Name - catalog's Name
    %     Date - Date for each event in this view [read-only]
    %     Latitude - Latitude for each event in this view [read-only]
    %     Longitude - Longitude for each event in this view [read-only]
    %     Depth - Depth for each event in this view, km [read-only]
    %     Count - Count for each event in this view [read-only]
    %     Magnitude - Magnitude for each event in this view [read-only]
    %     MagnitudeType - Magnitude for each event in this view [read-only]
    %
    %
    % ZmapCatalogView protected properties:
    %
    %   mycat - provides access to the underlying catalog [read only]
    %   filter - logical mask, true where events meet all range & polygon criteria
    %   polymask - logical mask, true where events are within(???) polygon
    %   polygon - [Nx2] containing polygon.Latitude & polygon.Longitude
    %
    %   (???) - OR outside polygon, depending on PolygonInvert
    % ZmapCatalogView methods:
    %
    %   ZmapCatalogView - create a view from either global catalog or another view
    %
    %   Catalog - get a ZmapCatalog created from this view
    %   cat - combine catalogs or catalog views (returns a catalog, not a view)
    %
    %   reset - reset all the ranges to their original values
    %   isempty - returns true if this view contains no events
    %
    %   Plotting Routines:
    %   linkedplot - plot this view, but plot will autoupdate when view changes
    %   plot - plot this view (catalog)
    %   plotm - plot this view (catalog) on a map
    %
    %   disp - display this view
    %   trace - trace shows this and all Catalogs / Views from which this is descended
    %
    %   subset - get a catalog that is a subset of this view (catalog) via logical/numeric indexing
    %
    %   ZmapCatalogView polygon routines:
    %   PolygonApply - further masks the view with a polygon. Events must be inside/outside polygon
    %   PolygonRemove - clears the polygon, so that
    %   PolygonInvert - changes whether events must be inside or outside polygon
    %
    % see also ZmapCatalog
    
    
    properties
        % source - name of catalog's global variable, for example 'primeCatalog',
        % which means the original catalog can be found in ZmapData.primeCatalog
        source function_handle % a function that when called returns the desired catalog . ex source=@()ZmapGlobal.Data.primeCatalog
        
        ViewName (1,:) char % name given to this view for plotting
        
        DateLims (2,1) datetime % [mindate maxdate] as dateime
        MagnitudeLims (2,1) double % [minmag maxmag]
        LatitudeLims (2,1) double % [minlat maxlat]
        LongitudeLims (2,1) double % [minlon maxlon] % doesn't take dateline into account
        DepthLims (2,1) double % [mindepth maxdepth]
        
        sortby='';
        Marker=''
        MarkerSize=[]
        MarkerFaceColor=[]
        MarkerEdgeColor=[]
        DisplayName='unset';
        Tag='unset';
        
    end
    properties(Constant)
        ValidProps = {'Marker';'MarkerSize';'MarkerFaceColor';'MarkerEdgeColor';'DisplayName';'Tag'};
    end
    
    properties(Dependent)
        Name % catalog name, (augmented by view?)
        Date % Date for each event in this view
        Latitude % Latitude for each event in this view
        Longitude % Longitude for each event in this view
        Depth % Depth for each event in this view, km
        Count % Count for each event in this view
        Magnitude % Magnitude for each event in this view
        MagnitudeType % Magnitude for each event in this view
    end
    
    properties(Access=protected)
        mycat % the actual catalog. [read only]
        filter
        polymask = []; % logical mask
        polygon=struct('Latitude',[],'Longitude',[]); % polygon.Latitude & polygon.Longitude
    end
    
    methods
        function obj=ZmapCatalogView(sourcefn,varargin)
            %
            % sourcefn is a function handle, that when called returns the desired catalog .
            %     ex.
            %        sourcefn=@()ZmapGlobal.Data.primeCatalog
            %        obj=ZmapCatalogView(sourcefn);
            % obj=ZmapCatalogView(sourcefn ,Name1,Property1,...)
            %
            % see properties for valid arguments
            obj.source=sourcefn;
            obj.ViewName = obj.mycat.Name;
            obj=obj.reset();
            
            
            %these are allowed to be created with the view
            while ~isempty(varargin)
                if ~ismember(varargin{1},obj.ValidProps)
                    disp(obj.ValidProps);
                    error('invalid Argument [%s]',varargin{1});
                end
                try
                    obj.(varargin{1})=varargin{2};
                catch
                    error('problem parsing ZmapCatalogView argument or its value : [%s]',varargin{1});
                end
                varargin(1:2)=[];
            end
        end
        
        function n=get.Name(obj)
            n=obj.ViewName;
        end
        function obj=set.Name(obj, name)
            obj.ViewName=name;
        end
        function c = get.mycat(obj)
            % MYCAT get the catalog using the provided function
            c=obj.source();
        end
        
        
        function obj=reset(obj)
            % reset all the ranges to their original values
            obj.DateLims            = bounds2(obj.mycat.Date);
            obj.MagnitudeLims       = bounds2(obj.mycat.Magnitude);
            obj.LatitudeLims        = bounds2(obj.mycat.Latitude);
            obj.LongitudeLims       = bounds2(obj.mycat.Longitude) ;
            obj.DepthLims           = bounds2(obj.mycat.Depth);
            obj = obj.PolygonRemove();
        end
        
        function f = get.filter(obj)
            f = in_range_inclusive(obj.mycat.Latitude   , obj.LatitudeLims)     &...
                in_range_inclusive(obj.mycat.Longitude  , obj.LongitudeLims)    &...
                in_range_inclusive(obj.mycat.Magnitude  , obj.MagnitudeLims)    &...
                in_range_inclusive(obj.mycat.Depth      , obj.DepthLims)        &...
                in_range_inclusive(obj.mycat.Date       , obj.DateLims);
            if ~isempty(obj.polymask)
                if numel(f) ~= numel(obj.polymask)
                    warning('mask and events out of sync. loosing polygon mask')
                    obj=obj.PolygonRemove();
                else
                    f=f & obj.polymask;
                end
            end
            if ~isempty(obj.sortby)
                [~,idx]=sort(obj.mycat.(obj.sortby));
                % f(idx) is the t/f value for the sorted index
                f=idx(f(idx)); % returns numeric index of sorted values
            end
            
            
        end
        
        function obj = sort(obj,field)
            if isempty(field)
                obj.sortby='';
            elseif isprop(obj,field)
                obj.sortby=field;
            else
                error('cannot sort by : %s',field);
            end
            
        end
        function lat=get.Latitude(obj)
            lat=obj.mycat.Latitude(obj.filter);
        end
        
        function mt=get.MagnitudeType(obj)
            mt = obj.mycat.MagnitudeType(obj.filter);
        end
        
        function obj=set.LatitudeLims(obj,val)
            % change the latitude ranges.
            % setting to [] will reset to the catalog's min/max values
            if isempty(val)
                val = bounds2(obj.mycat.Latitude);
            end
            obj.LatitudeLims = val;
        end
        
        function lon=get.Longitude(obj)
            lon = obj.mycat.Longitude(obj.filter);
        end
        
        function obj=set.LongitudeLims(obj,val)
            % change the longitude ranges.
            % setting to [] will reset to the catalog's min/max values
            if isempty(val)
                val = bounds2(obj.mycat.Longitude);
            end
            obj.LongitudeLims = val;
        end
        
        
        
        function mag=get.Magnitude(obj)
            mag=obj.mycat.Magnitude(obj.filter);
        end
        
        function obj=set.MagnitudeLims(obj,val)
            % change the magnitude ranges.
            % setting to [] will reset to the catalog's min/max values
            if isempty(val)
                val = bounds2(obj.mycat.Magnitude);
            end
            obj.MagnitudeLims = val;
        end
        
        
        function d=get.Date(obj)
            d=obj.mycat.Date(obj.filter);
        end
        
        function obj=set.DateLims(obj,val)
            % change the date range
            % setting to [] will reset to the catalog's min/max values
            
            if ~isa(obj.DateLims,'datetime') || isempty(val)
                val = bounds2(obj.mycat.Date);
            end
            obj.DateLims=val;
        end
        
        function d=get.Depth(obj)
            d = obj.mycat.Depth(obj.filter);
        end
        
        function obj=set.DepthLims(obj,val)
            % change the depth ranges. setting to [] will reset to the catalog's min/max values
            if isempty(val)
                [val(1),val(2)] = bounds(obj.mycat.Depth);
            end
            obj.DepthLims=val;
        end
        
        function cnt=get.Count(obj)
            % return number of events represented by this view
            cnt=sum(obj.filter);
        end
        
        %% plotting routines
        function linkedplot(obj,ax, mysource, varargin)
            % LINKEDPLOT plot this on an axes, linking the data so that range changes are reflected on the plot
            % linkedplot(obj,ax, mysource, varargin)
            % ax is the valid axis, and will be held before plotting
            % mysource is a string that evaluates into this object for linking
            % vararign are additional aprameters passed tot he set plot
            %
            % data is NOT automatically linked. use linkdata on to turn on the linking
            % see also linkdata
            
            % build up additional features
            v = {};
            s = mysource;
            for i=1:numel([obj.ValidProps])
                prop = obj.ValidProps{i};
                val = obj.(prop);
                if ~isempty(val)
                    v= [v,{prop,val}]; %#ok<AGROW>
                end
            end
            h=ishold(ax);
            ax.NextPlot='add';
            p=plot(ax,0,0,'o');
            set(p,...
                'YData',obj.Latitude, ...
                'XData',obj.Longitude,...
                'Zdata', obj.Depth, ...
                'YDataSource',[s '.Latitude'],...
                'XDataSource',[s '.Longitude'],...
                'ZDataSource',[s '.Depth'], v{:}, varargin{:});
            
            hold(ax,tf2onoff(h));
            %linkdata on
        end
        
        function rt = relativeTimes(obj, other)
            % relativeTimes
            % rt = obj.relativeTimes() get times relative to start
            % rt = obj.relativeTimes(other) get times relative to another time
            
            if ~exist('other','var')
                rt = obj.Date - min(obj.Date);
                return
            end
            switch class(other)
                case 'datetime'
                    rt = obj.Date - datetime;
                otherwise
                    error('do not know how to compare to a .. try giving a specific date');
            end
        end
        
        function h=plot(obj, ax, varargin)
            % PLOT this catalog. It will plot on
            % h=plot (obj,ax, varargin)
            %
            % see also refreshPlot
            
            % build up additional features
            v={};
            for i=1:numel([obj.ValidProps])
                prop = obj.ValidProps{i};
                val = obj.(prop);
                if ~isempty(val)
                    v=[v,{prop,val}]; %#ok<AGROW>
                end
            end
            h=plot(ax,0,0,'o'); % was p
            set(h,...
                'YData',obj.Latitude, ...
                'XData',obj.Longitude,...
                'Zdata', obj.Depth, ...
                v{:}, varargin{:});
            %hold(ax,tf2onoff(h));
            axes(ax)
        end
        
        
        function h=plotm(obj,ax, varargin)
            % plot this layer onto a map (Requires mapping toolbox)
            % will delete layer if it exists
            % note features will only plot the subset of features within the
            % currently visible axes
            %
            % see also refreshPlot
            
            
            if isempty(ax) || ~isvalid(ax) || ~ismap(ax)
                error('Feature "%s" ->plot has no associated axis or is not a map',obj.mycat.Name);
            end
            
            hastag=find(strcmp('Tag',varargin));
            if ~isempty(hastag)
                mytag=varargin{hastag}+1;
            else
                mytag=['catalog_',obj.mycat.Name];
                varargin(end+1:end+2)={'Tag',mytag};
            end
            
            h = findobj(ax,'Tag',mytag);
            if ~isempty(h)
                delete(h);
            end
            
            holdstatus = ishold(ax); 
            ax.NextPlot='add';
            h=plotm(obj.Latitude, obj.Longitude, '.',varargin{:});
            set(h, 'ZData',obj.Depth);
            set(ax,'ZDir','reverse');
            daspectm('km');
            hold(ax,tf2onoff(holdstatus));
            
        end
        
        %% in-out routines
        function c=Catalog(obj)
            % get the subset catalog represented by this view
            c=obj.mycat.subset(obj.filter);
            c.Name=obj.ViewName;
        end
        
        function c=subset(obj,idx)
            %return a subsetted catalog from this view
            c=obj.mycat.subset(obj.filter);
            c=c.subset(idx);
        end
        
        function c=cat(obj, otherobj)
            % combine catalogs or catalog views
            if isa(obj,'ZmapCatalogView')
                if isa(otherobj,'ZmapCatalogView')
                    c=cat(obj.Catalog(),otherobj.Catalog());
                else
                    c=cat(obj.Catalog(),otherobj);
                end
            else
                c=cat(obj,otherobj.Catalog());
            end
        end
        function disp(obj)
            fprintf('  View Name: %s  [Cat Name: %s]\n',obj.Name, obj.mycat.Name);
            fprintf('  source fn: %s\n',char(obj.source));
            % DISP display the ranges used to view a catalog. The actual catalog dates do not need to match
            
            fprintf('      Count: %d events\n',obj.Count);
            fprintf('      Dates: %s to %s\n', char(obj.DateLims(1),'uuuu-MM-dd HH:mm:ss'),...
                char(obj.DateLims(2),'uuuu-MM-dd HH:mm:ss'));
            magtypes =strjoin(string(unique(obj.mycat.MagnitudeType(obj.filter))),',');
            if ismissing(magtypes),magtypes="unk";end
            disp('Filter ranges for this catalog view are set to:');
            % actual catalog will have ranges inside and out
            fprintf(' Magnitudes: %.4f to %.4f  [%s]\n',...
                obj.MagnitudeLims, char(magtypes));
            
            fprintf('  Latitudes: %.4f to %.4f  [deg]\n', obj.LatitudeLims);
            fprintf(' Longitudes: %.4f to %.4f  [deg]\n', obj.LongitudeLims);
            fprintf('     Depths: %.2f to %.2f  [km]\n', obj.DepthLims);
            fprintf('     Symbol: marker ''%s'', size: %.1f\n', obj.Marker, obj.MarkerSize);
            if ~isempty(obj.polymask)
                disp('     Polygon filtering in effect');
            end
            if ~isempty(obj.sortby)
                disp(['  sorted by: ' obj.sortby]);
            end
        end
        function blurb(obj, leadingspaces)
            if ~exist('leadingspaces','var')
                leadingspaces=0;
            end
            if numel(obj)>1
                fprintf('multiple views  size:%s\n',mat2str(size(obj)));
                for i=1:numel(obj)
                    blurb(obj(i),leadingspaces+20);
                end
                return
            end
            s=repmat(' ',1,leadingspaces);
            % one line summary
            fprintf('%s ZmapCatalogView "%s" -> %s [%s]',s, obj.Name, char(obj.source), obj.mycat.Name);
            
            % DISP display the ranges used to view a catalog. The actual catalog dates do not need to match
            
            fprintf(' {%d/%d events}',obj.Count,ZmapGlobal.Data.(obj.source).Count);
            if ~isempty(obj.polymask)
                fprintf('(POLY)');
            end
            if ~isempty(obj.sortby)
                fprintf('(SORT:%s)',obj.sortby);
            end
            fprintf('\n');
        end
        
        function tf = isempty(obj)
            tf=obj.Count==0;
        end
        
        function obj=PolygonApply(obj,polygon)
            %ApplyPolygon applies a polygon mask to the catalog, further filtering results
            % events must be within polygon AND meet the range criteria
            % assumes polygon is either [lat,lon;...;latN,lonN] or struct with fields
            % 'Latitude' and 'Longitude'
            %
            %in_or_out is one of 'inside', 'outside'
            nargoutchk(1,1) % to avoid confusion, don't let this NOT be assigned
            if isempty(polygon)
                return
            end
            disp('Applying shape to catalog')
            if exist('polygon','var')
                if isnumeric(polygon)
                    obj.polygon.Latitude=polygon(:,2);
                    obj.polygon.Longitude=polygon(:,1);
                elseif isa(polygon,'ShapeGeneral')
                    oln=polygon.Outline;
                    obj.polygon.Latitude=oln(:,2);
                    obj.polygon.Longitude=oln(:,1);
                else
                    error('unanticipated polygon input')
                end
            end
            if isempty(obj.polygon.Latitude) || all(isnan(obj.polygon.Latitude))
                obj=obj.PolygonRemove();
                return
            end
            obj.polymask = polygon_filter(obj.polygon.Longitude, obj.polygon.Latitude,...
                obj.mycat.Longitude, obj.mycat.Latitude, 'inside');
            %refreshdata;
        end
        
        function obj=PolygonRemove(obj)
            nargoutchk(1,1) % to avoid confusion, don't let this NOT be assigned
            if ~isempty(obj.polymask) ||...
                    ~isempty(obj.polygon.Latitude) ||...
                    ~isempty(obj.polygon.Longitude)
                obj.polymask=[];
                obj.polygon.Latitude=[];
                obj.polygon.Longitude=[];
                %refreshdata;
            end
        end
        
        function obj=PolygonInvert(obj)
            nargoutchk(1,1) % to avoid confusion, don't let this NOT be assigned
            obj.polymask=~obj.polymask;
        end
        
        function trace(obj)
            % trace shows this and all Catalogs / Views from which this is descended
            disp(obj)
            disp(['- - - - from:' char(obj.source)]);
            disp('v v v v');
            try
                disp(trace(obj.mycat));
            catch
                disp(obj.mycat);
            end
        end
        
    end
end