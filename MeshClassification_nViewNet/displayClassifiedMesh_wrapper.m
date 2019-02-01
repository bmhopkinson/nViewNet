addpath('/home/cv-bhlab/Documents/MATLAB/Library'); %for stlwrite() function used to export final stl file for viewing
addpath(genpath('/home/cv-bhlab/Documents/MATLAB/Library/geom3d'));  %% matalb geom3d package by David Legland - load off 
addpath(genpath('/home/cv-bhlab/Documents/MATLAB/Library/pdollar_toolbox'));      %pdollar toolbox - various supporting functions - here imLabel

%baseDir = './0441_simple/';
%meshFile = strcat(baseDir,'0441_simple_2_model.off');
%classifiedFile = strcat(baseDir,'0441_simple_2_nViewNet_predictions_alt2_20181106_B.txt');
%classifiedFile ='0441_simple_ids_preds.txt';

baseDir = './ML_215_v3/';
meshFile = strcat(baseDir,'215_ML_v3_mesh_metricRot.off');
classifiedFile = strcat(baseDir,'ML_215_v3_predictions_v3_20181211.txt');

[V, F] = readMesh_off(meshFile);

fin = fopen(classifiedFile);

C = textscan(fin, '%d\t%d\n');
meshIdx = C{1};
meshIdx = meshIdx + 1;  %zero based indexing in python, one based in Matlab. 
classID = C{2};
classID = classID + 1;  %zero based indexing in python, one based in Matlab. 
Pclass = zeros(size(F,1),1);
Pclass(meshIdx) = classID;





displayClassifiedMesh(V, F, Pclass); 