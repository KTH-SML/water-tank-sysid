% Controller class: class for hardware
% --- PROPERTY --- %
% Controller.timeSequence:    sample time points [N+1x1]
% Controller.controlSequence: control signal value at each sample point [Nx1]
% Controller.sampleSequence:  sample values at sample points [N+1x]
% Controller.startTime: Time of first sample
% Controller.sampleIndex
% --- METHOD --- %
% Controller.compute(): compute control signal
% Controller.set_control_sequence(): set a new control sequence

classdef ControllerREC < handle
    properties
        controlSignal_before
        controlSignal_after
        controlSignal_max
        sampleTime
        timeSequence
        controlSequence
        sampleSequence
        startTime
        sampleIndex
        isRunning
        isDone
        fileName
        wasStoped
    end
    methods
        % --- CONSTRUCTOR --- 
        function obj=ControllerREC(u_max)
            obj.controlSignal_max = u_max;
            obj.controlSignal_before = 0.0;
            obj.controlSignal_after = 0.0;
            obj.sampleTime = 1.0;
            obj.timeSequence = seconds(inf);
            obj.controlSequence = 0.0;
            obj.sampleSequence = 0;
            obj.startTime = datetime;
            obj.sampleIndex = 1;
            obj.isRunning = false;
            obj.isDone = false;
            obj.fileName = '';
            obj.wasStoped = true;
        end
       
        % --- METHOD: COMPUTING --- %
        function u_out = compute(obj,sample,sampleTime)
            % --- CONTROLLER UPDATING --- %
            if obj.isRunning
                dt = datetime(sampleTime) - obj.startTime;
                nextSampleTime = obj.timeSequence(obj.sampleIndex);
                if dt >= nextSampleTime
                    obj.sampleSequence(obj.sampleIndex) = sample;
                    if obj.sampleIndex >= numel(obj.sampleSequence)
                        obj.done()
                        obj.stop()
                        obj.isDone = true;
                    else
                        obj.controlSignal_after = obj.controlSequence(obj.sampleIndex);
                        obj.sampleIndex = obj.sampleIndex + 1;
                    end
                end
            end
            u_out = obj.controlSignal_after;
            u_out = min(obj.controlSignal_max,max(u_out,0)); % input voltage saturation
            u_out = max(0.0, u_out);
        end
        
        % --- METHOD: SET_TIME_SEQUENCE --- %
        function code = set_sample_time(obj, newT)
            if obj.isRunning
                code = 1;
                return
            end
            if newT <= 0.0
                code = 2;
                return
            end
            obj.sampleTime = newT;
            lenU = numel(obj.controlSequence);
            if lenU > 1
                time_points = linspace(0.0, lenU*newT, lenU + 1);
                obj.timeSequence = seconds(time_points);
            end
            obj.isDone = false;
            code = 0;
        end
        
        % --- METHOD: SET_CONTROL_SEQUENCE --- %
        function set_control_sequence(obj,newU)
            if obj.isRunning
                return
            end
            obj.controlSequence = newU;
            obj.set_sample_time(obj.sampleTime);
        end

        % --- METHOD: LOAD_FILE --- %
        function code = load_file(obj, file_path)
            if obj.isRunning
                code = 1;
                return
            end
            file_path_trunc = file_path(1:end-4);
            try
                signal_data = load(file_path_trunc);
            catch ME
                code = 2;
                return
            end
            try
                signal = signal_data.u;
            catch ME
                code = 3;
                return
            end
            if numel(signal) <= 1
                code = 4;
                return
            end
            obj.set_control_sequence(signal);
            obj.fileName = file_path;
            code = 0;
        end
        
        % --- METHOD: START --- %
        function code=start(obj)
            if obj.isRunning
                code = 1;
            elseif numel(obj.controlSequence) <= 1
                code = 2;
            elseif numel(obj.timeSequence) <= 1
                code = 3;
            else
                obj.startTime = datetime;
                lenU = numel(obj.controlSequence);
                obj.sampleSequence = zeros(lenU + 1, 1);
                obj.sampleIndex = 1;
                obj.isDone = false;
                obj.isRunning = true;
                code = 0;
            end
        end
        
        % --- METHOD: STOP --- %
        function stop(obj)
            obj.isRunning = false;
            obj.sampleIndex = 1;
            obj.controlSignal_after = 0.0;
            obj.wasStoped = true;
        end
        
        % --- METHOD: IS_READY--- %
        function result=is_ready(obj)
            if numel(obj.controlSequence) > 1 ...
                    && numel(obj.controlSequence)+1 == numel(obj.timeSequence)
                result = true;
            else
                result = false;
            end
        end
        
        function done(obj)
            signal_file_path = obj.fileName(1:end-4);
            save_file_path = get_save_file_name(signal_file_path);
            t = obj.timeSequence;
            u = obj.controlSequence;
            y = obj.sampleSequence;
            save(save_file_path, 't', 'u', 'y');
            obj.stop();
            obj.isDone = true;
            plot(y);
            title(save_file_path);
            ylabel('Value (%)');
            xlabel('time step');
        end
    end
end

function save_file_path = get_save_file_name(signal_file_path)
    file_path = strcat(signal_file_path, '_result');
    full_file_path = file_path;
    counter = 1;
    while exist(strcat(full_file_path, '.mat'), 'file')
        full_file_path = strcat(file_path, '(', int2str(counter), ')');
        counter = counter + 1;
    end
    save_file_path = full_file_path;
end
