%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% adaBoost(data, classifiers, T)
%% INPUTS:
%%  - data, the positive and negative samples
%%  - classifiers, the generated weak classifiers
%%  - T, the amount of combined weak classifiers
%%
%% OUPUTS:
%%  - I, the indexes corresponding to the classifiers
%%  - alpha, the weights corresponding to the classifiers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I, alpha] = adaBoost(data, classifiers, T)
    % Initialize the weights uniform distributed
    m     = size(data);
    D_t   = ones(m);
    D_t   = D_t ./ m;
    
    % Initialize output
    alpha = zeros(1,T);
    I     = zeros(1,T);
    for t = 1:T
        [h_t, e_t] = bestWeakClassifier(D_t, data, classifiers);
        
        % Stop if our best weakclassifier isn't good enough anymore
        if e_t >= 0.5
            break;
        end

        % Update alpha
        alpha(t) = 0.5 * log( ( 1 - e_t ) / e_t );
        
        % Update D_t+1
        D_t      = updateWeights(D_t, data, classifiers(h_t));
        
        % Store the weak classifier
        I(t)     = h_t;
    end
end

function bestWeakClassifier(D_t, data, classifiers)
    % TODO
end

function updateWeights(D_t, data, h_t)
    % TODO
end