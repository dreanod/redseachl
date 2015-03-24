addpath('/Users/denis/tools/dineof-3.0/Scripts/IO')

chl_filled = gread('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl.filled');

save('/Users/denis/Dropbox/repos/redseachl/data/filled_data/chl.mat', 'chl_filled');