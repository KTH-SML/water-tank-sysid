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
        timeSequence
        controlSequence
        sampleSequence
        startTime
        sampleIndex
        isRunning
        isDone
    end
    methods
        % --- CONSTRUCTOR --- 
        function obj=ControllerREC(u_max)
            obj.controlSignal_max = u_max;
            obj.controlSignal_before = 0.0;
            obj.controlSignal_after = 0.0;
            obj.timeSequence = seconds(inf);
            obj.controlSequence = 0.0;
            obj.sampleSequence = 0;
            obj.startTime = datetime;
            obj.sampleIndex = 0;
            obj.isRunning = false;
            obj.isDone = false;
        end
       
        % --- METHOD: COMPUTING --- %
        function u_out = compute(obj,sample,sampleTime)
            % --- CONTROLLER UPDATING --- %
            if ~obj.isRunning
                u_out = 0.0;
            elseif obj.sampleIndex == 0
                obj.startTime = datetime(sampleTime);
                obj.sampleIndex = 1;
                obj.sampleSequence(obj.sampleIndex) = sample;
                u_out = obj.controlSequence(obj.sampleIndex);
            else
                dt = datetime(sampleTime) - obj.startTime;
                nextSampleTime = obj.timeSequence(obj.sampleIndex + 1);
                if dt > nextSampleTime
                    % increase sampleIndex by 1 and save sample
                    obj.sampleIndex = obj.sampleIndex + 1;
                    obj.sampleSequence(obj.sampleIndex) = sample;
                    if numel(obj.controlSequence) <= obj.sampleIndex
                        % Save sample and control sequences to .mat-file
                        % then empty sequences and stop run
                        obj.stop()
                        obj.isDone = true;
                        u_out = obj.compute(sample, sampleTime);
                    else
                        u_out = obj.controlSequence(obj.sampleIndex);
                    end
                else
                    u_out = obj.controlSignal_after;
                end
            end
            u_out = min(obj.controlSignal_max,max(u_out,0)); % input voltage saturation
            u_out = max(0.0, u_out);
            obj.controlSignal_after = u_out;
        end
       
        % --- METHOD: SET_CONTROL_SEQUENCE --- %
        function new_sequence_set = set_control_sequence(obj,newU,newT)
            if obj.isRunning
                new_sequence_set = false;
                return
            end
            obj.controlSequence = newU;
            numelU = numel(newU);
            if numel(newT) == 1
                times = linspace(0.0, numelU*newT, numelU + 1);
                obj.timeSequence = seconds(times);
            else
                obj.timeSequence = seconds(newT);
            end
            obj.sampleSequence = zeros(numelU + 1, 1);
            obj.sampleIndex = 0;
            obj.isDone = false;
            new_sequence_set = true;
        end
        
        % --- METHOD: STOP --- %
        function stop(obj)
            obj.isRunning = false;
            obj.sampleIndex = 0;
        end
    end
end
