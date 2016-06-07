classdef Experiment
    properties
        valid_states;
        current_state;
    end

    methods % (Abstract)
        function LoadResources(obj) end
        function UpdateState(obj) end
        function StateMachine(obj) end
        function UpdateDisplay(obj) end
        function UpdateInput(obj) end
        function output = State(obj)
            output = obj.current_state;
        end
        function output = ValidStates(obj)
            output = obj.valid_states;
        end
    end

    methods (Static)
        function output = Factory(exp_type)
            switch lower(exp_type)
                case 'timed_response'
                    output = TimedResponse;
                case 'serial'
                    output = Serial;
                otherwise
                    error('unknown experiment');
            end
        end

    end

end
