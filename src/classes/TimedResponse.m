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
        function [consts, ui, audio, screen, tgt, out_data,...
                 press_feedback, images, feedback_image,...
                 resp_device] = LoadResources(obj)

        end

        % delegate
        function StateMachine(obj)
            switch State(obj.current_state)
                case 'idle' % between/before trials

                case 'intrial' % during trial

                case 'posttrial' % after trial cleanup

                case 'endblock' % after block cleanup

            end

        end

        % figure out new state (need?)
        function UpdateState(obj)

        end

        % check inputs and serial port?
        function UpdateInput(obj, using_serial)

        end

        % draw all screen-related things
        function UpdateDisplay(obj, display_flag)

        end

        % play sound (if necessary)
        function UpdateSound(obj)

        end

    end % end methods
end % end timed response
