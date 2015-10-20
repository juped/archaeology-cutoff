# Hoon 3: our first program

It's time for us to do some actual programming.  In this section,
we'll work through that classic Urbit pons asinorum, decrement.

If you learned Nock before Hoon, you've already done decrement.
If not, all you need to know is that the only arithmetic
intrinsic in Nock is increment -- in Hoon, the unary `.+` rune.
So an actual decrement function is required.

In chapter 3, we write a decrement builder: more or less the
simplest nontrivial Urbit program.  We should be able to run this
example:
```
~tasfyn-partyv:dojo/sandbox> +test 42
41
```

## What's in that subject?

As we've seen, Hoon works by running a twig against a subject.
We've been cheerfully running twigs through three chapters while
avoiding the question: what's in the subject?  To avoid the issue
we've built a lot of constants, etc.

Of course your twig's subject comes from whoever runs it.  There
is no one true subject.  Our twigs on the command line are not
run against the same subject as our generator code, even though
they are both run by the same `:dojo` appliance.

But the short answer is that both command-line and builder get
*basically* the same subject: some ginormous noun containing all
kinds of bells and whistles and slicers and dicers, including a
kernel library which can needless to say decrement in its sleep.

As yet you have only faced human-sized nouns.  We need not yet
acquaint you with this mighty Yggdrasil, Mother of Trees.  First
we need to figure out what she could even be made of.

## Clearing the subject

We'll start by clearing the subject:
```
:-  %say  |=  *  :-  %noun
=>  ~
[%hello %world]
```
The `=>` rune ("tisran"), for `=>(p q)` executes `p` against 
the subject, then uses that product as the subject of `q`.

(We've already used an irregular form of `=>`, or to be more
precise its mirror `=<` ("tislit").  In chapter 1, when we wrote
`+3:test`, we meant `=>(test +3)` or `=<(+3 test)`.)

What is this `~`?  It's Hoon `nil`, a zero atom with this span:
```
~tasfyn-partyv:dojo/sandbox> ?? ~
  [%cube 0 %atom %n]
~
```
We use it for list terminators and the like.  Obviously, since
our old test code is just a constant, a null subject works fine:
```
~tasfyn-partyv:dojo/sandbox> +test
[%hello %world]
```

## Getting an argument

Obviously, if we want to write a decrement builder, we'll have to
get an argument from the command line.  This involves changing
the `test.hoon` boilerplate a little:
```
:-  %say  |=  [* [[arg=@ud ~] ~]]  :-  %noun
=>  arg=arg
[%hello arg]

~tasfyn-partyv:dojo/sandbox> +test 42
[%hello 42]
```
`=>  arg=arg` looks a little odd.  We wouldn't ordinarily do
this.  We're just replacing a very interesting subject that
contains `arg` with a very boring one that contains only `arg`, 
for the same reason we cleared the subject with `~`.

In case there's any doubt about the subject (`.` is limb syntax
for `+1`, ie, the whole noun):
```
:-  %say  |=  [* [[arg=@ud ~] ~]]  :-  %noun
=>  arg=arg
.

~tasfyn-partyv:dojo/sandbox> +test 42
arg=42
```

We can even write a trivial increment function using `.+`: 
```
:-  %say  |=  [* [[arg=@ud ~] ~]]  :-  %noun
=>  arg=arg
+(arg)

~tasfyn-partyv:dojo/sandbox> +test 42
43
```
Below we'll skip both boilerplate lines in our examples.

## A core is a code-data cell

But how do we actually, like, code?  The algorithm for decrement
is clear.  We need to count up to 41.  (How do we run useful
programs on a computer with O(n) decrement?  That's an
implementation detail.)

We'll need another kind of noun: the *core*.  Briefly, the core
is always a cell `[battery payload]`.  The payload is data, the
battery is code -- one or more Nock formulas, to be exact.

Consider a simple core with a one-formula battery.  Remember, we
create Nock formulas by compiling a twig against a subject.  The
subject is dynamic data, but its span is static.  What span do we
give the compiler, and what noun do we give the formula?

A core formula always has the core as its subject.  The formula
is essentially a computed attribute on the payload.  But if the
subject was just the payload, the formula couldn't recurse.

Of course, there is no need to restrict ourselves to one computed
attribute.  We can just stick a bunch of formulas together and
call them a battery.  The source twigs in this core are called
"arms," which have labels just like the faces we saw earlier.

Hoon overloads computed attributes (arms) and literal attributes
(legs) in the same namespace.  A label in a wing may refer to
either.  To extend the name-resolution tree search described in
chapter 1, when searching a core, we look for a matching arm.
If we find it we're done.  If we don't, or if a `^` mark makes us
skip, we search into the payload.

If a name resolves to a core arm, but it's not the last limb in the
wing, the arm produces the core itself.  Similarly, when the
wing is not an access but a mutation, the arm refers to the core.

