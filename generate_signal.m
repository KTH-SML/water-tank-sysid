%% GENERATE SIGNAL
% clf
warmup_length = 128;
support_length = 512;
target_length = 512;
start_system_ix = 3;
num_systems = 2;
num_realizations = 2;
fn_prefix = 'training';

for i = start_system_ix:(start_system_ix + num_systems)
    for k = 1:num_realizations
        [u_support, u_target] = gen_signal_pair(warmup_length, support_length, target_length);
        system_index = i;
        data_index = k;
        file_path = strcat('signals/');
        base_file_name = strcat(fn_prefix, '_realization_',...
                                num2str(system_index), '_',...
                                num2str(data_index));
        sup_file_name = strcat(file_path, base_file_name, '_support');
        tar_file_name = strcat(file_path, base_file_name, '_target');
        u = u_support;
        signal_type = 'support';
        save(sup_file_name, 'u', 'signal_type', 'warmup_length', 'system_index', 'data_index');
        u = u_target;
        signal_type = 'target';
        save(tar_file_name, 'u', 'signal_type', 'warmup_length', 'system_index', 'data_index');
    end
end

function [u_support, u_target] = gen_signal_pair(warmup_length, support_length, target_length)
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

    support_opts = [support_length channels periods];
    target_opts = [target_length channels periods];
    warmup_opts = [warmup_length channels periods];

    u_warmup = idinput(warmup_opts, signal_type, band_low, range_low, WarmupSineData);
    u_warmup = u_warmup + idinput(warmup_opts, signal_type, band_high, range_high, WarmupSineData);
    u_support = idinput(support_opts, signal_type, band_low, range_low, SineData);
    u_support = u_support + idinput(support_opts, signal_type, band_high, range_high, SineData);
    u_target = idinput(target_opts, signal_type, band_low, range_low, SineData);
    u_target = u_target + idinput(target_opts, signal_type, band_high, range_high, SineData);

    u_warmup = prep_u(u_warmup, u_ss, u_min, u_max);
    u_support = prep_u(u_support, u_ss, u_min, u_max);
    u_target = prep_u(u_target, u_ss, u_min, u_max);
    u_support = vertcat(u_warmup, u_support);
    u_target = vertcat(u_warmup, u_target);
end

function u= prep_u(u, u_ss, u_min, u_max)
    max_voltage = 4.5;
    u = u - mean(u) + u_ss;
    u(u > u_max) = u_max;
    u(u < u_min) = u_min;
    u = u * (max_voltage/100);
end