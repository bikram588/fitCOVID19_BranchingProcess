function [res, Y_proj, Im_matrix] = obj_Mu_and_Im(X, Z_0, mu_covid_pdf, Im_age_struct_prob, h, totalcases_hist, lambda)
% objective function for estimating the Branching Process (BP) parameters - R0 and Immigration probabilities, 
% such that the numerical approximation for the BP total progeny expectection is close to the actual total number of cases observed, but with
% penalization for 1) expected daily new cases curvature, 2) R0(t) curvature and 3) Immigration probabilities curvature

R0_daily = X(1:length(X)/2);
Im_mu_daily = X((1+length(X)/2):end);
R0 = reshape(repmat(R0_daily, 1/h,1), length(X)/2/h,1)';
Im_mu = reshape(repmat(Im_mu_daily, 1/h,1), length(X)/2/h,1)';

mu_matrix=R0.*repmat(mu_covid_pdf/(sum(mu_covid_pdf)*h),1, length(R0));

Im_matrix=Im_age_struct_prob .* Im_mu;

Y_proj = sum(Y_projection(Z_0, mu_matrix, Im_matrix, h))';
newcases_proj = diff(Y_proj(1:2:(length(totalcases_hist)/h)));

newcases_curvature = sqrt(sum((diff(newcases_proj,2)).^2))./length(newcases_proj);
R0_daily_curvature = sqrt(sum((diff(R0_daily,2)).^2))./length(R0_daily);
Im_mass_daily_curvature = sqrt(sum((diff(Im_mu_daily,2)).^2))./length(Im_mu_daily);

% the multiplication constants are chosen for regularization
res = 10*sqrt(sum((totalcases_hist - Y_proj(1:2:(length(totalcases_hist)/h))).^2))./(length(totalcases_hist)/h) + ...
    lambda(1)*100*newcases_curvature + lambda(2)*100*R0_daily_curvature + lambda(3)*100*Im_mass_daily_curvature;
end