function PlotPrepare(app)
    % --- PLOT PREPARATION --- %
    NumToPlot = app.figureOption.NumSampleToPlot;
    t = linspace(app.figureOption.axis_lim(1,1),app.figureOption.axis_lim(1,2),NumToPlot);
    grid(app.DataAquisition,'on');
    cla(app.DataAquisition)

    %% PLOT OBJECT
    hold(app.DataAquisition,'on')
    % --- COLOR SPECIFICATION SECTION --- % 
    tank1Color = [ 0    0.4470    0.7410 ];
    tank2Color = [ 0.8500    0.3250    0.0980 ];
    refColor = [ 0.9290    0.6940    0.1250 ];
    inputColor = [ 0.4940    0.1840    0.5560 ];
    PpartColor = [ 0.4660    0.6740    0.1880 ];
    IpartColor = [ 0.3010    0.7450    0.9330 ];
    DpartColor = [ 0.6350    0.0780    0.1840 ];
    % TANK LEVEL
    app.tank1_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',tank1Color);
    app.tank2_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',tank2Color);
    % REFERENCE
    app.ref_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',refColor);
    % CONTROL SIGNAL
    app.controlSignal_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',inputColor,'LineStyle','-.');
    app.Ppart_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',PpartColor,'LineStyle','-.');
    app.Ipart_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',IpartColor,'LineStyle','-.');
    app.Dpart_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',DpartColor,'LineStyle','-.');
    hold(app.DataAquisition,'off')
    legend(app.DataAquisition,'Tank1','Tank2','Reference','Input','P-part','I-part','D-part','Location','northwest');
    
    %% AXIS LIMIT
    app.DataAquisition.XLim=app.figureOption.axis_lim(1:2);
    app.DataAquisition.YLim=app.figureOption.axis_lim(3:4);
    
    %% YAXIS LOCATION
    app.DataAquisition.YAxisLocation = 'right';
end