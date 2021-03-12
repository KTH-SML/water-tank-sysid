function RECIsDone(app)
    if app.REC.wasStoped
        tankFcn.REC_mode(app, false);
        app.REC.wasStoped = false;
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