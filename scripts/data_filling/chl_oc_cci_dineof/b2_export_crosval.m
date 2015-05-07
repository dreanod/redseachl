addpath('/Users/denis/tools/dineof-3.0/Scripts/IO')
addpath('/Users/denis/tools/dineof-3.0/Scripts')

load /Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/mask.mat
load /Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/chl.mat

mkdir('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof')

gwrite('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof/mask.dat', ~mask)
gwrite('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof/chl.dat', chl)

dineof_cvp('/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof/chl.dat', '/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof/mask.dat','/Users/denis/Dropbox/repos/redseachl/derived/data_filling/chl_oc_cci/dineof/' , 150)
