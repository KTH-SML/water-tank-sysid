function PlotCapture(app)
    figure; hold on;
    NumToCapture = ceil(app.SecondsToCaptureEditField.Value/app.system.Ts);
    x_start = app.system.counter*app.system.Ts-app.SecondsToCaptureEditField.Value;
    x_end = app.system.counter*app.system.Ts;
    x = linspace(x_start,x_end,NumToCapture);
    y1 = app.system.History(end-NumToCapture+1:end,1);
    y2 = app.system.History(end-NumToCapture+1:end,2);
    yref = app.system.History(end-NumToCapture+1:end,3);
    ycon = app.system.History(end-NumToCapture+1:end,4);
    Ppart = app.system.History(end-NumToCapture+1:end,5);
    Ipart = app.system.History(end-NumToCapture+1:end,6);
    Dpart = app.system.History(end-NumToCapture+1:end,7);
    % --- COLOR SPECIFICATION SECTION --- % 
    tank1Color = [ 0    0.4470    0.7410 ];
    tank2Color = [ 0.8500    0.3250    0.0980 ];
    refColor = [ 0.9290    0.6940    0.1250 ];
    inputColor = [ 0.4940    0.1840    0.5560 ];
    PpartColor = [ 0.4660    0.6740    0.1880 ];
    IpartColor = [ 0.3010    0.7450    0.9330 ];
    DpartColor = [ 0.6350    0.0780    0.1840 ];
    
    if app.tank1CheckBox.Value
        plot(x,y1,'Color',tank1Color);
    end
    if app.tank2CheckBox.Value
        plot(x,y2,'Color',tank2Color);
    end
    if app.ReferenceCheckBox.Value
        plot(x,yref,'Color',refColor);
    end
    if app.ControlSignalCheckBox.Value
        plot(x,ycon,'Color',inputColor,'LineStyle','-.');
    end
    if app.PpartCheckBox.Value
        plot(x,Ppart,'Color',PpartColor,'LineStyle','-.');
    end
    if app.IpartCheckBox.Value
        plot(x,Ipart,'Color',IpartColor,'LineStyle','-.');
    end
    if app.DpartCheckBox.Value
        plot(x,Dpart,'Color',DpartColor,'LineStyle','-.');
    end
    axis([x_start,x_end,app.figureOption.axis_lim(3:4)])
    xlabel('time [s]'); ylabel('Y [%]'); 
%     legend('tank1','tank2','Reference','Control signal','P-part','I-part','D-part','Location','northwest'); 
    grid on;
    hold off;
end