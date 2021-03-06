function [fRms] = calc_FMdiversity(vDipDir,vDip,vRake)
    % Calculate focal mechanisms diversity using the code provided by J. Hardebeck.
    % [fRms] = calc_FMdiversity(vDipDir,vDip,vRake)
    % ------------------------------------------------------
    %
    % calculate focal mechanisms diversity using the code provided by J. Hardebeck.
    % Reference: J. Hardebeck, E. Hauksson, JGR, 2001, Vol 106, B10, 21859-21882,
    % Crustal stress field in southern California and its implications for fault
    % mechanisms.
    %
    % Input: Aki & Richards convetions
    % vDipDir : Dip direction
    % vDip    : Dip
    % vRake   : Rake
    %
    % Output:
    % fRMS : RMS value discribing the diversity
    %
    % Rule of thumbs: For events with focal mechanism errors in the range of
    % less than 10 deg, diversity is assumed to be enough for values above 40 deg;
    % for errors 10-20 deg, 45 deg is reasonable
    %
    % jowoe@gps.caltech.edu
    
    sZmapPath = './AddOneFiles/zmap/';
    %sZmapPath = '~/zmap/';
    
    
    % Array of focal mechanisms: dip direction, dip, rake
    mFPS = [vDipDir vDip vRake];
    
    % Do inversion using A. Michael code
    % Create file for inversion
    fid = fopen('Xtemp','w');
    fprintf(fid,'%7.3f  %7.3f  %7.3f\n',mFPS');
    fclose(fid);
    
    % Calculate diversity using j. Hardebecks Fortran code
    sPath = pwd;
    
    fmdiversity_cmd = append_system_specific_postfix(fullfile(sZmapPath,'external','fmdiversity'))
    system([fmdiversity_cmd, ' ', fullfile(sPath,Xtemp)])
    sGetFile = ['Xtemp.div'];
    fRms = load(sGetFile);
    
    % Delete temporary file
    delete(sGetFile);
end
