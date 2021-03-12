function ProcessStop(app)   
    %% ENABLE ON
    app.SimRealSwitch.Enable='On';
    
    %% STOP DAQ SESSION & FILTER PERSISTENT VARIABLE FLUSH
    if isa(app.system,'System')
        % --- OUTPUT ZERO SET --- %
        outputSingleScan(app.system.session,0);

        % --- CONTROLLER STATE RESET --- %
        app.PID.Ie=0;
        app.PID.D_state=0;
        app.PID.De=0;
    end

    %% STOP TIMER
    if isa(app.Timer,'timer')
        stop(app.Timer)
    end
    
    %% APP ENABLE ON
    app.AppIsRunning = false;

end