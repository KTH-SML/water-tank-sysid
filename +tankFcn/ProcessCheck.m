function ProcessCheck(app)
    if ~tankFcn.HW_detect()
        message = sprintf('NI hardware is not detected or DAQ toolbox is not installed.\n App will be only running in simulation mode.');
        uialert(app.DoubleTankProcess,message,'Warning',...
            'Icon','warning');
        app.SimRealSwitch.Value = 'Simulator';
        app.SimRealSwitch.Enable = 'Off';
    end
    app.AppIsRunning = false;
end