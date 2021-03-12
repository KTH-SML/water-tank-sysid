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
    % REFERENCE
    if app.ReferenceCheckBox.Value
        set(app.ref_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,3));
    end
    % CONTROL SIGNAL
    if app.ControlSignalCheckBox.Value
        set(app.controlSignal_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,4));
    end
    if app.PpartCheckBox.Value
        set(app.Ppart_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,5));
    end
    if app.IpartCheckBox.Value
        set(app.Ipart_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,6));
    end
    if app.DpartCheckBox.Value
        set(app.Dpart_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,7));
    end
    %% GAUGE PLOT
    app.tank1Gauge.Value = app.system.state(1,1);
    app.tank2Gauge.Value = app.system.state(1,2);
end