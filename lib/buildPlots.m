function buildPlots(NewCasesDaily, TotalCasesDaily, ActiveCasesDaily, NewCasesHist, dates, horizon, detection_time, alpha, scenario_name, scenario_title, varargin)
p=inputParser();
p.addOptional('SavePlots', false, @islogical);
p.parse(varargin{:});
save_plots = p.Results.SavePlots;

%%% helper function
[NewCasesDaily_mean, NewCasesDaily_lower, NewCasesDaily_upper, NewCasesDaily_median]=confInterval(NewCasesDaily, alpha);

%% number of new cases detected per day, model VS reality
% as the detection of the infection is after 8 days, we have 2 Branching Processes here:
% 1) real process happening in the population right now, but not yet detected
% 2) shifted process by 8 days so we can supperimpose with the real data and see if the model parameters are chosen correctly  
line_wd=2.5;
figure('visible','on', 'Units','pixels','OuterPosition',[0 0 1280 1024]);
set(gca,'FontSize',16)
hold on
h_hist=plot(dates, NewCasesHist, 'Color', [0, 0, 0, 0.7],'LineWidth', 1.5);
h_median_supperimposed=plot(dates(1):dates(end)+horizon, NewCasesDaily_median(1:end-detection_time-1), '-', 'Color', [1, 0, 0, 0.5], 'LineWidth', line_wd);
h_median_real=plot((dates(1):dates(end)+horizon)-detection_time, NewCasesDaily_median(1:end-detection_time-1), ':', 'Color', [0, 0.5, 0, 0.5], 'LineWidth', line_wd);
h_CI=plot((dates(1):dates(end)+horizon), NewCasesDaily_lower(1:end-detection_time-1), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
plot((dates(1):dates(end)+horizon), NewCasesDaily_upper(1:end-detection_time-1), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
legend([h_median_real, h_median_supperimposed, h_CI, h_hist], 'Median (Real Process)', 'Prediction of observed new daily cases', strcat(sprintf('%0.0f', 100*(1-2*alpha)), '% conf. interval'), 'Daily New Cases', 'Location', 'NorthWest')
xtickangle(90)
x_ticks = xticks;
xticks(x_ticks(1):7:x_ticks(end))
dateaxis('X',2)
ylabel('\bf{Daily New Cases (Observed)}')
xlabel('\bf{Date}')
title(scenario_title)
if save_plots
    print(strcat('./Figures/forecast_newcases_', scenario_name), '-dpng', '-r0')
end
%% total number of cases
[TotalCases_mean, TotalCases_lower, TotalCases_upper, TotalCases_median]=confInterval(TotalCasesDaily, alpha);

figure('visible','on', 'Units','pixels','OuterPosition',[0 0 1280 1024]);
set(gca,'FontSize',16)
hold on
h_hist=plot(dates, cumsum(NewCasesHist), 'Color', [0, 0, 0, 0.7],'LineWidth', 1.5);
h_median_supperimposed=plot(dates(1):(dates(end)+horizon), TotalCases_median(1:end-detection_time), '-', 'Color', [1, 0, 0, 0.5], 'LineWidth', line_wd);
h_median_real=plot((dates(1):dates(end)+horizon)-detection_time, TotalCases_median(1:end-detection_time), ':', 'Color', [0, 0.5, 0, 0.5], 'LineWidth', line_wd);
h_CI=plot(dates(1):dates(end)+horizon, TotalCases_lower(1:end-detection_time), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
plot(dates(1):dates(end)+horizon, TotalCases_upper(1:end-detection_time), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
legend([h_median_real, h_median_supperimposed, h_CI, h_hist], 'Median (Real Process)', 'Prediction of observed total cases', strcat(sprintf('%0.0f', 100*(1-2*alpha)), '% conf. interval'), 'Total Cases', 'Location', 'NorthWest')
xtickangle(90)
x_ticks = xticks;
xticks(x_ticks(1):7:x_ticks(end))
dateaxis('X',2)
ylabel('\bf{Total Cases (Observed)}')
xlabel('\bf{Date}')
title(scenario_title)
if save_plots
    print(strcat('./Figures/forecast_total_', scenario_name), '-dpng', '-r0')
end

%% total number of active cases
% on the data site there is no history for Active cases. In addition this measure is highly sensitive to the way we decide if the person is recovered
% or not, e.g. some countries measure the days being sick, other countries measure the time to clear the virus out of the body!
[ActiveCasesDaily_mean, ActiveCasesDaily_lower, ActiveCasesDaily_upper, ActiveCasesDaily_median]=confInterval(ActiveCasesDaily, alpha);

figure('visible','on', 'Units','pixels','OuterPosition',[0 0 1280 1024]);
set(gca,'FontSize',16)
hold on
h_median_supperimposed=plot(dates(1):dates(end)+horizon, ActiveCasesDaily_median(1:end-detection_time), '-', 'Color', [1, 0, 0, 0.5], 'LineWidth', line_wd);
h_CI=plot(dates(1):dates(end)+horizon, ActiveCasesDaily_lower(1:end-detection_time), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
plot(dates(1):dates(end)+horizon, ActiveCasesDaily_upper(1:end-detection_time), '--', 'Color', [0,155/255,1,1], 'LineWidth', line_wd);
plot([dates(end),dates(end)], [0, ActiveCasesDaily_median(length(dates))], '--', 'Color', [0,0,0,1], 'LineWidth', 1);

legend([h_median_supperimposed, h_CI], 'Prediction of observed active cases', strcat(sprintf('%0.0f', 100*(1-2*alpha)), '% conf. interval'), 'Location', 'NorthWest')
xtickangle(90)
x_ticks = xticks;
xticks(x_ticks(1):7:x_ticks(end))
dateaxis('X',2)
ylabel('\bf{Active Cases (Observed)}')
xlabel('\bf{Date}')
title(scenario_title)
if save_plots
    print(strcat('./Figures/forecast_active_', scenario_name), '-dpng', '-r0')
end

end