function mainLoop(~,~,app)
% tic
    % --- DATA READING --- %
    sample_in = app.system.ReadData(app.controller);

    % --- OVERFLOW WARNING --- %
    tankFcn.ProcessOverflow(app);

    % --- CONTROLLER COMPUTING --- %
    app.controller.compute(sample_in,app.system.ref);
    
    % --- DATA WRITTING --- %
    app.system.WriteData(app.controller.controlSignal_after)
    
    % --- PLOT UPDATING -- %
    tankFcn.PlotUpdate(app);
% toc
end