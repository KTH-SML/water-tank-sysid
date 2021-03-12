
classdef TunerClass < handle  
    
    %class properties - access is private so nothing else can access these
    %variables. Useful in different sitionations
    properties 
        
        Kp;
        Ti;
        Td;
        gui_h;
        
        % model params - Poleplacement
        K_mode_pp;
        Tau_mode_pp;
        Gamma_mode_pp;

        % Poles - Pole placement 
        Chi;
        Zeta;
        Omega;

        % model params - LeadLag
        K_mode_ll;
        Tau_mode_ll;
        Gamma_mode_ll;

        % Lead Lag
        K_leadlag;
        Tau_I;
        Tau_D;
        Beta;
        
        selected_btn;
        h_scatter_poles;
        h_scatter_zeros;
        
        h_ll_mag;
        h_ll_phase;
        
        wout;
        
    end
    
    %Open class methods - in this case, it is restricted to the class
    %constructor. These functions can be accessed by calling the class
    %name. 

    methods
        
        %function - class constructor - creates and init's the gui
        function this = TunerClass
            
            %make the gui handle and store it locally
            this.gui_h = guihandles(Tuner);
            ReadParams(this);
            
            this.selected_btn = this.gui_h.radiobutton_G;
             
            %set the callback functions to the edit text box's
            set(this.gui_h.k_mod_pp, 'callback', @(src, event) UpdateKModePP(this, src, event));
            set(this.gui_h.Tau_mod_pp, 'callback', @(src, event) UpdateTauModePP(this, src, event));
            set(this.gui_h.Gamma_mod_pp, 'callback', @(src, event) UpdateGammaModePP(this, src, event));
            
            set(this.gui_h.chi_poles, 'callback', @(src, event) UpdateChiPole(this, src, event));
            set(this.gui_h.zeta_poles, 'callback', @(src, event) UpdateZetaPole(this, src, event));
            set(this.gui_h.omega_poles, 'callback', @(src, event) UpdateOmegaPole(this, src, event));
            
            set(this.gui_h.k_mod_ll, 'callback', @(src, event) UpdateKModeLL(this, src, event));
            set(this.gui_h.Tau_mod_ll, 'callback', @(src, event) UpdateTauModeLL(this, src, event));
            set(this.gui_h.Gamma_mod_ll, 'callback', @(src, event) UpdateGammaModeLL(this, src, event));
   
            set(this.gui_h.K_leadlag, 'callback', @(src, event) UpdateKLL(this, src, event));
            set(this.gui_h.tau_i, 'callback', @(src, event) UpdateTauILL(this, src, event));
            set(this.gui_h.tau_d, 'callback', @(src, event) UpdateTauDLL(this, src, event));
            set(this.gui_h.beta, 'callback', @(src, event) UpdateBetaLL(this, src, event));
            
            set(this.gui_h.plot_options, 'selectionchangefcn', @(src, event) Ui_callback(this, src, event));
            set(this.gui_h.Tuner,  'closerequestfcn', @(~,~) Close_fcn(this));
            
            this.wout = logspace(-3,1,100);
            
            InitPoleZeroPlot(this);
            InitLeadLagPlot(this);
        end
        
    end
    
    
    methods (Access = public)

        function this = ReadParams(this)
            
            % model params - Poleplacement
            this.K_mode_pp = str2num(get(this.gui_h.k_mod_pp,'String'));
            this.Tau_mode_pp = str2num(get(this.gui_h.Tau_mod_pp,'String'));
            this.Gamma_mode_pp = str2num(get(this.gui_h.Gamma_mod_pp,'String'));
            
            % Poles - Pole placement 
            this.Chi = -1*(str2num(get(this.gui_h.chi_poles,'String')));
            this.Zeta = str2num(get(this.gui_h.zeta_poles,'String')); 
            this.Omega = str2num(get(this.gui_h.omega_poles,'String'));
             
            % model params - LeadLag
            this.K_mode_ll = str2num(get(this.gui_h.k_mod_ll,'String'));
            this.Tau_mode_ll = str2num(get(this.gui_h.Tau_mod_ll,'String'));
            this.Gamma_mode_ll = str2num(get(this.gui_h.Gamma_mod_ll,'String'));
            
            % Lead Lag
            this.K_leadlag = str2num(get(this.gui_h.K_leadlag,'String'));
            this.Tau_I = str2num(get(this.gui_h.tau_i,'String'));
            this.Tau_D = str2num(get(this.gui_h.tau_d,'String'));
            this.Beta = str2num(get(this.gui_h.beta,'String'));

        end
        
        function UpdatePoleZeroPlot(this)
            
            %axes(this.gui_h.axes_poleplacement);
            
            % calculate PID parameters
            this.Kp = -(1+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+this.Gamma_mode_pp^2+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-3*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta)/(this.K_mode_pp*this.Gamma_mode_pp*(-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+this.Gamma_mode_pp^2+1));
            this.Ti = -(1+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+this.Gamma_mode_pp^2+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-3*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta)/(this.Tau_mode_pp^3*this.Omega^2*this.Chi^2*(-this.Gamma_mode_pp-1-2*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+2*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp)*this.Gamma_mode_pp^2);
            this.Td = -this.Tau_mode_pp*(1+4*this.Gamma_mode_pp+6*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+12*this.Chi^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4+6*this.Tau_mode_pp*this.Gamma_mode_pp^4*this.Chi+4*this.Chi^4*this.Tau_mode_pp^4*this.Gamma_mode_pp^4+13*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Chi^2+2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^3+this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-18*this.Gamma_mode_pp^3*this.Zeta*this.Omega*this.Tau_mode_pp+26*this.Gamma_mode_pp^3*this.Chi^2*this.Tau_mode_pp^2+18*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp+this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^4+6*this.Gamma_mode_pp^2+4*this.Gamma_mode_pp^3-4*this.Gamma_mode_pp^4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Zeta+2*this.Gamma_mode_pp^4*this.Chi*this.Omega^2*this.Tau_mode_pp^3+this.Gamma_mode_pp^4*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-56*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^2*this.Zeta*this.Omega-8*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4-4*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^3*this.Zeta+12*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^2+4*this.Omega^4*this.Tau_mode_pp^4*this.Gamma_mode_pp^4*this.Zeta^2-4*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4*this.Zeta-6*this.Tau_mode_pp*this.Gamma_mode_pp^4*this.Zeta*this.Omega+24*this.Gamma_mode_pp^3*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2-42*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3-20*this.Gamma_mode_pp^4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4+40*this.Chi*this.Tau_mode_pp^3*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^2-28*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Chi*this.Zeta*this.Omega-16*this.Chi*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^4+12*this.Gamma_mode_pp^3*this.Chi^3*this.Tau_mode_pp^3+32*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4+40*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^3*this.Zeta^2*this.Omega^2-8*this.Gamma_mode_pp^3*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3-6*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+18*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+13*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-18*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+12*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-28*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega-42*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+this.Gamma_mode_pp^4)/(-1-3*this.Gamma_mode_pp-6*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+6*this.Gamma_mode_pp^3*this.Zeta*this.Omega*this.Tau_mode_pp-12*this.Gamma_mode_pp^3*this.Chi^2*this.Tau_mode_pp^2-6*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp-3*this.Gamma_mode_pp^2-this.Gamma_mode_pp^3+8*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^4*this.Tau_mode_pp^5*this.Chi+16*this.Gamma_mode_pp^4*this.Chi^3*this.Tau_mode_pp^5*this.Zeta^2*this.Omega^2-14*this.Gamma_mode_pp^4*this.Chi^2*this.Tau_mode_pp^5*this.Omega^3*this.Zeta+6*this.Gamma_mode_pp^4*this.Chi^3*this.Tau_mode_pp^5*this.Omega^2-8*this.Gamma_mode_pp^4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Zeta+2*this.Gamma_mode_pp^4*this.Chi*this.Omega^2*this.Tau_mode_pp^3+7*this.Gamma_mode_pp^4*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2+24*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^2*this.Zeta*this.Omega-12*this.Gamma_mode_pp^3*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2-2*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3-8*this.Gamma_mode_pp^4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4-8*this.Gamma_mode_pp^3*this.Chi^3*this.Tau_mode_pp^3+8*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4-24*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^3*this.Zeta^2*this.Omega^2-8*this.Gamma_mode_pp^4*this.Chi^4*this.Tau_mode_pp^5*this.Zeta*this.Omega-8*this.Gamma_mode_pp^4*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^5*this.Chi^2+8*this.Gamma_mode_pp^3*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3-2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2+2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2+6*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp-12*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2-12*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+12*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2-12*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+4*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+7*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2+24*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+20*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-8*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+8*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-8*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta);
            N_pid = (-this.Gamma_mode_pp-1-2*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+2*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp)/(this.Tau_mode_pp*this.Gamma_mode_pp);

            F=this.Kp*(1+tf(1,[this.Ti 0])+tf([this.Td*N_pid 0],[1 N_pid]));
            G=tf(this.K_mode_pp,[this.Tau_mode_pp 1])*tf(this.Gamma_mode_pp,[this.Gamma_mode_pp*this.Tau_mode_pp 1]);
            Gc=feedback(F*G,1);

            %pzmap(this.gui_h.axes_poleplacement,minreal(Gc));
            
            zeros = zero(Gc);
            poles = pole(Gc);
            
            X = real(poles);
            Y = imag(poles);
            this.h_scatter_poles.YData = Y;
            this.h_scatter_poles.XData = X;
            
            X = real(zeros);
            Y = imag(zeros);
            this.h_scatter_zeros.YData = Y;
            this.h_scatter_zeros.XData = X;
            
        end
        
        function InitPoleZeroPlot(this)
            
            %axes(this.gui_h.axes_poleplacement);
            
            % calculate PID parameters
            this.Kp = -(1+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+this.Gamma_mode_pp^2+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-3*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta)/(this.K_mode_pp*this.Gamma_mode_pp*(-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+this.Gamma_mode_pp^2+1));
            this.Ti = -(1+2*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+this.Gamma_mode_pp^2+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+4*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-4*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+4*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-3*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-8*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta)/(this.Tau_mode_pp^3*this.Omega^2*this.Chi^2*(-this.Gamma_mode_pp-1-2*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+2*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp)*this.Gamma_mode_pp^2);
            this.Td = -this.Tau_mode_pp*(1+4*this.Gamma_mode_pp+6*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+12*this.Chi^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4+6*this.Tau_mode_pp*this.Gamma_mode_pp^4*this.Chi+4*this.Chi^4*this.Tau_mode_pp^4*this.Gamma_mode_pp^4+13*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Chi^2+2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^3+this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-18*this.Gamma_mode_pp^3*this.Zeta*this.Omega*this.Tau_mode_pp+26*this.Gamma_mode_pp^3*this.Chi^2*this.Tau_mode_pp^2+18*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp+this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^4+6*this.Gamma_mode_pp^2+4*this.Gamma_mode_pp^3-4*this.Gamma_mode_pp^4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Zeta+2*this.Gamma_mode_pp^4*this.Chi*this.Omega^2*this.Tau_mode_pp^3+this.Gamma_mode_pp^4*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2-56*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^2*this.Zeta*this.Omega-8*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4-4*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^3*this.Zeta+12*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^2+4*this.Omega^4*this.Tau_mode_pp^4*this.Gamma_mode_pp^4*this.Zeta^2-4*this.Omega^3*this.Tau_mode_pp^3*this.Gamma_mode_pp^4*this.Zeta-6*this.Tau_mode_pp*this.Gamma_mode_pp^4*this.Zeta*this.Omega+24*this.Gamma_mode_pp^3*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2-42*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3-20*this.Gamma_mode_pp^4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4+40*this.Chi*this.Tau_mode_pp^3*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^2-28*this.Tau_mode_pp^2*this.Gamma_mode_pp^4*this.Chi*this.Zeta*this.Omega-16*this.Chi*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^4+12*this.Gamma_mode_pp^3*this.Chi^3*this.Tau_mode_pp^3+32*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4+40*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^3*this.Zeta^2*this.Omega^2-8*this.Gamma_mode_pp^3*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3-6*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp+18*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2+13*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2-18*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2+12*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-28*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega-42*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+this.Gamma_mode_pp^4)/(-1-3*this.Gamma_mode_pp-6*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+6*this.Gamma_mode_pp^3*this.Zeta*this.Omega*this.Tau_mode_pp-12*this.Gamma_mode_pp^3*this.Chi^2*this.Tau_mode_pp^2-6*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp-3*this.Gamma_mode_pp^2-this.Gamma_mode_pp^3+8*this.Gamma_mode_pp^4*this.Zeta^2*this.Omega^4*this.Tau_mode_pp^5*this.Chi+16*this.Gamma_mode_pp^4*this.Chi^3*this.Tau_mode_pp^5*this.Zeta^2*this.Omega^2-14*this.Gamma_mode_pp^4*this.Chi^2*this.Tau_mode_pp^5*this.Omega^3*this.Zeta+6*this.Gamma_mode_pp^4*this.Chi^3*this.Tau_mode_pp^5*this.Omega^2-8*this.Gamma_mode_pp^4*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Zeta+2*this.Gamma_mode_pp^4*this.Chi*this.Omega^2*this.Tau_mode_pp^3+7*this.Gamma_mode_pp^4*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2+24*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^2*this.Zeta*this.Omega-12*this.Gamma_mode_pp^3*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2-2*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3-8*this.Gamma_mode_pp^4*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4-8*this.Gamma_mode_pp^3*this.Chi^3*this.Tau_mode_pp^3+8*this.Gamma_mode_pp^4*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4-24*this.Gamma_mode_pp^3*this.Chi*this.Tau_mode_pp^3*this.Zeta^2*this.Omega^2-8*this.Gamma_mode_pp^4*this.Chi^4*this.Tau_mode_pp^5*this.Zeta*this.Omega-8*this.Gamma_mode_pp^4*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^5*this.Chi^2+8*this.Gamma_mode_pp^3*this.Zeta^3*this.Omega^3*this.Tau_mode_pp^3-2*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^2+2*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^2+6*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp-12*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp^2-12*this.Chi^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+12*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp^2-12*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^2*this.Gamma_mode_pp^2+4*this.Chi*this.Omega^2*this.Tau_mode_pp^3*this.Gamma_mode_pp^3+7*this.Gamma_mode_pp^3*this.Tau_mode_pp^4*this.Chi^2*this.Omega^2+24*this.Chi*this.Tau_mode_pp^2*this.Gamma_mode_pp^2*this.Zeta*this.Omega+20*this.Chi^2*this.Zeta*this.Omega*this.Tau_mode_pp^3*this.Gamma_mode_pp^3-8*this.Chi^3*this.Zeta*this.Omega*this.Tau_mode_pp^4*this.Gamma_mode_pp^3+8*this.Chi^2*this.Zeta^2*this.Omega^2*this.Tau_mode_pp^4*this.Gamma_mode_pp^3-8*this.Chi*this.Omega^3*this.Tau_mode_pp^4*this.Gamma_mode_pp^3*this.Zeta);
            N_pid = (-this.Gamma_mode_pp-1-2*this.Chi*this.Tau_mode_pp*this.Gamma_mode_pp+2*this.Zeta*this.Omega*this.Tau_mode_pp*this.Gamma_mode_pp)/(this.Tau_mode_pp*this.Gamma_mode_pp);

            F=this.Kp*(1+tf(1,[this.Ti 0])+tf([this.Td*N_pid 0],[1 N_pid]));
            G=tf(this.K_mode_pp,[this.Tau_mode_pp 1])*tf(this.Gamma_mode_pp,[this.Gamma_mode_pp*this.Tau_mode_pp 1]);
            Gc=feedback(F*G,1);

            zeros = zero(Gc);
            poles = pole(Gc);
            
            X = real(zeros);
            Y = imag(zeros);
            this.h_scatter_zeros = scatter(this.gui_h.axes_poleplacement,X,Y,'o','b');
            hold(this.gui_h.axes_poleplacement,'on')

            X = real(poles);
            Y = imag(poles);
            this.h_scatter_poles = scatter(this.gui_h.axes_poleplacement,X,Y,'x','b');

            this.gui_h.axes_poleplacement.YLabel.String = 'imag';
            this.gui_h.axes_poleplacement.XLabel.String = 'real';
            
            grid(this.gui_h.axes_poleplacement,'on');
            
        end
        
        function UpdateLeadLagPlot(this)
            
            G = GetModelLeadLag(this);
            F = GetLeadLagCompensator(this);

            %set us a switch/case to handle the two current possible choises
            switch this.selected_btn
                case this.gui_h.radiobutton_G
                    sys = G;
                    
                case this.gui_h.radiobutton_FG
                    sys = G*F;
                    
                case this.gui_h.radiobutton_Gc
                    sys = feedback(G*F,1);
                    
            end
            
            N_pid = 1/(this.Tau_D*this.Beta);
            this.Ti = ((this.Tau_I+this.Tau_D)*N_pid-1)/N_pid;
            this.Td = (this.Tau_I*this.Tau_D-this.Ti/N_pid)/this.Ti;
            this.Kp = this.K_leadlag*this.Ti/(this.Beta*N_pid*this.Tau_D*this.Tau_I);
            
            [mag,phase] = bode(sys,this.wout);
            
            magn = reshape(mag,length(mag),1);
            phas = reshape(phase,length(phase),1);
            
            this.h_ll_mag.YData = mag2db(magn);
            %this.h_ll_mag.XData = wout;
            
            this.h_ll_phase.YData = phas;
            %this.h_ll_phase.XData = wout;
            
        end
        
        function InitLeadLagPlot(this)
            
            G = GetModelLeadLag(this);
            F = GetLeadLagCompensator(this);

            %set us a switch/case to handle the two current possible choises
            switch this.selected_btn
                case this.gui_h.radiobutton_G
                    sys = G;
                    
                case this.gui_h.radiobutton_FG
                    sys = G*F;
                    
                case this.gui_h.radiobutton_Gc
                    sys = feedback(G*F,1);
                    
            end
            
            N_pid = 1/(this.Tau_D*this.Beta);
            this.Ti = ((this.Tau_I+this.Tau_D)*N_pid-1)/N_pid;
            this.Td = (this.Tau_I*this.Tau_D-this.Ti/N_pid)/this.Ti;
            this.Kp = this.K_leadlag*this.Ti/(this.Beta*N_pid*this.Tau_D*this.Tau_I);
            
            [mag,phase] = bode(sys,this.wout);
            
            magn = reshape(mag,length(mag),1);
            phas = reshape(phase,length(phase),1);
            
            this.h_ll_mag = semilogx(this.gui_h.axes_leadlag_mag,this.wout,mag2db(magn));
            this.h_ll_phase = semilogx(this.gui_h.axes_leadlag_phase,this.wout,phas);
            
            linkaxes([this.gui_h.axes_leadlag_mag,this.gui_h.axes_leadlag_phase],'x');
            
       %     this.gui_h.axes_leadlag_mag.Children.set('DisplayName', 'Two Tank');
       
            this.gui_h.axes_leadlag_mag.YLabel.String = 'mag [dB]';
            this.gui_h.axes_leadlag_phase.YLabel.String = 'phase [deg]';
            this.gui_h.axes_leadlag_phase.XLabel.String = '\omega [rad/s]';
            
            grid(this.gui_h.axes_leadlag_mag,'on');
            grid(this.gui_h.axes_leadlag_phase,'on');
        end
        
        function delete(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infitie loop with the following delete command
            set(this.gui_h.Tuner,  'closerequestfcn', '');
            %delete the figure
            delete(this.gui_h.Tuner);
            %clear out the pointer to the figure - prevents memory leaks
            this.gui_h = [];
        end
        
        %function - Close_fcn
        %this is the closerequestfcn of the figure. All it does here is
        %call the class delete function (presented above)
        function Close_fcn(this) % , src, event
            delete(this);
        end
        
        % callbacks for editboxes
        function this = UpdateKModePP(this, src, event)
           this.K_mode_pp = str2num(get(this.gui_h.k_mod_pp,'String'));
           UpdatePoleZeroPlot(this)
        end
                
        function this = UpdateTauModePP(this, src, event)
           this.Tau_mode_pp = str2num(get(this.gui_h.Tau_mod_pp,'String'));
           UpdatePoleZeroPlot(this)
        end
        
        function this = UpdateGammaModePP(this, src, event)
           this.Gamma_mode_pp = str2num(get(this.gui_h.Gamma_mod_pp,'String'));
           UpdatePoleZeroPlot(this)
        end

        function this = UpdateChiPole(this, src, event)
           this.Chi = -1*str2num(get(this.gui_h.chi_poles,'String'));
           UpdatePoleZeroPlot(this)
        end
        
        function this = UpdateZetaPole(this, src, event)
           this.Zeta = str2num(get(this.gui_h.zeta_poles,'String'));
           UpdatePoleZeroPlot(this)
        end
        
        function this = UpdateOmegaPole(this, src, event)
           this.Omega = str2num(get(this.gui_h.omega_poles,'String'));
           UpdatePoleZeroPlot(this)
        end
    
       function this = UpdateKModeLL(this, src, event)
           this.K_mode_ll = str2num(get(this.gui_h.k_mod_ll,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateTauModeLL(this, src, event)
           this.Tau_mode_ll = str2num(get(this.gui_h.Tau_mod_ll,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateGammaModeLL(this, src, event)
           this.Gamma_mode_ll = str2num(get(this.gui_h.Gamma_mod_ll,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateKLL(this, src, event)
           this.K_leadlag = str2num(get(this.gui_h.K_leadlag,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateTauILL(this, src, event)
           this.Tau_I = str2num(get(this.gui_h.tau_i,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateTauDLL(this, src, event)
           this.Tau_D = str2num(get(this.gui_h.tau_d,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = UpdateBetaLL(this, src, event)
           this.Beta = str2num(get(this.gui_h.beta,'String'));
           UpdateLeadLagPlot(this)
        end
        
        function this = Ui_callback(this, src, event)
            
            %obtain the value of the selected radio button
            this.selected_btn = event.NewValue;
            UpdateLeadLagPlot(this);
        end
        
        function G = GetModelLeadLag(this)

            uppertank=tf([this.K_mode_ll],[this.Tau_mode_ll 1]);
            lowertank=tf([this.Gamma_mode_ll],[this.Gamma_mode_ll*this.Tau_mode_ll 1]);
            G=uppertank*lowertank;

        end

        function F = GetLeadLagCompensator(this)

            Lead = tf([this.Tau_D 1],[this.Beta*this.Tau_D 1]);
            Lag = tf([this.Tau_I 1],[this.Tau_I 0]);

            F = this.K_leadlag*Lead*Lag;
                
        end
        
    end
end