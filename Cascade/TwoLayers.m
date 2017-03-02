classdef TwoLayers < AbstractCascade
    %TWOLAYERS Cascade of two neural nets
    %   Detailed explanation goes here
    
    properties
        first_layer_obj;
        threshold;
        
        % Second layer net
        trained_net;
        level;    
    end
    
    methods    
         function obj = TwoLayers(net1,level1,net2,level2,threshold)         
           obj.first_layer_obj=OneLayer(net1,level1);
           obj.trained_net = net2;
           obj.level = level2;
           obj.threshold=threshold;
           
        end

      function [loc_probs] = evaluate(obj,slide,centers_x,centers_y,sample_size)
       
         pobs_first_layer= obj.first_layer_obj.evaluate(slide,centers_x,centers_y,sample_size);
        
         [idx]=find(pobs_first_layer > obj.threshold);
         
         x_second_layer=centers_x(idx);
         y_second_layer=centers_y(idx);
         
         [tx,ty]=interpolateCoordinatesByLevel( x_second_layer,y_second_layer, obj.first_layer_obj.level,obj.level );
         
          ws_img_size = slide.PixelSize(obj.level,:);
          height=ws_img_size(2);
          width=ws_img_size(1);
          loaded_image = slide.getImagePixelData(0, 0, width, height,'level',obj.level-1);
          pobs_sec_layer = CNN.EvaluateImageInBatch(obj.trained_net,slide,loaded_image,'test',obj.level,tx,ty,sample_size );
    
         loc_probs=zeros(size(centers_x,1),1);
         loc_probs(idx)=pobs_sec_layer;
      end
       
    end
   
    
end
