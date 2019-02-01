function displayClassifiedMesh(V, F, Pclass)
%display results of mesh classification algorithm

Classes = {'Unclass','Apalm','Acerv','Orb', 'Ssid','Past','Gorg','Antill','Sea_Rods','Algae','Rubble','Sand'};
Classes_mod = {'NotVis','Apalm','Orb', 'Ssid','Past','Gorg','Antill','SeaRods','Algae','Rubble','Sand'};
Classes_mod = {'NotVis','Apalm','Orb', 'Ssid','Past','Gorg','Antill','SeaRods','Algae','Rubble','Sand','Unclass','Other','Pink_algae'};
%Classes = {'Unclass','Algae', 'Antill', 'Apalm','Gorg','Orb','Past','Sea_Rods', 'Rubble','Sand','Ssid' };
ClassColorsList = uint8([  0,   0,   0;...  % 0 unclassified -  black
                         127,  51,   0;...  % 1 Apalm - brown    
                         160,  70,   0;...  % 2 Acerv - light brown  
                         100, 255, 25;...   % 3 Orbicella - medium green  
                         255, 255, 0 ;...   % 4 Siderastrea siderea-   yellow                         
                         201, 249, 138;...  % 5 Porites astreoides - lime green 
                         180,   0, 200;...  % 6 Gorgonian - purple  
                         255,   0,   0;...  % 7 Antillogorgia - red                         
                         255, 170, 238;...  % 8 Sea Rods- pink
                         50, 150, 50;...    % 9 algae -  green                         
                         90, 200, 255;...   % 10 rubble - medium blue                         
                         0, 255, 255]);     % 11 sand - light blue               
ClassColorsList = uint8([  0,   0,   0;...  % 0 unclassified -  black
                         127,  51,   0;...  % 1 Apalm - brown    
                         160,  70,   0;...  % 2 Acerv - light brown  
                         100, 255, 25;...   % 3 Orbicella - medium green  
                         255, 255, 0 ;...   % 4 Siderastrea siderea-   yellow                         
                         201, 249, 138;...  % 5 Porites astreoides - lime green 
                         180,   0, 200;...  % 6 Gorgonian - purple  
                         255,   0,   0;...  % 7 Antillogorgia - red                         
                         255, 170, 238;...  % 8 Sea Rods- pink
                         50, 150, 50;...    % 9 algae -  green                         
                         90, 200, 255;...   % 10 rubble - medium blue                         
                         0, 255 , 255;...   % 11 sand - light blue 
                         100,100, 100;...   % 12 unclassified - dark grey
                         200,200, 200;...   % 13 other - light grey
                         50, 150, 50;...  % 14 pink algae- for now same green as "algae"                  
                         ]);                                 
                     

ClassColorsList_mod = [ClassColorsList(1:2,:); ClassColorsList(4:end,:)]; % remove Acerv from plotting b/c it never shows up                
                     
nClasses = size(ClassColorsList_mod,1);
nFaces = size(F, 1);

ClassColors = zeros(nFaces, 3);
PclassInc = Pclass + 1;
for i = 1:nFaces
    ClassColors(i,:) = ClassColorsList(PclassInc(i), :);
end

ClassColors = uint8(ClassColors);


nFaces = size(F,1);
Fcenters = zeros(nFaces, 3);
for i = 1:nFaces
    pt1 = V(F(i,1),:); pt2 = V(F(i,2),:); pt3 = V(F(i,3),:);
    Fcenters(i,:) = (pt1+pt2+pt3)/3; %centroid of triangle
end


figure
pcshow(Fcenters,ClassColors,'MarkerSize',20);
view([0,90]); %view point: azimuth, elevation

figure
ClassColorsPlot = reshape(ClassColorsList_mod, nClasses, 1, 3);
imagesc(ClassColorsPlot);
set(gca,'XTick',[]); set(gca,'YTick',[]);
imLabel(Classes_mod,'left');


%plot with trisurf
figure
MyColorMap = double(ClassColorsList)./255;
colormap(MyColorMap);
trisurf(F, V(:,1), V(:,2), V(:,3), PclassInc);
axis image;
shading flat;
view([0,90]);


%export as stl file - can work with it in meshlab on MAC (colors do not show up on Linux MeshLab - as of 2017/11/6).

ClassColors_STL = (ClassColors).*(31/255);     %5 bit color for stl file
stlFileName =  'classifiedMesh.stl';
stlwrite(stlFileName,F, V,'FACECOLOR',ClassColors_STL);


end

