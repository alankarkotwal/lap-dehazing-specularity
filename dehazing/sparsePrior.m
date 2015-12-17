function out = sparsePrior(Js)

    out = 0.5*sum(sum(abs(Js)));
% out = length(Js(Js~=0));

end