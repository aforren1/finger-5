classdef TimedResponse < Experiment

    methods
        function output = TimedResponse;
            output@Experiment;
            output.valid_states = {'setup',...
                                   'idle',...
                                   'intrial',...
                                   'posttrial',...
                                   'endblock'};
            output.current_state = 'idle';
        end

        % load resources for this particular experiment
        function LoadResources(obj)

        end

        % delegate
        function StateMachine(obj)
            switch State(obj.current_state)
                case 'idle'

                case 'intrial'

                case 'posttrial'

                case 'endblock'

            end

        end

        % figure out new state (need?)
        function UpdateState(obj)

        end


        function UpdateInput(obj, using_serial)

        end

        function UpdateDisplay(obj, display_flag)

        end

        function UpdateSound(obj)

        end

    end % end methods
end % end timed response
