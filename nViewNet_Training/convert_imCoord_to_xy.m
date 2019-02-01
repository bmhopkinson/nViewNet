infile = './mesh_data/ML_215/215_ML_v3_faceVisSparse.mat';
outfile = './mesh_data/ML_215/215_ML_v3_faceVisSparse_Alt.mat';

load(infile);
imCoord_x = imCoord(:,1:2:(end-1));
imCoord_y = imCoord(:,2:2:end);

save(outfile,'Fcenters','imCoord_x','imCoord_y','visibleFC');