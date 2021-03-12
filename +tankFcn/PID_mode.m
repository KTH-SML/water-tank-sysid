function PID_mode(app)
    %% CONTROLLER SWITCH
    app.controller=app.PID;
    app.system.ref=app.RefSlider.Value;
    
    %% CONTROLLER SETTING PANAL
    app.RefSlider.Enable='On';
    app.RefEditField.Enable='On';
    app.ReferenceCheckBox.Value = true;
    app.InputSlider.Enable='Off';
    app.InputEditField.Enable='Off';
    
    app.KEditField.Enable='On';
    app.TiEditField.Enable='On';
    app.TdEditField.Enable='On';
    
    %% TANK SWITCH
    app.TankSwitch.Enable = 'On';
end