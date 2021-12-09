% Window size should be 5 or 7.
function [idx] = QRSChenDetect(fileName)
    
    %% Constants

    % windowSize should be [3, 5, 7]
    highPassSize = 7;

    if (mod(highPassSize, 2) == 0)
        throw(MException('MADetect:windowSizeNotOdd', 'Window size must be odd.'))
    end

    S = load(fileName);
    x = S.val(1, :);
    xLength = size(x, 2);
    
    %% High-pass filter
    
    % Moving window size
    windowSize = 7;
    % Numerator
    a = 1;
    % Denominator
    b = (1 / windowSize) * ones(1, windowSize);

    % Moving average filter
    y1 = filter(b, a, x);

    delayLength = (windowSize + 1) / 2;
    delay = x(1) * ones(1, delayLength);
    y2 = [delay, x(1:end - delayLength)];

    y = y2 - y1;

    %% Low-pass filter
    samplingSize = 36;
    y = power(y, 2);
    % Trailing moving window summation
    y = movsum(y, [samplingSize, 0]);

    %% Decision making

    featureSize = 125;
    gamma = 0.1;
    numberOfFeatures = xLength / featureSize;

    threshold = max(y(1:250)) - 1;
    detections = zeros(1, xLength);

    for i = 1 : numberOfFeatures
        
        feature = y(((i - 1) * (featureSize) + 1): i * featureSize);
        
        [peak, peakIndex] = max(feature);

        % Convert index to whole record index
        peakIndex = (i - 1) * featureSize + peakIndex;

        if peak >= threshold && (peakIndex < 51 || sum(detections(peakIndex - 50 : peakIndex)) == 0)
            detections(peakIndex) = 1;

            % Update threshold
            alpha = 0.01 + rand*(0.1 - 0.01);
            threshold = alpha * gamma * peak + (1 - alpha) * threshold;
        end
    end
    
    idx = find(detections == 1);
end



