clear
fs = 50;
fc = 5;
[br2,ar2] = butter(2,fc/(fs/2));
fc = 3;
[bp2,ap2] = butter(2,fc/(fs/2));
fc = 2;
[by2,ay2] = butter(2,fc/(fs/2));

save('MatFiles/FilterCoef.mat','br2', 'ar2', 'bp2', 'ap2', 'by2', 'ay2')