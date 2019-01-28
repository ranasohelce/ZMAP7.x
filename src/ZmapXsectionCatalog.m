classdef ZmapXsectionCatalog < dynamicprops
    % ZMAPXSECTIONCATALOG a catalog specifically along a cross section
    % meaning, all events are on a great-circle line
    %
    
    properties
        Curve              = [nan,nan] % points along the curve [y,x]
        DistAlongStrike    double  % distance for each event from startPoint in units
        Displacement       double  % perpendicular distance of each event from the line in units
        CurveLength        = 0; % length of this cross-section
        ProjectedPoints    double = []
        Name
        Width               double
    end
    
    properties(SetAccess = immutable)
        Catalog     {mustBeZmapCatalog} = ZmapCatalog % points to an underlying zmap catalog
    end
    
    properties(Dependent)
        startPoint % as y,x
        endPoint   % as y,x
        ProjectedX
        ProjectedY
        ProjectedZ
    end
    
    
    methods
        function obj = ZmapXsectionCatalog(catalog, p1yx, p2yx, width)
            %ZMAPXSECTIONCATALOG
            % obj = ZMAPXSECTIONCATALOG(catalog, endpoint1, endpoint2, swath_width)
            % endpoint1 and endpoint2 are each (lat, lon)
            %
            % see also project_on_gcpath
            class(catalog)
            if isa(catalog,'ZmapXsectionCatalog')
                obj.Catalog = catalog.Catalog;
            else
                obj.Catalog = catalog;
            end
            obj.Name = catalog.Name;
            obj.Width = width;
            
            % add catalog properties as though they were our own
            % this makes this class queryable and settable as though it were the catalog it is using
            % note, this is for properties, not methods!
            obj.attach_catalog_properties()
            
            
            if iscartesian(catalog.RefEllipsoid)
                % deal with cartesian coordinates
                obj.Curve = [p1yx; p2yx];
                obj.CurveLength = sqrt(sum((p1yx-p2yx).^2));
                p1 = [p1yx(2), p1yx(1)]; % flip from lat-lon to x-y
                p2 = [p2yx(2), p2yx(1)]; % flip from lat-lon to x-y
                [obj.ProjectedPoints, ...
                    obj.DistAlongStrike, ...
                    obj.Displacement] = projection(p1, p2, catalog.XYZ(:,[1,2]) );
                obj.ProjectedPoints(:,3) = catalog.Z;
                mask = obj.DistAlongStrike>=0 & obj.DistAlongStrike<obj.CurveLength &...
                    obj.Displacement<=obj.Width;
                obj.Catalog = obj.Catalog.subset(mask);
                
            else
                
                % deal with geodetic coordinates
                CurveLength = distance(p1yx,p2yx,catalog.RefEllipsoid);
                nlegs    = ceil(CurveLength / width) .*2;
                [curvelats,curvelons] = gcwaypts(p1yx(1), p1yx(2), p2yx(1), p2yx(2), nlegs);
                curveInKm = CurveLength.*unitsratio('kilometer',catalog.RefEllipsoid.LengthUnit);
                scale = min(.1, curveInKm / 10000); %usded to determine how path is sampled
                [mindist,mask,gcDist] = project_on_gcpath(p1yx,p2yx, catalog, width/2, scale);
                obj.Catalog = obj.Catalog.subset(mask); % necessary, otherwise this turns into a ZmapCatalog
                obj.Curve = [curvelats, curvelons];
                obj.DistAlongStrike = gcDist;
                obj.Displacement    = mindist;
                obj.CurveLength     = CurveLength;
            end
            
            
            function [newQuake, DistAlongPlane, perp_dist]=projection(startPt, endPt, quake)
                V1 = endPt - startPt; % vector to project upon
                V2 = quake - startPt; % vector to project
                dfun=@(vec1, vec2)sqrt(sum((vec1-vec2).^2,2)); %nx2 vectors
                AngleToPlane   = angle(V1(:,1) + 1i*(V1(:,2)));
                AngleToQuake = angle(V2(:,1) + 1i*(V2(:,2)));
                orientedAngle = wrapToPi(AngleToQuake - AngleToPlane);
                DistAlongPlane = cos(orientedAngle) .* dfun(V2,[0,0]);
                NewOffset =  [cos(AngleToPlane),sin(AngleToPlane)] .* DistAlongPlane;
                newQuake = NewOffset + startPt;
                perp_dist = sqrt(sum((quake-newQuake).^2,2));
            end


        end
        
        function setCatalogProperty(obj,name,val)
            obj.Catalog.(name) = val;
        end
        
        function val = getCatalogProperty(obj,name)
            val = obj.Catalog.(name);
        end
        
        function p=get.startPoint(obj)
            p=obj.Curve(1,:);
        end
        function p=get.endPoint(obj)
            p=obj.Curve(end,:);
        end
        
        function me = copyFrom(me, other)
            C = metaclass(other);
            P = [C.Properties{:}];
            P([P.Dependent])=[];
            for k = 1:length(P)
                try
                    me.(P(k).Name) = other.(P(k).Name);
                catch ME
                    if ME.identifier~="MATLAB:class:SetProhibited"
                        rethrow(ME)
                    end
                end
            end
        end     
            
        
        function disp(obj)
            fprintf('cross-section catalog with %d events\n',obj.Count);
            sp=obj.startPoint; ep=obj.endPoint;
            fprintf('From (%g,%g) to (%g,%g) [%g km]\n',...
                sp(1),sp(2), ep(1),ep(2), obj.CurveLength);
        end
        
        function s=summary(obj,varargin)
            s=obj.Catalog.summary(varargin{:});
        end

        function s=info(obj)
            s=sprintf('cross-section catalog with %d events\n',obj.Count);
            sp=obj.startPoint; ep=obj.endPoint;
            s=[s,sprintf('From (%g,%g) to (%g,%g) [%g km]\n',...
                sp(1),sp(2), ep(1),ep(2), obj.CurveLength)];
        end
        
        function obj = subset(existobj, range)
            obj = ZmapXsectionCatalog(existobj.Catalog.subset(range),existobj.startPoint, existobj.endPoint, existobj.Width);
            %{
            obj.Catalog = existobj.Catalog.subset(range);
            
            obj.DistAlongStrike = existobj.DistAlongStrike(range);
            obj.Displacement = existobj.Displacement(range);
            obj.CurveLength=existobj.CurveLength;
            obj.Curve = existobj.Curve;
            %}
        end
        
        function obj = cat(objA, ObjB)
            % cannot currently concatinate two of these
            unimplemented_error()
        end
        
    end
    
    methods(Access=private)
        function attach_catalog_properties(obj)
            pr = properties(obj.Catalog);
            
            for idx = 1:numel(pr)
                if isprop(obj,pr{idx})
                    continue
                end
                p=obj.addprop(pr{idx});
                p.SetMethod=@(val) obj.setCatalogProperty(pr{idx},val);
                p.GetMethod=@(val) obj.getCatalogProperty(pr{idx});
            end
        end
    end
    
    methods(Static)
        function [lon, lat,h] = create_endpoints(ax,C)
            % create_endpoints returns lat, lon where each is [start,end] along with handle used to pick endpoints
            
            disp('click on start and end points for cross section');
            
            % pick first point
            [lon, lat] = ginput(1);
            set(gca,'NextPlot','add');
            h=scatter(ax,lon,lat,'Marker','x','LineWidth',2,'MarkerSize',5,'Color',C);
            
            % pick second point
            [lon(2), lat(2)] = ginput(1);
            h.XData=lon;
            h.YData=lat;
        end
    end
end
