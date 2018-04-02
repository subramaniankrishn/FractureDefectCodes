classdef NodeClass
    %NODECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        z
        state 
    end
    
    methods
        function object = NodeClass()
            object.x = 0;
            object.y = 0;
            object.z = 0;
            object.state = 0;
        end
        
        function drawObject(object, color)
            hold on;
            plot3(object.x, object.y, object.z,'*', 'color', color);
        end
    end
end

