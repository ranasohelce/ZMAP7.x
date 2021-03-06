function clkeysel() 
% provides a interface for some selection options by a polygon
% works on the equivalent events for a cluster catalog(complete,swarms,etc)
% selects clusters which equivalent events are inside selection area
%
%A.Allmann
 % turned into function by Celso G Reyes 2017
 
ZG=ZmapGlobal.Data; % used by get_zmap_globals
global x y clu mess plot1_h plot2_h clust file1
global  h5 xcordinate ycordinate newclcat clsel
global equi_button backbgevent original backcat backequi
global decc


xcordinate=0;
ycordinate=0;
axes(h5)
x = [];
y = [];

%n = 0;


figure(mess);
set(gcf,'visible','off')
clf;
cla;
set(gca,'visible','off');
set(gcf, 'Name','Polygon Input Parameters');

%creates dialog box to input some parameters
%

inp1_field=uicontrol('Style','edit',...
    'Position',[.70 .60 .17 .10],...
    'Units','normalized','String',num2str(xcordinate),...
    'callback',@callbackfun_001);

inp2_field=uicontrol('Style','edit',...
    'Position',[.70 .40 .17 .10],...
    'Units','normalized','String',num2str(ycordinate),...
    'callback',@callbackfun_002);

more_button=uicontrol('Style','Pushbutton',...
    'Position', [.60 .05 .15 .15],...
    'Units','normalized',...
    'callback',@callbackfun_003,...
    'String','More');
last_button=uicontrol('Style','Pushbutton',...
    'Position',[.40 .05 .15 .15],...
    'Units','normalized',...
    'Callback',@(~,~) clpickp('LAST'),...
    'String','Last');

mouse_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .05 .15 .15],...
    'Units','normalized',...
    'Callback',@(~,~)clpickp('MOUSE'),...
    'String','Mouse');

load_button=uicontrol('Style','Pushbutton',...
    'Position',[.80 .05 .15 .15],...
    'Units','normalized',...
    'Callback',@(~,~)clpickp('LOAD'),...
    'String','load');
cancel_button=uicontrol('Style','Pushbutton',...
    'Position',[.05 .80 .15 .15],...
    'Units','normalized',...
    'callback',@callbackfun_004,...
    'String','Cancel');
txt1 = text(...
    'Position',[0. 0.65 0 ],...
    'FontSize',12,...
    'String','Longitude:');
txt2 = text(...
    'Position',[0. 0.45 0 ],...
    'FontSize',12,...
    'String','Latitude:');


set(mess,'visible','on')

function callbackfun_001(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  xcordinate=str2double(inp1_field.String);
  inp1_field.String=num2str(xcordinate);
end
 
function callbackfun_002(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  ycordinate=str2double(inp2_field.String);
  inp2_field.String=num2str(ycordinate);
end
 
function callbackfun_003(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  set(mouse_button,'visible','off');
  set(load_button,'visible','off');
  clpickp('MORE');
end
 
function callbackfun_004(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  close
end
 
end
