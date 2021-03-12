function HW_mode(app)
    %% ENABLE OFF
    app.SimulatorSpeedUpDropDown.Value = '1x';
    app.SimulatorSpeedUpDropDown.Enable = 'Off';
    app.SimulatorspeedupLabel.Enable = 'Off';
    
    %% SYSTEM SWITCH
    app.system = app.HW;
    app.Timer.Period = app.system.Ts;
    
    %% TAP SWITCH
    app.TapSwitch.Enable='Off';
end