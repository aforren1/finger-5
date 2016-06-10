classdef TimedResponse < Experiment
    properties
        screen;
        audio;
        images;
        x_image;
    end

    methods
        % too strong of a constructor?
        function o = TimedResponse(tgt)
            o@Experiment;
            o.valid_states = {'idle',...
                                   'intrial',...
                                   'posttrial',...
                                   'endblock'};
            o.current_state = 'idle';
            consts = Constants();
            o.screen = PsychScreen('reversed', consts.reversed,...
                                        'big_screen', consts.big_screen, ...
                                        'skip_tests', consts.skip_tests);
            o.audio = PsychAudio(2);
            FillAudio(o.audio, ['misc/sounds/', 'beepTrainFast.wav'], 1);
            FillAudio(o.audio, ['misc/sounds/', 'smw_coin.wav'], 2);
            subdir = ifelse(tgt.image_type(1), 'shapes/', 'hands/');
            img_dir = ['misc/images/', subdir];
            img_names = dir([img_dir, '/*.jpg']);

            o.x_image = ImageFeedback(o.screen.window, o.screen.dims(1));
        end

        % delegate
        function out_data = StateMachine(o, tgt, out_data)
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
