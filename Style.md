## Capitalization
Functions will be CamelCase to match Psychtoolbox.
Variables will be under_scored, with an underscore separating words.

## File Organization
The first part of a "class" (which I will use rather loosely until I
actually understand the implications of this format) will be the 
"constructor" function, which will build a `struct` with both properties
of the object and handles to local functions. For example, something like:

```
% Makes a foo
function output = Foo(in1, in2)
    output.in1 = in1;
    output.in2 = in2;
    output.f.GetIns = @GetIns;
end

% returns all ins
function ins = GetIns(foo_input)
    ins = [foo_input.in1, foo_input.in2];
end
```

This will hopefully do wonders wrt keeping things neat (rather than having 6 files per 
object).