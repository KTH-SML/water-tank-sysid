function ProcessDelete(app)
    %% DELETE TIMER
    if isa(app.Timer,'timer')
        delete(app.Timer);
    end

    %% DELETE DAQ SESSION
    if isa(app.system,'System')
        daqreset;
    end
    
%     if isa(app.ControllerTuner,'TunerClass') && isvalid(app.ControllerTuner) 
%         h = app.ControllerTuner;
%         app.ControllerTuner.Close_fcn(h)
%     end
end