Minikick
--------

Uses Bundler for dependencies; install using `bundle install`. Add `--binstubs`
to use `bin/rspec` as a test shortcut.

`./minikick.rb` accepts *project*, *back*, *list*, and *backer* commands. Run
without input to see each one's options.

### Other Thoughts ###

An interesting project. I wanted to approach it with as little use of frameworks
as I could manage, so that I really had to get down and handle the decisions
about how to structure things myself. Also, no dependencies outside of the 
Luhn-10 library, and that would be pretty easy to actually rewrite -- that 
checksum is pretty straight-forward.

I started off with one mega-class as I explored the problem: everything was 
included in the `Project` class. [It was a bit of a mess](https://github.com/deltamualpha/minikick/commit/42e0c0b13b125a19791b377cef04e8d54cb3c759) 
-- way too all-over-the-place, far too much unrelated behavior... but it
helped map out the relationships between projects and backers for me.

[Splitting out the Backer class helped](https://github.com/deltamualpha/minikick/commit/d5f3d24630aafb9c8bf2ca1d8d2ecd648e7c2bd9), but Project was still responsible for 
saving out the state of classes to the filesystem -- which, multiple json files
based on the number of projects? **Why?** Among other problems, it made 
searching for the projects a backer had pledged to really complicated.

[Abstracting the fs part into its own class](https://github.com/deltamualpha/minikick/commit/ba366825a2b4924ac7e55fe1473827582daefdd1) helped some more, but now we had a 
dependecy on loading from the filesystem to be able to write tests for 
`validate_card` -- unless I wanted to try and stub out most of the `Database`
class.

In the end, I decided to use class variables for storing lists of all active
projects and backers on their respective classes for ease of reference and 
access. I looked for documentation on whether this is generally considered a 
good pattern or not; [O'Reilly](http://archive.oreilly.com/pub/a/ruby/excerpts/ruby-best-practices/worst-practices.html) seems to advocate against them, but mostly because of their odd behavior 
with inheritance. In this case, the surface area is pretty minimal, and the 
other obvious choice, adding some sort of broad getter/setter to the Database 
class (as a quasi-global) just feels even messier. Plus, that was how I was 
using `Database.instance.projects` and that just got ugly fast with 
weirdly-coupled methods and global state...

The `Interface` class is... not amazing, for sure, but it works. Having 
`minikick.rb` dynamically call into the class instead of using a case statement
would be more clever, but also less obvious and more prone to possible abuse.
(is `./minikick.rb new` a security hole? Are you *sure*?)

I feel like this isn't wildly idiomatic ruby overall. Rubists tend to favor
many terse methods over handling logic inline. For example, in 
`Utilities::validate_card`, we have `!Luhn.valid?(card_number) || card_number.to_s.length > 19`.
Another ruby dev may have split that into two other utility methods, named
`Utilities::Luhn_valid?` and `Utilities::card_too_long?`, each one a single
line long, and then called them from within the more general validation method.
I'm just not in the habit of doing that -- doesn't mean it's a bad impulse.
(The cynic in me says it's an easy way to build a very large unit test suite.)
If this were another codebase (especially one with broader contributors) I
would probably pay much closer attention to those conventions.

Speaking of tests:

* rspec remains excellent.
* Code Climate's CLI tool made throwing Rubocop at the code easy.
* simplecov generated a nice report, although it doesn't think `interface.rb` 
  seems to matter. Presumably because there are no tests that load it at all
  when rspec runs? 😐