This demands an example: if `foo` produces some core `c`, and
`bar` is an arm in that `c` (which may be `foo` itself, or some
leg within `foo`), `bar.foo` runs the arm formula with `c` as the
subject.  You might think that `moo.bar.foo` would compute
`bar.foo`, then search for `moo` within that result.  Instead, it
searches for `moo` within `c`.  (You can get the other result
with `moo:bar.foo`.)

Does this sound too tricky?  It should - it's about the most 
complicated feature of Hoon.  It's all downhill once you
understand cores.

Let's again extend our `++span` mold:
```
++  span
  $%  [%atom @tas]
      [%cell span span]
      [%core span (map ,@tas twig)]
      [%cube * span]
      [%face @tas span]
  ==
```
This definition of `%core` is somewhat simplified from the
reality, but basically conveys it.  (Moreover, this version of
`span` describes every kind of noun we build.)  In our `%core` we
see a payload span and a name-to-twig arm table, as expected.

Is a core an object?  Not quite, because an arm is not a method.
Methods in an OO language have arguments.  Arms are functions
only of the payload.  (A method in Hoon is an arm that produces a
gate, which is another core -- but we're getting too far ahead.)
However, the battery does look a lot like a classic "vtable."

## Increment with a core

Let's increment with a core:
```
=<  inc
|%
++  inc
  +(arg)
--

~tasfyn-partyv:dojo/sandbox> +test 42
43
```
What's going on?  We used the `|%` rune ("barcen") to produce a
core.  (There are a lot of runes which create cores; they all
start with `|`, and are basically macros that turn into `|%`.)

The payload of a core produced with `|%` is the subject with
which `|%` is compiled.  We might say that `|%` wraps a core
around its subject.  In this case, the subject of the `|%`,
and thus payload, is our `arg=@ud` argument.

Then we used this core as the subject of the simple wing `inc`.
(Remember that `=<(a b)` is just `=>(b a)`.)

We can actually print out a core.  Take out the `=<  inc`:
```
|%
++  inc
  +(arg)
--

~tasfyn-partyv:dojo/sandbox> +test 42
!!!

~tasfyn-partyv:dojo/sandbox> ? +test 42
!!!
```
Cores can be large and complex, and we obviously can't render all
the data in them, either when printing a type or a value.  At
some point, you'll probably make the mistake of printing a big
core, maybe even the whole kernel, as an untyped noun.  Just
press ^C.

## Adding a counter

To decrement, we need to count up to the argument.  So we need a
counter in our subject, because where else would it go?  Let's
change the subject to add a counter, `pre`:
```
=>  [pre=0 .]
=<  inc
|%
++  inc
  +(arg)
--

~tasfyn-partyv:dojo/sandbox> +test 42
43
```
Once again, `.` is the whole subject, so we're wrapping it in a
cell whose head is `pre=0`.  Through the magic of labels, this
doesn't change the way we use `arg`, even though it's one level
deeper in the subject tree.  Let's look at the subject again:
```
=>  [pre=0 .]
.

~tasfyn-partyv:dojo/sandbox> +test 42
[pre=0 arg=42]
~tasfyn-partyv:dojo/sandbox> ? +test 42
  [pre=@ud arg=@ud]
[pre=0 arg=42]
```
There's actually a simpler way to write this.  We've seen it
already.  It's not exactly a variable declaration:
```
=+  pre=0
.

~tasfyn-partyv:dojo/sandbox> +test 42
[pre=0 arg=42]
```

## We actually decrement

Now we can write our actual decrement program:
```
=+  pre=0
=<  dec
|%
++  dec
  ?:  =(arg +(pre))
    pre
  dec(pre +(pre))
--

~tasfyn-partyv:dojo/sandbox> +test 42
41
```
`=(a b)` is an irregular form of `.=(a b)`, ie, "dottis" or the
noun `[%dtts a b]`.  Likewise, `+(a)` is `.+(a)`, ie, "dotlus"
or `[%dtls a]`.

`?:` is a regular rune which does exactly what you think it does.
Bear in mind, though, that in Hoon 0 (`&`, "rob") is true and 1
(`|`, "bar") is false.

The real action is in `dec(pre +(pre))`.  This is obviously an
irregular form -- it's the same mutation form we saw before.
Writing it out in full regular form:
```
=+  pre=0
=<  dec
|%
++  dec
  ?:  =(arg +(pre))
    pre
  %=  dec
    pre  +(pre)
  ==
--
~tasfyn-partyv:dojo/sandbox> +test 42
41
```
`%=`, "centis", is the rune which almost every use of a wing
resolves to.  It might be called "evaluate with changes."

When we evaluate with changes, we take a wing (`dec`) here and
evaluate it as described above.  Searching in the subject, which
is of course our core, we find an arm called `dec` and run it.

The changes (replacing `pre` with `+(pre)`) are always applied
relative to the core we landed on (or the leg we landed on).
The change wing is relative to this target; the subject of the 
replacement (`+(pre)`) is the original subject.

So, in English, we compute the `dec` arm again, against a new
core with a new payload that contains an incremented `pre`.
And thus, we decrement.  Doesn't seem so hard, does it?
