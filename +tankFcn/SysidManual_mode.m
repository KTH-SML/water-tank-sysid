function SysidManual_mode(app)
    %% CONTROLLER SWITCH
    app.controller=app.Manual;
    app.system.ref=NaN;
    
    %% CONTROLLER SETTING PANAL
    app.InputSlider.Enable='On';
    app.InputEditField.Enable='On';
    app.RunButton.Enable='Off';
    %% TANK SWITCH
    app.TankSwitch.Enable = 'Off';
end