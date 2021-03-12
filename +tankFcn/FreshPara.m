% --- SETTING: BASIC --- %
Ts=0.05;
max_vol = 3; % old power module: 3v, new power module: 5v
time=600;  % 10 min to store
NumSampleToHistory=int32(time/Ts);
NumSampleToPlot=int32(app.TspanEditField.Value/Ts);

% --- SETTING: GUI PLOT --- %
f1='axis_lim'; v1=[-app.TspanEditField.Value,0,app.YminEditField.Value,app.YmaxEditField.Value];
f2='NumSampleToHistory'; v2=NumSampleToHistory;
f3='NumSampleToPlot'; v3=NumSampleToPlot;
figureOption = struct(f1,v1,f2,v2,f3,v3);

% --- SETTING: REALTIME --- %
sysInfo = struct('Ts',Ts,f2,v2,'max_vol_in',5,'max_vol',max_vol);

% --- SETTING: SIMULATION --- %
d=4.763e-3; D =44.45e-3; max_in=50e-6;
model.alpha1=d^2/D^2;
model.alpha2=model.alpha1;
model.beta=max_in/max_vol/(pi/4*D^2);
delay = 0; % second
simInfo = struct('Ts',Ts,f2,v2,'model',model,'delay',delay,'max_vol',max_vol);

