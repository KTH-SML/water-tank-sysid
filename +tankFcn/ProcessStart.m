function ProcessStart(app)
    %% ENABLE OFF PROCESS SWITCH
    app.SimRealSwitch.Enable='Off';
    
    %% START PROCESS
    if isa(app.system,'Model')
        switch app.SimulatorSpeedUpDropDown.Value
            case '1x'; scale = 5;
            case '2x'; scale = 4;
            case '3x'; scale = 3;
            case '4x'; scale = 2;
            case '5x'; scale = 1;
        end
        app.Timer.Period = app.system.Ts*(scale/5);
    end
    start(app.Timer);
    app.AppIsRunning = true;
end