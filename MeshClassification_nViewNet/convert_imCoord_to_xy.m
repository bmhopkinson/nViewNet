infile = './0623/0623_20171013_faceVisSparse.mat';
outfile = './0623/0623_20171013_faceVisSparse_Alt.mat';

load(infile);
imCoord_x = imCoord(:,1:2:(end-1));
imCoord_y = imCoord(:,2:2:end);

save(outfile,'Fcenters','imCoord_x','imCoord_y','visibleFC');