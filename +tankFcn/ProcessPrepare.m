function ProcessPrepare(app)
    % --- INITIALIZE PARAMETERS --- %
    tankFcn.FreshPara;
    %% --- CONSTRUCTOR: SYSTEM --- %
    if tankFcn.HW_detect()
        app.HW=System(sysInfo,app.RefSlider.Value);
    end
    app.SW=Model(simInfo,app.RefSlider.Value);
    switch app.SimRealSwitch.Value
        case 'Real time'
            app.system = app.HW;
        case 'Simulator'
            app.system = app.SW;
    end

    %% --- CONSTRUCTOR: CONTROLLER --- %
    control_P   = app.KEditField.Value;
    control_I   = app.TiEditField.Value;
    control_D   = app.TdEditField.Value;
    app.PID=ControllerPID(control_P,control_I,control_D,Ts,max_vol);
    switch app.AntiWindUpSwitch.Value
        case 'On'
            app.PID.AntiWindUp_flag = true;
        case 'Off'
            app.PID.AntiWindUp_flag = false;
    end
    
    app.Manual=ControllerManual(max_vol);
    
    switch app.ManualPIDSwitch.Value
        case 'Manual'
            tankFcn.Manual_mode(app);
            app.TankSwitch.Enable = 'Off';
        case 'PID'
            tankFcn.PID_mode(app);
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
    app.Timer.TimerFcn = {@tankFcn.mainLoop,app}; % MAIN LOOP EXECUTED BY TIMER

end



