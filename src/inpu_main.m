%  This scriptfile ask for several input parameters that can be setup
%  at the beginning of each session. The default values are the
%  extrema in the catalog
%
%a = org;        % resets the main catalogue "a" to initial state
%
%TODO create simple window to choose one earthquake as mainshock, using
% maepi earthquake as default.

error('this function is quite outdated.'); %
ZG=ZmapGlobal.Data;
report_this_filefun(mfilename('fullpath'));

%  default values
t0b = min(ZG.a.Date);
teb = max(ZG.a.Date);
tdiff = (teb - t0b)*365;

% if two mainshocks arte define, use one only ..
if ZG.maepi.Count > 1
    ZG.maepi = ZG.maepi.subset(1) ;
end
% define ZG.maepi if not exist
l = find(ZG.newt2.Magnitude == max(ZG.newt2.Magnitude));
if ~exist('ZG.maepi')
    ZG.maepi = ZG.newt2.subset(l);
end
if isempty('ZG.maepi')
    ZG.maepi = ZG.newt2.subset(l);
end


%
% make the interface
%
figure_w_normalized_uicontrolunits(...
    'Units','pixel','pos',[300 100 300 400 ],...
    'Name','Define Mainshock Parameters!',...
    'visible','off',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'NextPlot','new');
axis off

inp1B=uicontrol('Style','edit','Position',[.70 .90 .22 .05],...
    'Units','normalized','String',num2str(dateshift(ZG.maepi.Date(1),'start','day')),...
    'Callback','ZG.maepi.Date(1)=str2double(inp1B.String); inp1B.String=num2str(floor(ZG.maepi.Date(1)));');

inp1=uicontrol('Style','edit','Position',[.70 .80 .22 .05],...
    'Units','normalized','String',num2str(ZG.maepi(1,4)),...
    'Callback','ZG.maepi(1,4))=str2double(inp1.String); inp1.String=num2str(ZG.maepi(1,4)))');

inp2=uicontrol('Style','edit','Position',[.70 .70 .22 .05],...
    'Units','normalized','String',num2str(ZG.maepi(1,5)),...
    'Callback','ZG.maepi(1,5)=str2double(inp2.String); inp2.String=num2str(ZG.maepi(1,5));');

inp3=uicontrol('Style','edit','Position',[.70 .60 .22 .05],...
    'Units','normalized','String',num2str(ZG.maepi(1,8)),...
    'Callback','ZG.maepi(1,8)=str2double(inp3.String); inp3.String=num2str(ZG.maepi(1,8));');


inp4=uicontrol('Style','edit','Position',[.70 .50 .22 .05],...
    'Units','normalized','String',num2str(ZG.maepi(1,9)),...
    'Callback','ZG.maepi(1,9)=str2double(inp4.String); inp4.String=num2str(ZG.maepi(1,9));');

inp5=uicontrol('Style','edit','Position',[.70 .40 .22 .05],...
    'Units','normalized','String',num2str(ZG.maepi.Magnitude),...
    'Callback','ZG.maepi.Magnitude=str2double(inp5.String); inp5.String=num2str(ZG.maepi.Magnitude);');



close_button=uicontrol('Style','Pushbutton',...
    'Position',[.65 .02 .20 .10 ],...
    'Units','normalized','Callback','close;zmap_message_center.set_info('' '','' '');done','String','cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.35 .02 .20 .10 ],...
    'Units','normalized',...
    'Callback','close,think, pvalcat',...
    'String','Go');

info_button=uicontrol('Style','Pushbutton',...
    'Position',[.05 .02 .20 .10 ],...
    'Units','normalized',...
    'Callback','zmaphelp(titstr,hlpStr)',...
    'String','Info');
titstr = 'General Parameters';
hlpStr = ...
    ['This window allows you to enter the         '
    'mainshock magnitude and time etc.            '
    'time, magnitude and depth.                   '
    '                                             '];




txt3 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 1.00 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Year');


txt1 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.75 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Day');

txt2 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.87 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Month');

txt4 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.63 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Hour');

txt5 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.51 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Minute');

txt6 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.38 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Magnitude ');


%clear txt1 txt2 txt3 txt4 txt5 txt6 txt7 inp1 inp1B inp3 inp3 inp4 inp5 inp6 inp7
set(gcf,'visible','on')
watchoff
str = [ 'Please Select a subset of earthquakes'
    ' and press Go                        '];
zmap_message_center.set_message('Message',str);


