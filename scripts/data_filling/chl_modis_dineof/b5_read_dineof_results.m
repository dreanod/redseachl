addpath('/Users/denis/tools/dineof-3.0/Scripts/IO')
load('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_modis/chl_average')

chl_filled = gread('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_modis/chl.filled');
chl_filled = chl_filled + repmat(chl, [1, 1, 575]);
chl_filled = exp(chl_filled);
save('/Users/denis/Dropbox/repos/redseachl/data/filled_data/chl_modis/chl.mat', 'chl_filled');