classdef Experiment
    properties
        valid_states;
        current_state;
    end

    methods % (Abstract)
        function StateMachine(obj) end
        function MakeConstants(obj) end
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
                case 'tr'
                    output = TimedResponse(tgt);
                case 'rt'
                    output = ReactionTime(tgt);
                otherwise
                    error('unknown experiment');
            end
        end
    end

end
