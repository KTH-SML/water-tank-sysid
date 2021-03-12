function REC_mode(app, is_running)
    if is_running
        enable_str = 'Off';
    else
        enable_str = 'On';
    end

    %% CONTROLLER SWITCH
    app.controller=app.REC;

    %% SYSTEM SETTINGS PANEL
    app.StartStopSwitch.Enable=enable_str;
    app.SimRealSwitch.Enable=enable_str;
    
    %% CONTROLLER SETTING PANEL
    app.InputSlider.Enable='Off';
    app.InputEditField.Enable='Off';
    app.RunButton.Enable='On';
    
    % Run related settings
    if is_running
        app.RunButton.Text='Stop';
    else
        app.RunButton.Text='Start';
    end
    app.ManualRECSwitch.Enable=enable_str;
    app.SamplingtimeEditField.Enable=enable_str;
    app.OpenSignalButton.Enable=enable_str;
    app.SignalfileEditField.Enable=enable_str;
    
    %% TANK SWITCH
    app.TankSwitch.Enable = 'Off';
    app.TankSwitch.Value = 'Tank2';
    app.HW.tankChoice=2;
    app.SW.tankChoice=2;
    
    %% PLOT PANEL
    app.RunpercentageGauge.Enable = 'On';
    app.TimeLeftEditField.Enable = 'On';
    app.EstimatedfinishEditField.Enable = 'On';
    app.StatusLamp.Enable = 'On';
    if ~is_running
        app.TimeLeftEditField.Value = '00:00:00';
        app.EstimatedfinishEditField.Value = '00:00:00';
        app.RunpercentageGauge.Value = 0.0;
    end
end