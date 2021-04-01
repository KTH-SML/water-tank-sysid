% prepare data
clear u u1 u2 y y1 y2

y_rescale = 6.5/100; 
u_rescale = 1.0;
warmup_length = 128;
type_str = 'training';

for plant_ix = 5:8
    for realization_ix = 1:6

        ix_str = strcat(num2str(plant_ix), '_', num2str(realization_ix));
        base_fn = strcat(type_str , '_realization_', ix_str, '_');
        s_fn = strcat(base_fn, 'support_result');
        t_fn = strcat(base_fn, 'target_result');
        save_base_fn = strcat('prepared/', type_str , '_', ix_str, '_');
        save_s_fn = strcat(save_base_fn, 'support');
        save_t_fn = strcat(save_base_fn, 'target');

        load(s_fn);
        [y, u] = prep_data(y, u, y_rescale, u_rescale, warmup_length);
        save(save_s_fn, 'u', 'y');
        load(t_fn)
        [y, u] = prep_data(y, u, y_rescale, u_rescale, warmup_length);
        save(save_t_fn, 'u', 'y');
    end
end

function [y, u] = prep_data(y0, u0, y_scale, u_scale, warmup_length)
    y = y0 * y_scale;
    u = u0 * u_scale;
    y = y(warmup_length+1:end);
    u = u(warmup_length+1:end);
end