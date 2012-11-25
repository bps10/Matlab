function [EYE_POS] = findEyePosition(nrFramesTotal,INDEX,EYE_DATA)
    % find mean eye location during each video frame.
    % [EYE_POS] = findEyePosition(video.nrFramesTotal,2);
    
    EYE_POS = zeros(nrFramesTotal,2);
    %foo = length(EYE_POS) - mod(length(EYE_POS),round(nrFramesTotal));
    %ave_len = foo/round(30);
    for i = 1:nrFramesTotal
        ind = INDEX((i*8)-7:(i*8)+1,1);

        x = EYE_DATA((i*8)-7:(i*8)+1,1);
        x = x(ind ~= 0);
        y = EYE_DATA((i*8)-7:(i*8)+1,2);
        y = y(ind ~= 0);
        EYE_POS(i,:) = [mean(x), mean(y)];
    end