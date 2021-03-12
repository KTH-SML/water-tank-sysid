% System class: class for hardware
% --- PROPERTY --- %
% System.model:       model information for state update. [structure]
% System.state:       current two water tank levels.      [1x2]
% System.ref:         controller reference, NaN for manual[1x1]
% System.controlSignal: 100% scale                        [1x1]
% System.History:     history vector storing state.       [Nx4] N:time/Ts
% System.tankChoice:  index for ReadData() 1 or 2         [1x1]
% System.Ts:          system sampling rate                [1x1] default: 0.05
% System.sysInfo:     N & Ts & model & delay              [structure]
% System.tankChoice:  which tank level to control 1 or 2  [1x1]
% System.History_con: vector storing delayed control      [nx1] n:delayTime/Ts
% --- METHOD --- %
% System.ReadData():  read data, store data, update obj.History.
% System.WriteData(): write data, update obj.controlSignal, model simulation

classdef Model < handle
    properties
        model
        state
        ref
        controlSignal
        History
        tankChoice
        tap_flag
        Ts
        sysInfo
        History_con
        counter
    end
    
    methods
        % --- METHOD: CONSTRUCTOR --- %
        function sys=Model(setting,ref)
            sys.sysInfo=setting;
            sys.model=setting.model;
            sys.state=zeros(1,2);
            sys.ref=ref;
            sys.controlSignal=0;
            sys.History=NaN(setting.NumSampleToHistory,7);
            sys.tankChoice=1;
            sys.tap_flag=false;
            sys.Ts=setting.Ts;
            sys.History_con=0;
            sys.counter=0;
        end
        
        % --- METHOD: DATA READING --- %
        function data=ReadData(obj,controller)
            
            % --- STATE, REF, CONTROL HISTORY UPDATING --- %
            obj.History=circshift(obj.History,[-1,0]);
            obj.History(end,1:2)=obj.state;
            obj.History(end,3)=obj.ref;
            obj.History(end,4)=obj.controlSignal;
            if isa(controller,'ControllerPID')
                obj.History(end,6)=controller.K*(1/controller.Ti)*controller.Ie;
                obj.History(end,7)=-controller.K*controller.Td*controller.De;
                obj.History(end,5)=(100/controller.controlSignal_max)*controller.controlSignal_before-sum(obj.History(end,6:7));
            else
                obj.History(end,5:7)=NaN(1,3);
            end
            
            % --- tankChoice SIGANL OUTPUT --- %
            data=obj.state(1,obj.tankChoice);
        end
        
        % --- METHOD: DATA WRITING & MODEL UPDATING --- %
        function WriteData(obj,data)
            
            if min(obj.state)< 0 || max(obj.state) > 100 % Hard saturation
                
                obj.state(obj.state < 0) = 0;
                obj.state(obj.state > 100) = 100;
            
                data = 0; % Set input to zero
            end
            
            % --- MODEL DELAY --- %
            delay = obj.sysInfo.delay; % second
            delay = delay/obj.Ts;      % numer of data point
            
            if isnan(obj.History(end-delay,1))
                obj.state = [0,0];
                obj.History_con = [obj.History_con;data];
            else
                % --- CONTROL HISTORY UPDATING --- %
                obj.History_con=circshift(obj.History_con,[-1,0]);
                obj.History_con(end,1)=data;
                
                % --- CONTROL SIGNAL HISTORY UPDATING --- %
                obj.controlSignal=(100/obj.sysInfo.max_vol)*data;
                
                % --- INTERFACE STATE --- %
                interface_state = (0.25/100)*obj.state;
                % --- MODEL --- %
                alpha1=obj.model.alpha1;
                alpha2=obj.model.alpha2;
                beta=obj.model.beta;
                if obj.tap_flag
                    interface_state(1,1) = interface_state(1,1) - obj.Ts*(2*alpha1*sqrt(2*9.81*interface_state(1,1)) - beta*obj.History_con(1,1));
                else
                    interface_state(1,1) = interface_state(1,1) - obj.Ts*(alpha1*sqrt(2*9.81*interface_state(1,1)) - beta*obj.History_con(1,1));
                end
                interface_state(1,2) = interface_state(1,2) + obj.Ts*(alpha1*sqrt(2*9.81*interface_state(1,1)) - alpha2*sqrt(2*9.81*interface_state(1,2)));
                % --- INTERFACE STATE --- %
                obj.state = real((100/0.25)*interface_state);
                % --- PROCESS COUNTER UPDATING --- %
                obj.counter = obj.counter+1;
            end
        end
    end
end

