function LoadControlSequence(app, file_path)
    switch app.REC.set_sample_time(app.SamplingtimeEditField.Value)
        case 0
        case 1 % Process is already running
        case 2 % Sample time <= 0.0
            error_msg = strcat('Sampling time must be greater than 0');
            opts = struct('WindowStyle', 'modal', ...
                          'Interpreter', 'none');
            errordlg(error_msg, 'Invalid Value', opts);
            app.SamplingtimeEditField.Value = app.REC.sampleTime;
    end
    switch app.REC.load_file(file_path)
        case 0
            error_msg = '';
        case 1
            error_msg = strcat('Process is already running. Stop the process and try again if you want to load a new file.');
        case 2
            error_msg = strcat('File not found', file_path);
        case 3
            error_msg = strcat('No field named "u in file "', file_path);
        case 4
            error_msg = strcat('Field "u" in file "', file_path, ' only contains a single value');
    end
    if numel(error_msg) > 0
        opts = struct('WindowStyle', 'modal', ...
                      'Interpreter', 'none');
        errordlg(error_msg, 'File error', opts);
    end
    
end