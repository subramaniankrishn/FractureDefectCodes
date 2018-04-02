classdef MathClass
    %MATHCLASS Summary of this class goes here
    %   Detailed explanation goes here
        
    methods(Static)
        function [max,min] = findMaxMin(points)
            max = NodeClass;
            min = NodeClass;
            
            max.x = -1e9;
            max.y = -1e9;
            max.z = -1e9;
            min.x =  1e9;
            min.y =  1e9;
            min.z =  1e9;
            
            for i=1:8
                if(points(i).x > max.x)
                    max.x = points(i).x;
                end
                if(points(i).y > max.y)
                    max.y = points(i).y;
                end
                if(points(i).z > max.z)
                    max.z = points(i).z;
                end
                
                if(points(i).x < min.x)
                    min.x = points(i).x;
                end
                if(points(i).y < min.y)
                    min.y = points(i).y;
                end
                if(points(i).z < min.z)
                    min.z = points(i).z;
                end
            end
        end
        
        
        function inside_box = checkIfInsideBoxWithTolerance(max1,min1,max2,min2,tolerance)
            line1_vector.x = max1.x - min1.x;
            line1_vector.y = max1.y - min1.y;
            line1_vector.z = max1.z - min1.z;
            
            %The idea is to make this box bigger by respecting the
            %tolerance (given as a percentage)
            
            new_max1.x = max1.x + line1_vector.x * tolerance;
            new_max1.y = max1.y + line1_vector.y * tolerance;
            new_max1.z = max1.z + line1_vector.z * tolerance;
            
            new_min1.x = min1.x - line1_vector.x * tolerance;
            new_min1.y = min1.y - line1_vector.y * tolerance;
            new_min1.z = min1.z - line1_vector.z * tolerance;

            line2_vector.x = max2.x - min2.x;
            line2_vector.y = max2.y - min2.y;
            line2_vector.z = max2.z - min2.z;
            
            new_max2.x = max2.x + line2_vector.x * tolerance;
            new_max2.y = max2.y + line2_vector.y * tolerance;
            new_max2.z = max2.z + line2_vector.z * tolerance;
            
            new_min2.x = min2.x - line2_vector.x * tolerance;
            new_min2.y = min2.y - line2_vector.y * tolerance;
            new_min2.z = min2.z - line2_vector.z * tolerance;
            
            inside_box = 0;
            if (new_max1.x > new_min2.x && new_max1.y > new_min2.y && new_max1.z > new_min2.z && ...
                new_max2.x > new_min1.x && new_max2.y > new_min1.y && new_max2.z > new_min1.z )
                inside_box = 1;
            end
            
        end
        
        function distance = findSquareOfDistanceBetween2Points(point1, point2)
            distance = ( point1.x - point2.x ) ^ 2 +  ( point1.y - point2.y ) ^ 2 + ( point1.z - point2.z ) ^ 2 ;
        end
        
        function distance = findDistanceBetween2Points(point1, point2)
            distance = sqrt(findSquareOfDistanceBetween2Points(point1, point2));
        end
        
    end
end

