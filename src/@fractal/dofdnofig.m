function [deltar]=dofdnofig(corint, r, radm, rasm) 
    % dofdnofig Calculation of the fractal dimension which is the slope on the log-log graph
    % This code is called from either Dcross.m, startfd.m or
    % Francesco Pacchiani 1/2000
    %
    %disp('fractal/codes/dofdim.m');
    %
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    deriv = diff(log10(corint))./diff(log10(r));    % deriv= Vector of the appr. derivatives
    r2 = r(1:(end-1));          % Forward difference approximation: deriv has one element less, and r must have the # of elements so r2
    %
    %
    % Calculation of the fractal dimension, by first calculating the
    % distances of depopulation "rd" and of saturation "rs".
    %
    %
    if isempty(radm) && isempty(rasm)
        
        rad = (rmax*(1/size(E,1))^(1/d))/3; % 2rmax= linear size of the hypercube encompassing a given dataset
        ras = rmax/(2*(d+1));
    else
        
        rad = radm;
        ras = rasm;
        
    end
    
    v = find(rad <= r2 & r2 <= ras);        % v= Vector of the all the interevent distances that fall in the interval [rn,rs]
    lr = log10(r2(v));
    lc = log10(corint(v));
    
    [coef, Err] = polyfit(lr,lc,1);
    [line, delta] = polyval(coef, log10(r2), Err);
    clear line Err
    
    rlc = lc(end:-1:1);
    rlr = lr(end:-1:1);
    reg = [ones(size(v,1),1),lr];
    
    [sl, cint, res, resint, stat] = regress(lc, reg, 0.25);
    
    deltar = sl(2,1) - cint(2,1);
    
end
