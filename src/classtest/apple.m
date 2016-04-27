classdef apple < fruit
    properties
        firm; 
    end
    
    methods
        function out = apple(varargin);
            opts = struct('colour', 'red',...
                          'shape', 'round',...
                          'firm', true);
            opts = CheckInputs(opts, varargin{:});
            out@fruit('colour', opts.colour,...
                      'shape', opts.shape);
            out.firm = opts.firm;
        end
        
        function printme(self, next)
            disp(self.firm + next);
        end
    end


end

%classdef fruit
%    properties
%        colour;
%        shape;
%    end
%    methods
%        function out = fruit(varargin)
%            opts = struct('colour', [],...
%                          'shape', []);
%            opts = CheckInputs(opts, varargin{:});
%            out.colour = opts.colour;
 %           out.shape = opts.shape;
 %       end
 %       function printme(obj)
 %           disp(obj.colour);
 %       end
 %   end
    
%end