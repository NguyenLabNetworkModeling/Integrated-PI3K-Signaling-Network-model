%% Shaded line plot
% Example showing the difference between the standard plot routine and the
% shaded routine

%% Distribution plots
% Show different plot routines to visualize measurement errors/noise

X = 1:0.25:10;
Y = sin(X)+0.25*X;
Y_error = randn(1000,numel(Y));
Y_noisy = Y+Y_error.*repmat(0.1*X,[size(Y_error,1) 1]);


figure;

plot(X,Y,'o','LineWidth',1.5);
title('plot (True value y=f(x))');
ylim([-1 5]);
hold on

%plot(X,Y,'LineWidth',1.5);
plot_distribution_prctile(X,Y_noisy,'Prctile',[25 50 75 90]);
hold off
title('plot\_distribution\_prctile');
ylim([-1 5]);


