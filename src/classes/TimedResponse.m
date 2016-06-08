classdef TimedResponse < Experiment
    properties
        screen;
    end

    methods
        % too strong of a constructor?
        function output = TimedResponse
            output@Experiment;
            output.valid_states = {'idle',...
                                   'intrial',...
                                   'posttrial',...
                                   'endblock'};
            output.current_state = 'idle';
            consts = Constants();
            output.screen = PsychScreen('reversed', consts.reversed,...
                                        'big_screen', consts.big_screen, ...
                                        'skip_tests', consts.skip_tests);
            output.audio = PsychAudio(2);
            FillAudio(output.audio, ['misc/sounds/', 'beepTrainFast.wav'], 1);
            FillAudio(output.audio, ['misc/sounds/', 'smw_coin.wav'], 2);

        end

        function out_tgt = LoadTgt(obj, tgt_path)

        end

        % delegate
        function StateMachine(o, consts, ui, screen, tgt, out_data, extra)
            switch State(o.current_state)
                case 'idle' % between/before trials

                case 'intrial' % during trial

                case 'posttrial' % after trial cleanup

                if trialnum >= max(tgt.trialnum) % check syntax!!
                    o.current_state = 'endblock';

                end
                case 'endblock' % after block cleanup
                otherwise
                    error('Unknown state');
            end
        end
    end % end methods
end % end timed response
