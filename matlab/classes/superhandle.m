classdef superhandle < handle

    methods
        function value = get(self, property)
            value = self.(property);
        end

        function set(self, property, value)
            self.(property) = value;
        end
    end

end
