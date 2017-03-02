classdef OneLayer < AbstractCascade
    properties
        trained_net;
        level;
    end
    
    methods
        function obj = OneLayer(net,level)
           obj.trained_net = net;
           obj.level=level;     
        end
        
        
        function [loc_probs] = evaluate(obj,slide,centers_x,centers_y,sample_size) 
           ws_img_size = slide.PixelSize(obj.level,:);
           height=ws_img_size(2);
           width=ws_img_size(1);
           loaded_image = slide.getImagePixelData(0, 0, width, height,'level',obj.level-1);
           loc_probs = CNN.EvaluateImageInBatch(obj.trained_net,slide,loaded_image,'test',obj.level,centers_x,centers_y,sample_size );      
         
        end
      

    end
    
end

