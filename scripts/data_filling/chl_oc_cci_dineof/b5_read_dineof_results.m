addpath('/Users/denis/tools/dineof-3.0/Scripts/IO')
load('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_average')

chl_filled = gread('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl.filled');
save('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_filled.mat', 'chl_filled');