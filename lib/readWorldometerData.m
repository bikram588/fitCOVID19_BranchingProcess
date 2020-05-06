function [dates_extended, newcases_extended, totalcases_extended] = readWorldometerData(CountryName)
data_cell = textscan(webread(strcat('https://www.worldometers.info/coronavirus/country/', lower(CountryName), '/')), '%s', 'delimiter', newline);
data_raw = data_cell{1};

%% read total cases
first_found=[];
for i_line=1:length(data_raw)
    if ~isempty(strfind(data_raw{i_line}, 'name: ''Cases'''))
        first_found=i_line;
        break;
    end
end
data_ind=first_found;
for i_line=first_found+1:length(data_raw)
    if ~isempty(strfind(data_raw{i_line}, 'data: '))
        data_ind=i_line;
        break;
    end
end
data_line = data_raw{data_ind};
data_line = strrep(data_line, 'null', '0');
totalcases_extended = cell2mat(textscan(data_line(strfind(data_line, '[')+1:strfind(data_line, ']')-1), '%f', 'Delimiter', ','));

%% read new cases
first_found=[];
for i_line=1:length(data_raw)
    if ~isempty(strfind(data_raw{i_line}, 'name: ''Daily Cases'''))
        first_found=i_line;
        break;
    end
end
data_ind=first_found;
for i_line=first_found+1:length(data_raw)
    if ~isempty(strfind(data_raw{i_line}, 'data: '))
        data_ind=i_line;
        break;
    end
end
data_line = data_raw{data_ind};
data_line = strrep(data_line, 'null', '0');
newcases_extended = cell2mat(textscan(data_line(strfind(data_line, '[')+1:strfind(data_line, ']')-1), '%f', 'Delimiter', ','));

% %% read new recoveries
% 
% first_found=[];
% for i_line=1:length(data_raw)
%     if ~isempty(strfind(data_raw{i_line}, 'name: ''New Recoveries'''))
%         first_found=i_line;
%         break;
%     end
% end
% data_ind=first_found;
% for i_line=first_found+1:length(data_raw)
%     if ~isempty(strfind(data_raw{i_line}, 'data: '))
%         data_ind=i_line;
%         break;
%     end
% end
% data_line = data_raw{data_ind};
% data_line = strrep(data_line, 'null', '0');
% newrecoveries = cell2mat(textscan(data_line(strfind(data_line, '[')+1:strfind(data_line, ']')-1), '%f', 'Delimiter', ','));

%% read dates
first_found=[];
for i_line=1:length(data_raw)
    if ~isempty(strfind(data_raw{i_line}, 'categories: '))
        first_found=i_line;
        break;
    end
end
data_line = data_raw{first_found};
 
dates_raw = textscan(data_line(strfind(data_line, '[')+1:strfind(data_line, ']')-1), '%s', 'Delimiter', ',');
dates_extended = datenum(strcat(strrep(dates_raw{1}, '"', ''), ' 2020'), 'mmm dd yyyy');

ep_start = find(newcases_extended>0, 1, 'first');
dates_extended=dates_extended(ep_start:end);
newcases_extended=newcases_extended(ep_start:end);
totalcases_extended=totalcases_extended(ep_start:end);
end