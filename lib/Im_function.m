function Im_matrix = Im_function(mu, sgm, Im_age_struct_prob)
Im_matrix=zeros(size(Im_age_struct_prob,1), 1, size(mu,2));

theta = sgm.^2./mu;
k = (mu./sgm).^2;
theta(mu==0)=0;
k(sgm==0)=0;

Im_matrix(:,1,:)=mnrnd(round(gamrnd(k, theta)'), Im_age_struct_prob)';
if any(isnan(Im_matrix(:)))
    error('Im_matrix contains nans!')
end
end

