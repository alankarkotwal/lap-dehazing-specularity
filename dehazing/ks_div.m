
%% KS distance
function out = ks_div(x,k,theta)
  [y,bins] = hist(x(:));
  x = gampdf(bins*255,k,theta);  
  % find the CDF of the two function
  y = y/sum(y);
  x = x/sum(x);
  out = max(abs(x - y));
end  