function animatorb(action) % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    animator(action, @slicemap);
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    
    global ps1 % first point (one end of transit)
    global ps2 % second point (other end of transit)
    global plin % both points, in 2x2 array
    global pli % plot of line between the two points
    
    switch(action)
        case 'start'
            msgbox('Please select the starting point of the x-section with a left mouseclick, then drag the mouse to terminal location and release the button','Info')
            % was animatorz, animatorb, but that seems incorrect.
            [ps1, ps2, plin, pli] = animator_start(@animatorb); % ButtonMotion, ButtonUp
            
        case 'move'
            animator_move(ps2, pli, plin)
            
        case 'stop'
            animator_stop(gcf);
            slicemap('newslice');
            
    end
end
