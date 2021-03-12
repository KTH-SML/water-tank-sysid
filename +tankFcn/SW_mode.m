function SW_mode(app)
    %% ENABLE OFF
    app.SimulatorSpeedUpDropDown.Enable = 'On';
    app.SimulatorspeedupLabel.Enable = 'On';
    
    %% SYSTEM SWITCH
    app.system = app.SW;
    app.TapSwitch.Enable = 'On';
end