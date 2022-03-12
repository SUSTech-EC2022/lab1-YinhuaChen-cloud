function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
%% TODO
population_size = 4;
population = round(rand(population_size, 1) * 31);  % population matrix
nbGen = nbGen + 1;

% Evaluate the initial population
%% TODO
fitness = objective(population); % fitness matrix
[maxfit ,maxindex] = max(fitness);
fitness_gen = maxfit;   %best fitness so far
solution_gen = [solution_gen; dec2bin(population(maxindex,:))];  %best phenotype of each generation
fitness_pop = maxfit;   %best fitness in current population
bestSoFarFit = maxfit;
bestSoFarSolution = population(maxindex,:);
nbEval = nbEval + 1;

% Start the loop
while (nbEval<T) 
% Reproduction (selection, crossver)
%% TODO
    %selection
    possibilities = [0; getSelectionP(fitness)];   % the selection possibilities matrix
    intermediate_p = [];
    while size(intermediate_p, 1) < population_size
        r = rand();
        for i = 1:population_size
            if sum(possibilities(1:i)) < r && r <= sum(possibilities(1:i+1))
                p = population(i);
                break;
            end
        end
        intermediate_p = [intermediate_p; p];
    end
       
    %crossover
    next_generation = [];
    for i = 1:2:population_size
        r = round(rand() * 4);
        x1 = dec2bin(intermediate_p(i),5);
        x2 = dec2bin(intermediate_p(i+1),5);
%         x1(1:r)
%         x2(r+1:end)
        offspring1 = [x1(1:r), x2(r+1:end)];
        offspring2 = [x2(1:r), x1(r+1:end)];
        next_generation = [next_generation; offspring1; offspring2];
    end

% Mutation
%% TODO
    [r, c] = size(next_generation);
    for i = 1:r
        for j = 1:c
            ran = rand();
            if ran < 0.1
                next_generation(i,j) = num2str(mod(str2num(next_generation(i,j)) + 1,2));
            end
        end
    end

% Replacement & Evaluation
    population = bin2dec(next_generation);
    fitness = objective(population); % fitness matrix
    [maxfit ,maxindex] = max(fitness);
    if maxfit > fitness_gen
        fitness_gen = maxfit;   %best fitness so far
        bestSoFarFit = maxfit;
        bestSoFarSolution = population(maxindex,:);
    end
    solution_gen = [solution_gen; dec2bin(population(maxindex,:))];  %best phenotype of each generation
    fitness_pop = maxfit;   %best fitness in current population
    nbEval = nbEval + 1;
end
bestSoFarFit
bestSoFarSolution
% solution_gen





