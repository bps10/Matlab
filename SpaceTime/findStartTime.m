function [START_TIME] = findStartTime(EYE_POS,SIZE,FPS)
% find location of start time, unless user has defined manual start time.
% [START_TIME] = findStartTime(EYE_POS)


times = find(isnan(EYE_POS));
foo = [times', length(EYE_POS)] - [0, times'];
foo = foo > SIZE + 30;
if sum(foo) == 0
    error('No continuous string long enough for analysis.Choose shorter analysis time')
else
    t = find(foo,1);
    if t ==1
        START_TIME = 0;
    else
        START_TIME = (times(t-1) + 1)/FPS; clear times; clear t;
    end
end
