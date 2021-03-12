function SysidProcessPrepare(app)
    % --- INITIALIZE PARAMETERS --- %
    tankFcn.FreshPara;
    %% --- CONSTRUCTOR: SYSTEM --- %
    if tankFcn.HW_detect()
        app.HW=System(sysInfo, nan);
    end
    app.SW=Model(simInfo, nan);
    switch app.SimRealSwitch.Value
        case 'Real time'
            app.system = app.HW;
        case 'Simulator'
            app.system = app.SW;
    end

    %% --- CONSTRUCTOR: CONTROLLER --- %
    app.REC=ControllerREC();
    app.Manual=ControllerManual(max_vol);
    
    switch app.ManualRECSwitch.Value
        case 'Manual'
            tankFcn.Manual_mode(app);
            app.TankSwitch.Enable = 'Off';
        case 'REC'
            tankFcn.REC_mode(app);
            app.TankSwitch.Enable = 'On';
    end

    %% --- SPECIFICATION: plotting --- %
    app.figureOption = figureOption;
    tankFcn.PlotPrepare(app);

    %% --- CONSTRUCTOR: TIMER --- %
    app.Timer = timer;
    % --- TIMER SPECIFICATION --- %
    app.Timer.ExecutionMode = 'fixedRate';
    if isa(app.system,'Model')
        switch app.SimulatorSpeedUpDropDown.Value
            case '1x'; scale = 5;
            case '2x'; scale = 4;
            case '3x'; scale = 3;
            case '4x'; scale = 2;
            case '5x'; scale = 1;
        end
        app.Timer.Period = app.system.Ts*(scale/5);
    else
        app.Timer.Period = app.system.Ts;
        app.SimulatorSpeedUpDropDown.Value = '1x';
        app.SimulatorSpeedUpDropDown.Enable = 'Off';
        app.SimulatorspeedupLabel.Enable = 'Off';
    end
    app.Timer.TimerFcn = {@tankFcn.sysidMainLoop,app}; % MAIN LOOP EXECUTED BY TIMER

end



