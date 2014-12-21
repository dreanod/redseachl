
fid = fopen('../../../data/rain/raw/3B42_daily.1998.01.01.7.bin', 'r');
a = fread(fid, 'float','b');
fclose(fid);
 
data = a';

rain = nan(400, 1440);
 
count = 1;
for i_lat = 1:400 
    for j_lon = 1:1440 
        lat = -49.875 + 0.25*(i_lat - 1);
        if j_lon <= 720
            lon = 0.125 + 0.25*(j_lon - 1);
        else
            lon = 0.125 + 0.25*(j_lon - 1) - 360.0;
        end
        daily_rain_total = data(count);
        count = count + 1;
        
        rain(i_lat, j_lon) = daily_rain_total;
    end
end

