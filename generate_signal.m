%% GENERATE SIGNAL
clf
warmup_length = 128;
signal_length = 512;
channels = 1;
periods = 1;
signal_type = 'sine';
Ts = 4; % Sampling time (s)
desired_freq = 0.0144;
nyq_freq = 0.5/Ts;
band_max = desired_freq / nyq_freq;
band_low = [0 band_max/3];
band_high = [band_max/3 band_max];
range_low = [30.0 60.0];
high_low_ratio = 4;
range_high_min = mean(range_low) - range_low(end)/high_low_ratio;
range_high_max = mean(range_low) + range_low(end)/high_low_ratio;
range_high = [range_high_min range_high_max];

NumSinusoids = 9;
NumTrials = 10;
GridSkip = 1;
SineData = [NumSinusoids,NumTrials,GridSkip];
WarmupSineData = [round(NumSinusoids/5),NumTrials,GridSkip];

% u options
u_ss = 35;
u_max = 100;
u_min = 0.0;

sig_opts = [signal_length channels periods];
warmup_opts = [warmup_length channels periods];

u_warmup = idinput(warmup_opts, signal_type, band_low, range_low, WarmupSineData);
u_warmup = u_warmup + idinput(warmup_opts, signal_type, band_high, range_high, WarmupSineData);
u_support = idinput(sig_opts, signal_type, band_low, range_low, SineData);
u_support = u_support + idinput(sig_opts, signal_type, band_high, range_high, SineData);
u_target = idinput(sig_opts, signal_type, band_low, range_low, SineData);
u_target = u_target + idinput(sig_opts, signal_type, band_high, range_high, SineData);

u_warmup = prep_u(u_warmup, u_ss, u_min, u_max);
u_support = prep_u(u_support, u_ss, u_min, u_max);
u_target = prep_u(u_target, u_ss, u_min, u_max);
u_support = vertcat(u_warmup, u_support);
u_target = vertcat(u_warmup, u_target);
plot(u_support);
hold on
plot(u_target);
hold off
system_index = 1;
sup_file_name = strcat('realization_', num2str(system_index), '_support');
tar_file_name = strcat('realization_', num2str(system_index), '_target');
u = u_support;
save(sup_file_name, 'u');
u = u_target;
save(tar_file_name, 'u');

function u= prep_u(u, u_ss, u_min, u_max)
    max_voltage = 4.5;
    u = u - mean(u) + u_ss;
    u(u > u_max) = u_max;
    u(u < u_min) = u_min;
    u = u * (max_voltage/100);
end