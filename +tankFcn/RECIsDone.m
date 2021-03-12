function RECIsDone(app)
    if app.REC.isDone
        signal_file_path = app.SignalfileEditField.Value(1:end-4);
        save_file_path = get_save_file_name(signal_file_path);
        t = app.REC.timeSequence;
        u = app.REC.controlSequence;
        y = app.REC.sampleSequence;
        save(save_file_path, 't', 'u', 'y');
        app.REC.isDone = false;
        tankFcn.REC_mode(app, false);
    end
end

function save_file_path = get_save_file_name(signal_file_path)
    file_path = strcat(signal_file_path, '_result');
    full_file_path = file_path;
    counter = 1;
    while isfile(strcat(full_file_path, '.mat'))
        full_file_path = strcat(file_path, '(', int2str(counter), ')');
        counter = counter + 1;
    end
    save_file_path = full_file_path;
end