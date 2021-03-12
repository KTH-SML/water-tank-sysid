function SysidPlotUpdate(app)
    %% PREPARE
    NumSampleToPlot = app.figureOption.NumSampleToPlot;
    
    %% DATA PLOT
    % TANK LEVEL
    if app.tank1CheckBox.Value
        set(app.tank1_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,1));
    end
    if app.tank2CheckBox.Value
        set(app.tank2_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,2));
    end
    % CONTROL SIGNAL
    if app.ControlSignalCheckBox.Value
        set(app.controlSignal_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,4));
    end
    %% GAUGE PLOT
    app.tank1Gauge.Value = app.system.state(1,1);
    app.tank2Gauge.Value = app.system.state(1,2);
    
    %% REC Time estimates
     if app.REC.is_ready() % app.REC.isRunning && app.REC.sampleIndex > 0
        time_total = app.REC.timeSequence(end);
        % Time left
        if app.REC.isRunning
            time_passed = datetime - app.REC.startTime;
            time_left = time_total - time_passed;
        else
            time_left = time_total;
        end
        time_left_str = datestr(time_left, 'HH:MM:SS');
        app.TimeLeftEditField.Value = time_left_str;
        % Estimated finish
        if app.REC.isRunning
            estimated_finish = app.REC.startTime + time_total;
        else
            estimated_finish = datetime + time_total;
        end
        finish_str = string(datetime(estimated_finish,'Format','HH:mm:ss'));
        app.EstimatedfinishEditField.Value = finish_str;
        % Percentage gauge
        time_percentage = 100 - 100 * time_left/time_total;
        app.RunpercentageGauge.Value = time_percentage;
    %% Status lamp
        if app.REC.isRunning
            app.StatusLamp.Color = [1.0, 0.0, 0.0]; % Red
        elseif app.REC.isDone
            app.StatusLamp.Color = [0.0,1.0,0.0]; % Green
        elseif app.REC.is_ready()
            app.StatusLamp.Color = [0.33,0.33,1.0]; % White
        else
            app.StatusLamp.Color = [0.65,0.65,0.65]; % Gray
        end
    end
end