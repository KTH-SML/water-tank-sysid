function Manual_mode(app)
    %% CONTROLLER SWITCH
    app.controller=app.Manual;
    app.system.ref=NaN;
    
    %% CONTROLLER SETTING PANAL
    app.RefSlider.Enable='Off';
    app.RefEditField.Enable='Off';
    
    app.InputSlider.Enable='On';
    app.InputEditField.Enable='On';
    
    app.KEditField.Enable='Off';
    app.TiEditField.Enable='Off';
    app.TdEditField.Enable='Off';
    
    %% TANK SWITCH
    app.TankSwitch.Enable = 'Off';
end