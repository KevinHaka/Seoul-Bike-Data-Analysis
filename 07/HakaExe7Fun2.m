function [R_square_old, func_winner, func_name] = HakaExe7Fun2(tbl)
    % x data
    % y data
    
    % initial R^2 
    R_square_old = -1;

    for i=1:10
        temp_tbl = tbl;

        % transformations
        switch i
            case 1
                temp_tbl.x = log(tbl.x);
                arg = 'y ~ x';
            case 2
                temp_tbl.y = log(tbl.y);
                arg = 'y ~ x';
            case 3
                temp_tbl.x = log(tbl.x);
                temp_tbl.y = log(tbl.y);
                arg = 'y ~ x';
            case 4
                temp_tbl.x = 1./tbl.x;
                arg = 'y ~ x';
            case 5
                temp_tbl.y = 1./tbl.y;
                arg = 'y ~ x';
            case 6
                temp_tbl.x = 1./tbl.x;
                temp_tbl.y = 1./tbl.y;
                arg = 'y ~ x';
            case 7
                arg = 'y ~ x';
            case 8
                arg = 'y ~ x^2';
            case 9
                arg = 'y ~ x^3';
            case 10
                arg = 'y ~ x^4';
        end

        % security check
        if ~(isreal(temp_tbl.x) && isreal(temp_tbl.y)); continue; end

        %fit model
        mdl = fitlm(temp_tbl, arg);

        % selection condition
        if mdl.Rsquared.Adjusted > R_square_old
            R_square_old = mdl.Rsquared.Adjusted;
            func_winner = i;
        end
    end

    % result
    switch func_winner
        case 1
            func_name = "y = b0 + b1*log(x)";
        case 2
            func_name = "log(y) = b0 + b1*x";
        case 3
            func_name = "log(y) = b0 + b1*log(x)";
        case 4
            func_name = "y = b0 + b1/x";
        case 5
            func_name = "1/y = b0 + b1*x";
        case 6
            func_name = "1/y = b0 + b1/x";
        case 7
            func_name = "y = b0 + b1*x";
        case 8
            func_name = "y = b0 + b1*x + b2*x^2";
        case 9
            func_name = "y = b0 + b1*x + b2*x^2 + b3*x^3";
        case 10
            func_name = "y = b0 + b1*x + b2*x^2 + b3*x^3 + b4*x^4";
    end
end
