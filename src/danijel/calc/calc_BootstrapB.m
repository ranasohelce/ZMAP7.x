function [fStdDevB, fStdDevMc, fBValue, fMc, vBValues] = calc_BootstrapB(mCatalog, nNumberRuns, nMinNum, nCalculateMc, fBinning)
    % Computes standard deviation of b-value and Mc by bootstrapping the dataset.
    %
    % [fStdDevB, fStdDevMc, fBValue, fMc, vBValues] = calc_BootstrapB(mCatalog, nNumberRuns, nMinNum, nCalculateMc, fBinning)
    %
    %
    % Input parameters:
    %   mCatalog          Earthquake catalog to be used
    %   nNumberRuns       Number of simulation runs (Bootstrap)
    %   nMinNum           Minimum number of events > Mc for computing a b-value (after bottstrapping sample)
    %   nCalculateMC      Method to determine the magnitude of completeness (see also: help calc_Mc)
    %   fBinning          Magnitude binning of the catalog
    %
    % Output parameters:
    %   fStdDevB          Standard deviation of the computed b-values as the second moment of the b-value distribution
    %   fStdDevMc         Standard deviation of the computed Mc as the second moment of the Mc distribution
    %   fBValue           Mean b-value of bootstrapped samples
    %   fMc               Mean Mc of bootstrapped samples
    %   vBValues          Vector of all bootstrapped b-values
    %
    % Danijel Schorlemmer
    % June 18, 2003
    
    report_this_filefun();
    
    % Get number of events in catalog
    nLength = mCatalog.Count;
    % Init container
    mResult = [];
    % Bootstrap loop
    for nRuns = 1:nNumberRuns
        % Iniy the bootstrapped catalog
        mLoopCatalog = [];
        % Get the random selection of events (multiples allowed)
        vRnd = ceil(rand(nLength,1) * nLength);
        % Create the bootstrapped catalog
        mLoopCatalog = mCatalog.subset(vRnd);
        % Reduce bootstrapped catalog to all events with M >= Mc
        fMc = calc_Mc(mLoopCatalog, McMethods.McBestCombo, fBinning);
        vSel = mLoopCatalog(:,6) >= fMc;
        mLoopCatalog = mLoopCatalog(vSel,:);
        % If enough events remain, compute b-value
        if length(mLoopCatalog(:,1)) >= nMinNum
            % Calculate b-value from bootstrapped catalog
            [fBValue] =  calc_bmemag(mLoopCatalog, fBinning);
        else
            % Not enough events available
            fBValue = nan;
        end
        % Store the results
        mResult = [mResult; fBValue fMc];
    end
    % Return values
    fBValue = mean(mResult(:,1), 'omitnan');
    fMc = mean(mResult(:,2), 'omitnan');
    % Compute the standard deviation of Mc as the second moment of the Mc distribution
    vSel = ~isnan(mResult(:,2));
    vDist = mResult(vSel,2);
    fStdDevMc = std(vDist,1,'omitnan');
    % Compute the standard deviation of b as the second moment of the b distribution
    vSel = ~isnan(mResult(:,1));
    vBValues = mResult(vSel,1);
    fStdDevB = std(vBValues,1,'omitnan');
end