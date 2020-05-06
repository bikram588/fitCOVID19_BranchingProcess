function N=Y_projection(Z_0, mu_matrix, Im_matrix, h)
% implements a numerical method for calculating the total progeny of the branching process (BP), which is the expectation of the BP, given there is
% no death, i.e. S(t)=1 for every t. This is used in an optimization procedure to find the parameters of the BP so that the projection equals 
% the history so far (i.e. method of moments)
% More details on the numerical approximation for the expectation of a BP is discussed in:
% Crump-Mode-Jagers Branching Process: A Numerical Approach. Pages 167-182, Trayanov, Plamen
% Book: Branching Processes and Their Applications
% Editors: del Puerto, I.M., González, M., Gutiérrez, C., Martínez, R., Minuesa, C., Molina, M., Mota, M., Ramos, A. (Eds.) 

N=zeros(size(Z_0,1), size(mu_matrix,2));
N(:,1)=Z_0;
for t=1:size(mu_matrix,2)
    if ~isempty(Im_matrix)
        N(:,t) = N(:,t) + Im_matrix(:, t);
    end
    N(1,t+1) = N(:,t)'*mu_matrix(:, t)*h;
    % no dying:
    N(2:end, t+1) = N(1:end-1, t);
    N(end, t+1) = N(end, t+1) + N(end, t);
end
end