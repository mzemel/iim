OPTIMIZATION

1. Explain your improvement process, and why you chose each step.

  Well, the first step was understanding the code that was written.  Variables
  named `q` and `ys` (which I still have no idea what it stands for) seemed to
  hold arbitrary values and go through convolution modifications.

  For example, on line 8:

  `ys = data.sort[q.ceil-1..(3*q).floor]`

  Why would you make a sub-selection using the ceiling of the lower bound but
  the floor of the upper bound?  And why is it `3*q`?  This is in addition to
  the strange `factor` variable (which is a modifier you apply to the upper and
    lower bounds of the IQR), which seemed excessively complicated.

  After reading the Wikipedia article on Interquartile Mean
  (http://en.wikipedia.org/wiki/Interquartile_mean), I began to grasp that `ys`
  is the IQR, which is gathered using an overly complicated means of truncating
  the floored size of each quartile (e.g. for 9 entries, each quartile is 2.25 -
  hence, drop the lowest two and highest two).

  The variable `factor` then, I deduced was the "partial observation"
  multiplier, as it was being applied to the lower and upper bounds.

  Long story short, the biggest task that needed refactoring was the naming
  conventions, just so I could understand what was going on in the code.

  After that, I looked for improvements:

  * `inject(0, :+)` was redundant, it could just be `inject(:+)`,
  * creating the IQR could just be `data.sort[q.floor..-q.floor]`,
  * breaking up the complicated assignment of `mean`,
  * etc.

  Last, I decided to make the program object-oriented because it's more
  readable, a better separation of concerns, and uses only a minuscule amount of
  extra overhead.  On top of that, I decided to gemify it because I could use
  the practice.

    * First, I created a data structure, which is pretty much just a fancy array.
    * The structure should contain the logic for calculating things like IQR,
      IQM, etc. because it holds the data.
    * I added a control class (MeanGenerator) which would handle opening the
      file and putting the items into the data structure.
    * Last, I wrote the main part of the module which would create the
      MeanGenerator using the given file to kick the process off.

  I ran both versions (old and new) and found that one took 10'22.27" whereas
  the other took 10'22.65" - a negligible difference.

  Finally, I added specs.  Probably should have started with specs, but given
  that the only interaction you had with the original code was output, I
  couldn't exactly hook into that.  By making the code object-oriented, I gave
  myself objects to work with so I could stop and verify that the interquartile
  range of the data_set object was really what I expected it to be.

2. What improvements did you make to ensure that future developers could quickly and easily understand this code?

  Well, my philosophy with comments is that your code should be like a circuit
  breaker.  If there were comments above everything, nobody would read them all.
  You're supposed to make the code explain itself, and where that wasn't
  possible (such as explaining what the variable that replaces `factor` stood
  for), I added a brief comment and linked to a page with more info.

  Between sane variable/method names, declaration of methods in a logical order,
  lines under 80 columns, and single-purpose methods, I think that someone could
  look at my code and understand what it does, even if they have never worked
  with interquartile means before.

  Also, tests.  If they want to improve upon the code, they have a test file
  that they can run to make sure nothing breaks.

  To run tests, just do `rspec` in the main directory.
