function [possibilities] = getSelectionP(fitness)
    s = sum(fitness);
    possibilities = fitness./s;
end

