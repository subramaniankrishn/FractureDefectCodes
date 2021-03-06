classdef DefectPointClass < NodeClass
    %NODECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        oldx
        oldy
        oldz
        numNbrs
        nbrTag
        burgX
        burgY
        burgZ
        nx
        ny
        nz
        S11
        S22
        S33
        S23
        S12
        S13
        state_each_set        
    end
    
    methods
        function object = DefectPointClass()
            object.oldx = 0;
            object.oldy = 0;
            object.oldz = 0;
            object.S11 = 0;
            object.S22 = 0;
            object.S33 = 0;
            object.S23 = 0;
            object.S12 = 0;
            object.S13 = 0;
            object.numNbrs = 0;
            object.state_each_set = 0;
        end
        
        function FindStressOnDefectPoint(object, stress_on_nodes, local_coord)
            eta_arr = [1, 1, -1, -1, 1, 1, -1, -1] ;
            rho_arr = [-1, 1, 1, -1, -1, 1, 1, -1] ;
            kai_arr = [-1, -1, -1, -1, 1, 1, 1, 1] ;

            for i=1:8
                object.S11 = object.S11 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,1);
                object.S22 = object.S22 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,2);
                object.S33 = object.S33 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,3);
                object.S23 = object.S23 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,4);
                object.S12 = object.S12 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,5);
                object.S13 = object.S13 + 0.125*(1+local_coord.x*eta_arr(i))*(1+local_coord.y*rho_arr(i))*(1+local_coord.z*kai_arr(i))*stress_on_nodes(i,6);
            end
        end
        
        
        function drawDefectPoint(object)
            scatter3(object.x, object.y, object.z, 'filled', 'MarkerEdgeColor','k', 'MarkerFaceColor',[0 .75 .75]);
        end
    end
    
    methods(Static)
        
    end
end

