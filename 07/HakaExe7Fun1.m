function T = HakaExe7Fun1(columns)
    arguments; columns = []; end

    data = importdata("../SeoulBike.xlsx");
    
    T = splitvars(table(data.textdata(2:end,1), data.data));
    T.Properties.VariableNames = convertCharsToStrings(data.textdata(1,:));
    if  ~isempty(columns), T = T(:, columns); end
