function [total_work] = calculate_work(sigma, eps, area, L0)
% If area=L0=1, intrinsic work is calculated
total_work = 0;

for i=1:length(sigma)-1
    delta_eps = (eps(i+1) - eps(i));
    av_sigma = (sigma(i+1) + sigma(i))/2.;
    total_work = total_work + area*L0*delta_eps*av_sigma;
end