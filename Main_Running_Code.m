close all
clear
clc

load nodes.txt

temp = size(nodes);
num_model_nodes = temp(1);

model_nodes = NodeClass;

for i=1:num_model_nodes
    model_nodes(i).x = nodes(i,2);
    model_nodes(i).y = nodes(i,3);
    model_nodes(i).z = nodes(i,4);
end

load elements.txt

temp = size(elements);
num_model_elements = temp(1);

model_elements = ElementClass;

element_nodes = NodeClass;

for i=1:num_model_elements
    for j = 1:8
        model_elements(i).node_ids(j) = elements(i,j+1);   %i because it corresponds to ith element, and j+1 because the 2nd column in the element file is the 1st node ID for that element
    end
    element_nodes = model_elements(i).getElementNodes(model_nodes);
    model_elements(i).gauss_points = ElementClass.findGaussPoints(element_nodes);
end

figure
rotate3d;

for i=1:num_model_elements
    element_nodes = model_elements(i).getElementNodes(model_nodes);
    model_elements(i).drawElement(element_nodes);
end


load defect_line.txt
load stress_on_nodes_file.txt

temp = size(defect_line);
%Defect Line file format is Node ID, Nbr ID, node x,y,z and nbr x,y,z.
num_defect_line_points = temp(1);
defect_line_node_id = zeros(temp,1);
defect_line_nbr_id = zeros(temp,1);
defect_line_node = NodeClass;
defect_line_nbr = NodeClass;

for i=1:num_defect_line_points
    defect_line_node_id(i) = defect_line(i,1); 
    defect_line_nbr_id(i) = defect_line(i,2); 
    defect_line_node(i).x = defect_line(i,3);
    defect_line_node(i).y = defect_line(i,4);
    defect_line_node(i).z = defect_line(i,5);
    defect_line_nbr(i).x = defect_line(i,6);
    defect_line_nbr(i).y = defect_line(i,7);
    defect_line_nbr(i).z = defect_line(i,8);
end

%To find the affected elements, find the mid point of the line defect and
%loop over each element to see if it lies within the tolerance. If so,
%fetch that element's gauss points and check if that point lies close to
%the mid point using the distance formula. If so, color it in red while
%keeping the unaffected elements blue.

mid_defect_point = DefectPointClass;

stress_on_nodes = zeros(8,6);

fileID = fopen(file_path,'w'); %Open the file once and close it after writing all the data to the file
for i=1:num_defect_line_points - 1
    mid_defect_point(i).x = (defect_line_node(i).x + defect_line_nbr(i).x)/2;
    mid_defect_point(i).y = (defect_line_node(i).y + defect_line_nbr(i).y)/2;
    mid_defect_point(i).z = (defect_line_node(i).z + defect_line_nbr(i).z)/2;
    
    %The below loop is to check if the element lies close to the defect
    %point.
    for elem=1:num_model_elements
        element_nodes = model_elements(elem).getElementNodes(model_nodes);
        [elem_max,elem_min] = MathClass.findMaxMin(element_nodes);
        
        isInsideBox = MathClass.checkIfInsideBoxWithTolerance(elem_max, elem_min, mid_defect_point(i), mid_defect_point(i), 0.45);
        
        %If isInsideBox, then check which are the closest gauss points to
        %the defect point.
        if isInsideBox == 1            
            for j=1:8
                model_elements(elem).gauss_points(j).state = 0;
                distance = MathClass.findSquareOfDistanceBetween2Points(model_elements(elem).gauss_points(j), mid_defect_point(i));

                if(distance < 0.85) 
                    model_elements(elem).gauss_points(j).state = 1;
                    
                    
                end
            end
        end
        
        %this tells us if the defect point lies inside the
        %element or not. The tolerance is hence kept very very low.
        isInsideElement = MathClass.checkIfInsideBoxWithTolerance(elem_max, elem_min, mid_defect_point(i), mid_defect_point(i), 0.000001);
                    
        if isInsideElement == 1
            node_ids = model_elements(elem).node_ids;
            for node_itr=1:8
                stress_on_nodes(node_itr,1:6) = stress_on_nodes_file(node_ids(node_itr), 2:7);                            
            end
            local_coords = MathClass.FindLocalCoordinatesForPoint(mid_defect_point(i), element_nodes);

            %We should find stress for the defect point only if
            %the point lies exactly inside the element. For
            %corner cases, meaning if the defect point lies
            %exactly on the face or edge, any element can be
            %considered.
            if(abs(local_coords.x) <= 1.00000 && abs(local_coords.y) <= 1.00000 && abs(local_coords.z) <= 1.00000 )
                mid_defect_point(i).FindStressOnDefectPoint(stress_on_nodes, local_coords);
                fprintf(fileID, '%d %d %f %f %f %f %f %f \n', defect_line_node_id(i), defect_line_nbr_id(i), mid_defect_point.S11, ...
                        mid_defect_point.S22, mid_defect_point.S33, mid_defect_point.S23, mid_defect_point.S12, mid_defect_point.S13 );

            end
        end
    end
end

fclose(fileID);

for i=1:num_model_elements
    for j = 1:8
        if model_elements(i).gauss_points(j).state == 0
            model_elements(i).gauss_points(j).drawObject('b');
        else
            model_elements(i).gauss_points(j).drawObject('r');
        end
    end
end

for i=1:num_defect_line_points - 1
    mid_defect_point(i).drawDefectPoint();
end
