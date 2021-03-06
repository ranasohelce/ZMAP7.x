% This plot a DEM map plus eq on top...
import zmaptopo.TopoToFlag

report_this_filefun(mfilename('fullpath'));

switch(plt)


    case 'lo30'

        l  = get(h1,'XLim');
        s1_east = l(2); s2_west = l(1);
        l  = get(h1,'YLim');
        s3_north = l(2); s4_south = l(1);
        fac = 1;
        if abs(s4_south-s3_north) > 10 | abs(s1_east-s2_west) > 10 
            def = {'3'};
            ni2 = inputdlg('Decimation factor for DEM data?','Input',1,def);
            l = ni2{:};
            fac = str2double(l);
        end
        do = ['cd  ' hodi]; ; eval(do);
        do = ['cd dem/gtopo30']; eval(do);

        try
            [tmap, tmapleg] = gtopo30('test',fac,[s4_south s3_north],[ s2_west s1_east]);
        catch ME
            handle_error(ME,@do_nothing);
            plt = 'err2';
            pltopo
        end

        my = s4_south:1/tmapleg(1):s3_north+0.1;
        mx = s2_west:1/tmapleg(1):s1_east+0.1;
        [m,n] = size(tmap);
        toflag = TopoToFlag.five;
        plt = 'ploM'; pltopo;

    case 'lo5'

        l  = get(h1,'XLim');
        s1_east = l(2); s2_west = l(1);
        l  = get(h1,'YLim');
        s3_north = l(2); s4_south = l(1);
        fac = 1;
        if abs(s4_south-s3_north) > 10 | abs(s1_east-s2_west) > 10 
            def = {'3'};
            ni2 = inputdlg('Decimation factor for DEM data?','Input',1,def);
            l = ni2{:};
            fac = str2double(l);
        end

        if ~exist('tbase.bin', 'var');  plt = 'err';
            pltopo
        else

            try
                [tmap, tmapleg] = tbase(fac,[s4_south s3_north],[ s2_west s1_east]);
            catch ME
                handle_error(ME,@do_nothing);
                plt = 'err2';
                pltopo
            end
        end

        my = s4_south:1/tmapleg(1):s3_north+0.1;
        mx = s2_west:1/tmapleg(1):s1_east+0.1;
        [m,n] = size(tmap);
        toflag = TopoToFlag.five;
        plt = 'plo'; pltopo;


    case 'lo2'

        l  = get(h1,'XLim');
        s1_east = l(2); s2_west = l(1);
        l  = get(h1,'YLim');
        s3_north = l(2); s4_south = l(1);
        region = [s4_south s3_north s2_west s1_east];

        do = ['  [tmap,vlat,vlon] = mygrid_sand(region); '];
        toflag = TopoToFlag.two;
        err = [' plt = ''err2''; pltopo '];
        eval(do,err);

        size(vlat)
        plt = 'plo2'; pltopo;


    case 'yourdem'

        l  = get(h1,'XLim');
        s1_east = l(2); s2_west = l(1);
        l  = get(h1,'YLim');
        s3_north = l(2); s4_south = l(1);
        region = [s4_south s3_north s2_west s1_east];

        % is mydem defined?
        if ~exist('mydem','var');
            plt = 'loadmydem';
            pltopo;
        end
        % cut the data
        if exist('butt', 'var'); 
            if butt(1) == 'C' || butt(1) == 'H' ;
                return ;
            end
        end
        l2 = min(find(mx >= s2_west));
        l1 = max(find(mx <= s1_east));
        l3 = max(find(my <= s3_north));
        l4 = min(find(my >= s4_south));

        toflag = TopoToFlag.one;


        tmap = mydem(l4:l3,l2:l1);
        vlat = my(l4:l3);
        vlon = mx(l2:l1);

        [m,n] = size(tmap);
        emydem = 'y';
        plt = 'ploy'; pltopo;


    case 'plo'


        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.1,  0.10, 0.75, 0.8]);
        pcolor(mx(1:n),my(1:m),tmap); shading flat
        demcmap(tmap);
        hold on

        whitebg(gcf,[0 0 0]);

        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out')
        set(gcf,'Color','k','InvertHardcopy','off')

    case 'ploM'


        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end
        [lat,lon] = meshgrat(tmap,tmapleg);
        tmap = km2deg(tmap/1000);

        hold on; axis off
        axesm('MapProjection','eqaconic','MapParallels',[],...
            'MapLatLimit',[s4_south s3_north],'MapLonLimit',[s2_west s1_east])
        surflm(lat,lon,tmap); colormap(bone)
        %surfm(lat,lon,tmap,tmap); demcmap(tmap)
        set(gca,'DataAspectRatio',[1 1 .5])
        view(0,75)


        whitebg(gcf,[0 0 0]);

        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out')
        set(gcf,'Color','k','InvertHardcopy','off')



    case 'plo2'

        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.1,  0.10, 0.75, 0.8]);
        if max(vlon) > 180; vlon = vlon - 360; end

        [xx,yy]=meshgrid(vlon,vlat);
        pcolor(xx,yy,tmap),shading flat;
        demcmap(tmap, 256);hold on
        xlabel('longitude'),ylabel('latitude')

        whitebg(gcf,[0 0 0]);
        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out')
        set(gcf,'Color','k','InvertHardcopy','off')

    case 'ploy'
        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.1,  0.10, 0.75, 0.8]);
        pcolor(vlon,vlat,tmap); shading flat
        demcmap(tmap);
        hold on

        whitebg(gcf,[0 0 0]);

        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out','Color',[0 0 0.5])
        set(gcf,'Color','k','InvertHardcopy','off')
        axis([ s2_west s1_east s4_south s3_north])


    case 'err'  % Tbase data not found

        butt =    questdlg('Please define the path to your Terrain base 5 min DEM (tbase.bin) data', ...
            'DEM data not found!', ...
            'OK','Help','Cancel','Cancel');

        switch butt
            case 'OK'

                [file1,path1] = uigetfile([ '*.bin'],' Terrain base global 5 min grid path (tbase.bin)');

                if length(path1) < 2
                    zmap_message_center.clear_message();;done
                    return
                else
                    addpath([path1]);
                    plt = 'lo5'; pltopo;
                end
            case 'Help'
                do = [ 'web ' hodi '/help/plottopo.htm ;' ];
                err=['errordlg('' Error while opening, please open the browser first and try again or open the file ./help/topo.hmt manually'');'];
                eval(do,err)

            case 'Cancel'
                welcome; return

        end %swith butt

    case 'err2'  % Tbase data not found
        [file1,path1] = uigetfile([ '*.img'],' Please define the path to the file topo_8.2.img (2 min DEM)');

        if length(path1) < 2
            zmap_message_center.clear_message();;done
            return
        else
            addpath([path1]);
            plt = 'lo2'; pltopo;
        end

        %errordlg('Error loading data - sorry');


    case 'genhelp'  % Tbase data not found
        web(['file:' which('plottopo.htm')]);

    case 'loadmydem'  % load mydem

        butt =    questdlg('Please load a *.mat file containing the DEM data in 2D matrix mydem, and the lat/long vextors my and mx', ...
            'DEM data not found! Load mydem ', ...
            'OK','Help','Cancel','Cancel');

        switch butt
            case 'OK'
                [file1,path1] = uigetfile([ '*.mat'],'File containing  mydem, mx, my ');
                if length(path1) < 2
                    zmap_message_center.clear_message();;done
                    return
                else
                    lopa = [path1 file1];
                    do = ['load(lopa)']; eval(do);
                    plt = 'yourdem'; pltopo;
                end
            case 'Help'
                plt = 'genhelp'; pltopo; return; return;

            case 'Cancel'
                welcome; return; return; return

        end %swith butt

end  %



