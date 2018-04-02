classdef ElementClass
    %ELEMENTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        node_ids(8,1)
        gauss_points = NodeClass
        state = 0
    end
    
    methods
        function object = ElementClass()
            object.state = 0;
        end
        
        function drawElement(object, element_nodes)
            hold on;
            all_x_coords = zeros(4,6);
            all_y_coords = zeros(4,6);
            all_z_coords = zeros(4,6);
            faces = [[1 4 3 2]' [8 5 6 7]' [5 8 4 1]' [7 6 2 3]' [8 7 3 4]' [6 5 1 2]'];
            
            for i = 1:4
                for j = 1:6
                    all_x_coords(i,j) = element_nodes(faces(i,j)).x;
                    all_y_coords(i,j) = element_nodes(faces(i,j)).y;
                    all_z_coords(i,j) = element_nodes(faces(i,j)).z;
                end
            end

            patch(all_x_coords, all_y_coords, all_z_coords, 'w', 'FaceAlpha', 0.3);
        end
        
        function element_nodes = getElementNodes(object, all_model_nodes)
            element_nodes = NodeClass;
            for i=1:8
                element_nodes(i) = all_model_nodes(object.node_ids(i));
            end
        end
    end
    
    methods(Static)
        function shape_function = calculateShapeFunc(eta, rho, kai)

            shape_function(1) = 0.125 * (1+eta)*(1-rho)*(1-kai) ; 
            shape_function(2) = 0.125 * (1+eta)*(1+rho)*(1-kai) ; 
            shape_function(3) = 0.125 * (1-eta)*(1+rho)*(1-kai) ; 
            shape_function(4) = 0.125 * (1-eta)*(1-rho)*(1-kai) ; 

            shape_function(5) = 0.125 * (1+eta)*(1-rho)*(1+kai) ; 
            shape_function(6) = 0.125 * (1+eta)*(1+rho)*(1+kai) ; 
            shape_function(7) = 0.125 * (1-eta)*(1+rho)*(1+kai) ; 
            shape_function(8) = 0.125 * (1-eta)*(1-rho)*(1+kai) ;
        end
        
        function gauss_points = findGaussPoints(nodes)
            %ELEMENTCLASS Construct an instance of this class
            %   Detailed explanation goes here

            sq3 = 1/sqrt(3);           
            all_x_coords = zeros(8,1);
            all_y_coords = zeros(8,1);
            all_z_coords = zeros(8,1);

            for i=1:8
                all_x_coords(i) = nodes(i).x;
                all_y_coords(i) = nodes(i).y;
                all_z_coords(i) = nodes(i).z;
            end

            eta = [1, 1, -1, -1, 1, 1, -1, -1] * sq3;
            rho = [-1, 1, 1, -1, -1, 1, 1, -1] * sq3;
            kai = [-1, -1, -1, -1, 1, 1, 1, 1] * sq3;

            gauss_points = NodeClass;
            for i=1:8
                shape_func = ElementClass.calculateShapeFunc(eta(i), rho(i), kai(i));
                gauss_points(i).x = shape_func * all_x_coords;
                gauss_points(i).y = shape_func * all_y_coords;
                gauss_points(i).z = shape_func * all_z_coords;
            end
        end
    end
end



