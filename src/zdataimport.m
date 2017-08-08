% this is zdataimport

ver = version;
ver = str2double(ver(1));

% check if Matlab 6+
if ver < 6
    helpdlg('Sorry - these import filters only work for Matlab version 6.0 and higher','Sorry');
    return
end

% start filters

[a] = import_start(fullfile(ZmapGlobal.Data.hodi, 'importfilters'));
if isnan(a)
    % import cancelled / failed
    return
end
if isnumeric(a)
    replaceMainCatalog(ZmapCatalog(a));
    ZG.a.sort('Date');
end
disp(['Catalog loaded with ' num2str(ZG.a.Count) ' events ']);
ZG.big_eq_minmag = max(ZG.a.Magnitude)-0.2;       %  as a default

% call the setup
ZG.a=catalog_overview(ZG.a);
