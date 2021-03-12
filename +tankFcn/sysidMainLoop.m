function sysidMainLoop(~,thisEvent,app)
% tic
    % --- DATA READING --- %
    sample_in = app.system.ReadData(app.controller);

    % --- OVERFLOW WARNING --- %
    tankFcn.ProcessOverflow(app);

    % --- CONTROLLER COMPUTING --- %
    control_signal = app.controller.compute(sample_in, thisEvent.Data.time);
    
    % --- SYSID IS DONE CHECK --- %
    tankFcn.RECIsDone(app);

    % --- DATA WRITTING --- %
    app.system.WriteData(control_signal);
    
    % --- PLOT UPDATING -- %
    tankFcn.PlotUpdate(app);
% toc
end