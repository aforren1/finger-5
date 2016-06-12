function output = IsOctave;
    output = logical(exist('OCTAVE_VERSION', 'builtin'));
end
