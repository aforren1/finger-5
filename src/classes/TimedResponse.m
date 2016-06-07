classdef TimedResponse < Experiment

    methods
        function output = TimedResponse
            output@Experiment;
            output.valid_states = {'idle',...
                                   'intrial',...
                                   'posttrial',...
                                   'endblock'};
            output.current_state = 'idle';
        end

        % load resources for this particular experiment
        % ones not contained in extra can change experiment by experiment
        function [consts, ui, screen, tgt, out_data, extra] = LoadResources(obj)
        % extra in this experiment: audio, images, press_feedback, feedback_image


        end

        % delegate
        function StateMachine(obj, consts, ui, screen, tgt, out_data, extra)
            switch State(obj.current_state)
                case 'idle' % between/before trials

                case 'intrial' % during trial

                case 'posttrial' % after trial cleanup

                if trialnum >= max(tgt.trialnum) % check syntax!!
                    obj.current_state = 'endblock';

                end
                case 'endblock' % after block cleanup
                otherwise
                    error('Unknown state');
            end
        end

        % check inputs and serial port?
        % called regardless of the state
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
