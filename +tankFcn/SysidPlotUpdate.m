function PlotUpdate(app)
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
     if app.REC.isRunning && app.REC.sampleIndex > 0
        time_total = app.REC.timeSequence(end);
        current_ix = app.REC.sampleIndex;
        % Time left
        time_left = time_total - app.REC.timeSequence(current_ix);
        time_left_str = datestr(time_left, 'HH:MM:SS');
        app.TimeLeftEditField.Value = time_left_str;
        % Estimated finish 
        estimated_finish = app.REC.startTime + time_total;
        finish_str = string(datetime(estimated_finish,'Format','HH:mm:ss'));
        app.EstimatedfinishEditField.Value = finish_str;
        % Percentage gauge
        time_percentage = 100 - 100 * time_left/time_total;
        app.RunpercentageGauge.Value = time_percentage;
    end
end