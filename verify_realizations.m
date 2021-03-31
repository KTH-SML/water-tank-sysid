clear u u1 u2 y1 y2
clf
plant_ix = 5;
realization_ix = 6;
ix_str = strcat(num2str(plant_ix), '_', num2str(realization_ix));

base_fn = strcat('training_realization_', ix_str, '_');
s_fn = strcat(base_fn, 'support_result');
t_fn = strcat(base_fn, 'target_result');
load(s_fn)
y1 = y;
u1 = u;
load(t_fn)
y2 = y;
u2 = u;
y_amp = max([max(y1), max(y2)]) - min([min(y1), min(y2)]);
mean_diff = (mean(y2(1:128)) - mean(y1(1:128))) / y_amp
start_diff = y2(128) - y1(128)
%y2 = y2 - mean_diff/2;

subplot(2, 1, 1);
title('y');
hold on
plot(y1);
plot(y2);
plot([128, 128], ylim, '--b')
hold off
subplot(2, 1, 2);
title('u');
hold on
plot(u1);
plot(u2);
plot([128, 128], ylim, '--b')
hold off
% mean(y1(1:128))
% mean(y2(1:128))
