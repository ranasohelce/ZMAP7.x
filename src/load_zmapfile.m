function [catalog, OK] = load_zmapfile(myfile)%
    % LOAD_ZMAPFILE import a zmap file from disk
    %
    % [catalog, OK] = LOAD_ZMAPFILE() loads interactively.
    %
    % ... = LOAD_ZMAPFILE(filename) attempts to load catalog from the file filename
    %
    % If the catalog couldn't be loaded, this function returns a blank catalog, and OK will be false.
    % 
    %
    % load_zmapfile file will ask you for an input file name. The data
    % format is at this point:
    %
    %  Columns 1 through 7
    %
    %    34.501      116.783       81         3         29       1.7      13
    %
    %    lat          lon        year       month      day       mag     depth
    %
    %  Columns 8 and 9
    %     10     51
    %    hour   min
    %
    %  [optional] Column 10 : second
    %
    % Any catalog is generally loaded once as an unformatted ascii file
    % and then saved as variable "primeCatalog" in  <name>_cata.mat .
    %
    %   Matlab scriptfile written by Stefan Wiemer
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    OK=false;
    catalog=ZmapCatalog();
    
    report_this_filefun();
    
    if ~exist('myfile','var') || isempty(myfile)
    % start program and load data:
    
    [file1,path1] = uigetfile('*.mat',' Earthquake Datafile');
    
    if length(path1) < 2 % cancelled
        return
    end
    
    myfile = fullfile(path1,file1);
    end
    if ~exist(myfile,'file')
        errordlg('File could not be found');
        return
    end
    
    % find and load the ZmapCatalog variable from the file
    S=whos('-file',myfile);
    S([S.bytes]==0) = [];
    ZCats=S(startsWith({S.class},'Zmap') & contains({S.class},'Catalog'));
    if ~isempty(ZCats) && numel(ZCats) == 1
        catalog=loadCatalog(path1, file1, ZCats);
        OK=~isempty(catalog);
        return
    end
    % there's only one variable, so try to load it
    if numel(S)==1
        catalog=loadCatalog(path1, file1, S);
        OK=~isempty(catalog);
        return
    end
    
    % maybe there is a table?
    szStr = string(cellfun(@(x)mat2str(x),{S.size},'UniformOutput',false));
    szStr=strrep(szStr,' ','x');
    popupString = '<html><strong>'+ string({S.name}) + '</strong> : ' + string({S.class}) + ' : '+ szStr;
    zdlg=ZmapDialog();
    zdlg.AddPopup('mycatvar','Variables in file: ',popupString,1,'',@(x)S(x.Value).name);
    [v,OK]=zdlg.Create('Name','Choose your CATALOG');
    if ~OK
        return
    end
    % ZmapCatalog didn't exist in the file. Perhaps it is an old version?
    % If so, then catalog would have been saved in "a" as a matrix
    catalog=loadCatalog(path1,file1,v.mycatvar);
    %{
    S=whos('-file',myfile,'a');
    if ~isempty(S)
        catalog=loadCatalog(path1, file1, S);
        OK=~isempty(catalog);
    else
        errordlg('File did not contain a catalog variable - Nothing was loaded');
    end
    %}
    OK=~isempty(catalog);
    
end

function   A=loadCatalog(path, file, S)
    % loadCatalog retrieves a ZmapCatalog from a .mat file, sorted by Date
    % if file contains
    % by the time this is called, it should be already known that 'a' exists
    %
    lopa = fullfile(path, file);
    A=ZmapCatalog();
    if ischar(S) || (isstring(S) && isscalar(S))
        varName = S;
    else
        varName=ensureSingleVariable(S);
    end
    
    try
        tmp=load(lopa,varName);
        A=tmp.(varName);
    catch ME
        
        error_handler(ME, 'Error loading data! Are they in the right *.mat format?');
    end
    

    clear tmp
    A = ZmapCatalog.from(A);
    
    if isempty(A.Name)
        A.Name = file;
    end
    if isempty(A.MagnitudeType)
        A.MagnitudeType=repmat(categorical({''}),size(A.Longitude));
    end
    if isempty(A.EventID)
        A.EventID = A.generate_event_ids(A.Date, ['unk:' file]);
    end
    A.sort('Date')
end

function varName = ensureSingleVariable(S)
    % chooseFromMultipleVariables user interactive determinination of which to
    % input "S" is the struct returned from whos()
    % returns '' if aborted.
    varName='';
    if numel(S)>1
        str={S.name};
        [s,v]=listdlg('PromptString','Select Variable to load:',...
            'SelectionMode','single',...
            'ListString',str);
        if ~v
            warndlg(' Error - No catalog data loaded !');
            return
        end
    elseif numel(S)==0
        warndlg(' Error - No catalog data found in file!');
        return
    else
        s=1;
    end
    varName = S(s).name;
end
