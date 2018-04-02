close all
clear all
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
temp = size(defect_line);

num_defect_line_points = temp(1);

defect_line_points = NodeClass;

for i=1:num_defect_line_points
    defect_line_points(i).x = defect_line(i,1);
    defect_line_points(i).y = defect_line(i,2);
    defect_line_points(i).z = defect_line(i,3);
end

%To find the affected elements, find the mid point of the line defect and
%loop over each element to see if it lies within the tolerance. If so,
%fetch that element's gauss points and check if that point lies close to
%the mid point using the distance formula. If so, color it in red while
%keeping the unaffected elements blue.

mid_defect_point = NodeClass;

for i=1:num_defect_line_points - 1
    mid_defect_point.x = (defect_line_points(i).x + defect_line_points(i+1).x)/2;
    mid_defect_point.y = (defect_line_points(i).y + defect_line_points(i+1).y)/2;
    mid_defect_point.z = (defect_line_points(i).z + defect_line_points(i+1).z)/2;
    
    for elem=1:num_model_elements
        element_nodes = model_elements(elem).getElementNodes(model_nodes);
        [elem_max,elem_min] = MathClass.findMaxMin(element_nodes);
        
        isInsideBox = MathClass.checkIfInsideBoxWithTolerance(elem_max, elem_min, mid_defect_point, mid_defect_point, 0.45);
        
        if isInsideBox == 1            
            for j=1:8
                model_elements(elem).gauss_points(j).state = 0;
                distance = MathClass.findSquareOfDistanceBetween2Points(model_elements(elem).gauss_points(j), mid_defect_point);

                if(distance < 0.85)
                    model_elements(elem).gauss_points(j).state = 1;
                end
            end
        end
    end
end

for i=1:num_model_elements
    for j = 1:8
        if model_elements(i).gauss_points(j).state == 0
            model_elements(i).gauss_points(j).drawObject('b');
        else
            model_elements(i).gauss_points(j).drawObject('r');
        end
    end
end

