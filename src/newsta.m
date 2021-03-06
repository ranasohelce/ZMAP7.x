function newsta(sta, catalog)
    %  A as(t) value is calculated for a given cumulative number curve and displayed in the plot.
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    if ~ismember(sta,{'rub','ast','bet','lta'})
        warning('unknown option : %s',sta);
        return
    end
    assert(~isempty(catalog))
    % start and end time
    NuBins=[]; NuRep=[];% declare for functions that share this variable
    
    report_this_filefun();
    %b = ZG.newcat;
    
    %select big evenets
    l = catalog.Magnitude > ZG.CatalogOpts.BigEvents.MinMag;
    big = catalog.subset(l);
    
    [ZG.compare_window_dur, ZG.bin_dur] = choose_parameters(ZG.compare_window_dur, ZG.bin_dur); % window length, bin length
    
    
    [t0b, teb] = bounds(catalog.Date) ;
    tdiff = round((teb - t0b)/ZG.bin_dur); % in days/ZG.bin_dur
    
    % for hist, xt & 2nd parameter were centers.  for histcounts, it is edges.
    [cumu, xt] = histcounts(catalog.Date, t0b: ZG.bin_dur :teb);
    xt = xt + (xt(2)-xt(1))/2; 
    xt(end)=[]; % convert from edges to centers!
    cumu2=cumsum(cumu);
    
    
    %  winlen_days is the cutoff at the beginning and end of the analyses to avoid spikes at the end
    % winlen_days = 10;
    
    
    % calculate mean and z value
    
    ncu = length(xt);
    as = nan(1,ncu);
    
    winlen_days = floor(ZG.compare_window_dur / ZG.bin_dur);
    probabilityButtonCallback=[];
    
    
    switch sta
        case 'rub'
            as = rubfun(winlen_days, tdiff, cumu, length(xt));
            titletext=['Rubberband Function; wl = ', char(ZG.compare_window_dur)];
            
        case 'ast'
            as = asfun(winlen_days, tdiff, cumu, length(xt));
            titletext=['AS(t) Function; wl = ', char(ZG.compare_window_dur)];
            
        case 'lta'
            as = ltafun(winlen_days, cumu, length(xt));
            titletext=['LTA(t) Function; wl = ', char(ZG.compare_window_dur)];
            probabilityButtonCallback=@(~,~)translating(catalog, as,'z'); % was newcat
            
        case 'bet'
            as=betfun(winlen_days, cumu, catalog, length(xt));% was newcat
            titletext=['LTA(t) Function; \beta-values; wl = ', char(ZG.compare_window_dur)];
            probabilityButtonCallback=@(~,~)translating(catalog, as,'beta'); % was newcat
    end
    
    %  Plot the as(t)
    cumfig=findobj('Type','Figure','-and','Name','Cumulative Number Statistic');
    
    % Set up the Cumulative Number window
    if isempty(cumfig)
        cumfig=figure('Name','Cumulative Number Statistic');  %TODO this case wasn't handled. created a simple figure
    else
        figure(cumfig);
    end
    delete(findobj(cumfig,'Type','axes'));
    delete(findobj(cumfig,'Tag','zmaxtext')); 
   delete(findobj(cumfig,'Tag','cumulativeplot'));
    %clf
    set(gca,'NextPlot','add')
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,...
        'LineWidth',1.5,...
        'Box','on')
    
    % orient tall
    set(gcf,'PaperPosition',[2 1 5.5 7.5])
    rect = [0.2,  0.15, 0.65, 0.75];
    ax = axes('position',rect)
    % [pyy,ax1,ax2] = plotyy(xt,cumu2,xt,as);
    yyaxis left
    ax1 = plot(xt,cumu2,'LineWidth',2.0,'Color','b', 'tag', 'cumulativeplot');
    ylabel('Cumulative Number','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.m)

    yyaxis right
    ax2 = plot(xt,as,'LineWidth',1.0,'Color','r', 'tag', 'valueplot');
    ylabel('valueplot','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.m)
    xlabel(ax, 'Time in years ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.m)
    
    xlim(ax,[T0b, teb]);
    ylim([min(as)-2  max(as)+5])
    set(ax, 'XTicklabel',[],'TickDir','out')
    
    
    %{
    %  DISABLED  the underlying function is in shambles....
    if ~isempty(probabilityButtonCallback)
        uicontrol('Style','Pushbutton','Units','normal',...
            'Position',[.35 .0 .3 .05],'String','Translate into probabilities',...
            'callback',probabilityButtonCallback);
    end
    %}
  
    
    title(titletext,'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m,'Color','k');
    
    idx = find(as == max(as),1);
    
    tet1 =sprintf('Zmax: %3.1f at %s ',max(as),char(xt(idx),'uuuu-MM-dd HH:mm:ss'));
    
    vx = xlim;
    vy = ylim;
    xlim([vx(1), dateshift(teb,'end','Year') ]);
    ylim([vy(1),  vy(2)+0.05*vy(2)]);
    te2 = text(vx(1)+0.5, vy(2)*0.9,tet1,'Tag','zmaxtext');
    set(te2,'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','normal')
    
    grid
    set(gca,'Color',ZG.color_bg)
    
    set(gca,'NextPlot','add');
    
    
    % plot big events on curve
    %
    if ~isempty(big)
        l = catalog.Magnitude > ZG.CatalogOpts.BigEvents.MinMag;
        f = find( l  == 1);
        bigplo = plot(big.Date,f,'hm');
        set(bigplo,'LineWidth',1.0,'MarkerSize',10,...
            'MarkerFaceColor','y','MarkerEdgeColor','k')
        stri4 = [];
        for j = 1 : big.Count
            s = sprintf('  M=%3.1f',big.Magnitude(j));
            stri4 = [stri4 ; s];
        end
    end
    
    
    % repeat button
    
    uicontrol('Units','normal',...
        'Position',[.25 .0 .08 .05],'String','New',...
        'callback',@callbackfun_003)
    
    strib = [ZG.newcat.Name];
    
    set(cumfig,'Visible','on');
    figure(cumfig);
    watchoff
    watchoff(cumfig)
    
    
    xl = get(pyy(2),'XLim');
    set(pyy(1),'XLim',xl);
    
    
    %%
    
    function [win_dur, bin_dur] = choose_parameters(win_dur, bin_dur) % window length, bin length
        def = {num2str(years(win_dur)), num2str(days(bin_dur))};
        tit ='beta computation input parameters';
        prompt={ 'Compare window length (years)',...
            'bin length (days)'};
        ni2 = inputdlg(prompt,tit,1,def);
        
        win_dur = years(str2double(ni2{1}));
        bin_dur = days(str2double(ni2{2}));
    end
    
    function rubvals = rubfun(winlen_days, tdiff, cumu, xtLen)
        % guts of rubberband
        rubvals = nan(1,xtLen);
        for i = winlen_days:1:xtLen-winlen_days  % ...:...:tdiff-winlen_days
            mean1 = mean(cumu(1:i));
            mean2 = mean(cumu(i+1:i+winlen_days));
            var1 = cov(cumu(1:i));
            var2 = cov(cumu(i+1:i+winlen_days));
            rubvals(i) = (mean1 - mean2)/(sqrt(var1/i+var2/winlen_days));
        end
    end
    
    function asvals = asfun(winlen_days, tdiff, cumu, xtLen)
        % guts of as(t)
        asvals = nan(1,xtLen);
        for i = floor(winlen_days):floor(tdiff-winlen_days)
            mean1 = mean(cumu(1:i));
            mean2 = mean(cumu(i+1:xtLen));
            var1 = cov(cumu(1:i));
            var2 = cov(cumu(i+1:xtLen));
            asvals(i) = (mean1 - mean2)/(sqrt(var1/i+var2/(tdiff-i)));
        end
    end
    
    function ltavals = ltafun(winlen_days, cumu, xtLen)
        % guts of lta
        ltavals = nan(1,xtLen);
        for i = 1:length(cumu)-winlen_days
            cu = [cumu(1:i-1) cumu(i+winlen_days+1:xtLen)];
            mean1 = mean(cu);
            mean2 = mean(cumu(i:i+winlen_days));
            var1 = cov(cu);
            var2 = cov(cumu(i:i+winlen_days));
            ltavals(i) = (mean1 - mean2)/(sqrt(var1/(xtLen-winlen_days)+var2/winlen_days));
        end
    end
    
    function betavals = betfun(winlen_days, cumu, catalog, nBins)
        % guts of beta
        betavals = nan(1, nBins);
        tStart = min(catalog.Date);
        nEvents = catalog.Count;
        tEnd = max(catalog.Date);
        
        if (ZG.compare_window_dur >= tEnd-tStart) || (ZG.compare_window_dur <= days(0))
            errordlg('winlen_days is either too long or too short.');
            return;
        end
        
        normalizedInterval=winlen_days/nBins;
        STDTheor=sqrt(normalizedInterval*nEvents*(1-normalizedInterval));
        
        for i = 1:length(cumu)-winlen_days
            realInterval=sum(cumu(i:i+(winlen_days-1)));
            betavals(i) = (realInterval-(nEvents*normalizedInterval))/STDTheor;
        end
    end
    
    
    %% callback functions
    function callbackfun_003(mysrc,myevt)
        
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        newsta(sta,catalog); % cannot e put directly into uicontrol's callback because 'sta' would be unchanging
    end
  
    
    % the translating function originally ProbValuesZ and ProbValuesBeta, but they were never used.
    % TODO (probably) remove translating and sim_2prob or (less likely) figure out what they were supposed to do and make them do it.
    
    function probValues=translating(catalog, values, value2trans) 
        % translating
        % turned into function by Celso G Reyes 2017
        
        ZG=ZmapGlobal.Data; % used by get_zmap_globals
        
        report_this_filefun();
        
        % call
        ButtonName = questdlg('Translate which data into probabilities?', ...
            'Reference Data', ...
            'uniform rate', 'real data', 'uniform rate');
        switch ButtonName
            case 'uniform rate'
                way='unif';
            case 'real data'
                way='real';
            otherwise
                return
        end % switch
        
        % call
        helpdlg(['The translation is  by randomly calculating beta values for a given setup.',...
            'The more often the process is repeated, the more reliable the results get, but the ',...
            'longer the simulation lasts.'],'About translation');
        myans=inputdlg('Number of repetitions: ( > 20 )', 'Translation',1,{num2str(1000)});
        if isempty(myans)
            return
        end
        NuRep=str2double(myans{1});
        
        BinLength=1/length(xt); %FIXME where does xt come from/go
        NuBins=length(xt);
        
        % produce Big catalog
        if way=='unif'
            BigCatalog=sort(rand(100000,1));
        else % if way=='real'
            whichs=ceil(catalog.Count*rand(100000,1)); % numbers in whichs from 1 to length(catalog)
            BigCatalog(100000,1)=0;
            for i=1:100000
                BigCatalog(i,1)=catalog.Date(whichs(i));    % ith element of BigCatalog is random out of catalog
            end
            BigCatalog=sort(BigCatalog);
            BigCatalog=(BigCatalog-min(BigCatalog))/(max(BigCatalog)-min(BigCatalog));
        end
        
        % call
        isFitted=sim_2prob(value2trans,BigCatalog,values); % moved into this file from outside
        
        %{ 
        %% this part is never used elsewhere in the program. Maybe function taken over by isFitted
        switch value2trans
            case 'zval'
                
                probValues=nan(1,length(values));
                for i=1:length(values)
                    probValues(1,i)=normcdf(values(1,i), isFitted(2,1), isFitted(2,2));
                end
                disp(probValues)
            case 'beta'
                probValues=nan(1,length(values));
                for i=1:length(values)
                    probValues(1,i)=normcdf(values(1,i), isFitted(1,1), isFitted(1,2));
                end
                disp(probValues)
            otherwise
                error('unknown value to translate')
        end
        %}
    end
    
    % isFitted() is only used by translating(), which isn't being used.
    
    function isFitted=sim_2prob(value2trans, BigCatalog,BetaValues) 
        % needed variables
        % BigCatalog        big catalog from which to take the eqs randomly, produced by translating
        %                   consists of 100000 eqs
        % sampSize          number of earthquakes in a bin, i.e. sample size (was ni)
        % NuBins            number of bins
        % BinLength         1/length(xt), length of shortest possible interval
        % winlen_days               length of interval in times shortest
        % NuRep             number of repetitions
       
        
        report_this_filefun();
        
        
        delta=winlen_days/NuBins;
        
        for nto=1:NuRep
            disp(nto);
            
            which=ceil(100000*(rand(sampSize)));
            for i=1:sampSize
                rancata(i)=BigCatalog(which(i));
            end
            clear i which;
            rancata=ceil(rancata*NuBins);
            
            for i=1:NuBins
                l=sum(rancata==i); 
                Bins(i,1)=sum(l); clear l;
            end
            clear rancata i;
            
            FirstBin=ceil(rand(1)*(NuBins-winlen_days+1));
            
            
            zin=Bins(FirstBin:FirstBin+winlen_days-1); 
            zout=[Bins(1:FirstBin-1,1); Bins(FirstBin+winlen_days:NuBins,1)];
            ToBeFitted(nto,1)=nto;
            % calculating beta
            ToBeFitted(nto,2)=(sum(zin)-sampSize*delta)/(sqrt(sampSize*delta*(1-delta)));
            % calculating z
            ToBeFitted(nto,3)=(mean(zout)-mean(zin))/(sqrt(var(zin)/sum(zin)+var(zout)/sum(zout)));
            clear Bins FirstBin zin zout;
        end
        
        [meanval, std] =normfit(ToBeFitted(:,2)); 
        isFitted(1,1)=meanval; 
        isFitted(1,2)=std;
        [meanval, std] =normfit(ToBeFitted(:,3)); 
        isFitted(2,1)=meanval; 
        isFitted(2,2)=std;
        clear meanval std;
        clear ToBeFitted;
        
        switch value2trans
            case 'beta'
                Pbeta = normcdf(BetaValues,isFitted(1,1),isFitted(1,2));
                Pbeta(Pbeta == 0) = nan;
            case 'z'
                Pbeta = normcdf(BetaValues,isFitted(2,1),isFitted(2,2));
                Pbeta(Pbeta == 0) = nan;
        end
        
        % plot the results
        figure
        pq = -log10(1-Pbeta); l = isinf(pq);pq(l) = 18 ;
        pl1 = plot(xt,pq,'color',[0.0 0.5 0.9]);
        set(gca,'NextPlot','add')
        pq(pq < 1.3) = nan;
        pl3 = plot(xt,pq,'b','Linewidth',2);
        
        pq = -log10(Pbeta);
        pq(isinf(pq)) = 18 ;
        pl2 = plot(xt,pq,'color',[0.8 0.6 0.8]);
        pq(pq < 1.3) = nan;
        pl4 = plot(xt,pq,'r','Linewidth',2);
        
        maxd = [get(pl1,'YData') get(pl2,'YData') ]; 
        maxd(isinf(maxd)) = []; 
        maxd = max(maxd);
        if maxd < 5 ; maxd = 5; end
        if isnan(maxd) == 1 ; maxd = 10; end
        
        legend([pl3 pl4],'Rate increases','Rate decreases');
        set(gca,'Ylim',[0 maxd+1])
        set(gca,'YTick',[1.3 2 3 4 5])
        set(gca,'YTickLabel',[ '    5%' ; '    1%' ;  '  0.1%' ;  ' 0.01%' ; '0.001%'])
        set(gca,'TickDir','out','Ticklength',[0.02 0.02],'pos',[0.2 0.2 0.7 0.7]);
        xlabel('Time [years]')
        ylabel('Significance level');
        set(gcf,'color','w')
        grid
        
        uicontrol('Units','normal',...
            'Position',[.8 .0 .1 .05],'String','Explain ... ',...
            'callback',@(~,~)showweb('explproba'));
        
    end
    
end