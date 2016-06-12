classdef Experiment
    properties
        valid_states;
        current_state;
    end

    methods % (Abstract)
        function UpdateState(obj) end
        function StateMachine(obj) end
        % these next two are not abstract,
        % but the current format doesn't let
        % us deliminate the two
        function output = State(obj)
            output = obj.current_state;
        end
        function output = ValidStates(obj)
            output = obj.valid_states;
        end
    end

    methods (Static)
        function output = Factory(exp_type, tgt)
            switch lower(exp_type)
                case 'timed_response'
                    output = TimedResponse(tgt);
                case 'serial'
                    output = Serial(tgt);
                otherwise
                    error('unknown experiment');
            end
        end
    end

end
