function DetectAll(path)

    filesPath = sprintf('%s\\*.mat', path);
    files = dir(filesPath);
    filesSize = size(files, 1);

    t = cputime();
    index = 0;

    for file = files'
        fprintf('%s (%d \\ %d)\n', file.name, index, filesSize - 1);
        [~, baseFileNameNoExt, ~] = fileparts(file.name);
        filePath = sprintf('%s\\%s', path, baseFileNameNoExt);
        Detector(filePath);

        index = index + 1;
    end

    runningTime = cputime() - t;
    fprintf('Average time per record: %f\n', runningTime / filesSize);
    fprintf('Running time: %f\n', cputime() - t);
end

