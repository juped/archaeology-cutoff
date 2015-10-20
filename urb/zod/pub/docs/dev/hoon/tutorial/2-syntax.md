# Hoon 2: serious syntax

We've done a bunch of fun stuff on the command line.  We know our
nouns.  It's time to actually write some serious code -- in a
real source file.

## Building a simple generator

In Urbit there's a variety of source file roles, distinguished by
the magic paths they're loaded from: `/gen` for generators,
`/ape` for appliances, `/fab` for renderers, etc.

We'll start with a generator, the simplest kind of Urbit program.

### Create a sandbox desk

A desk is the Urbit equivalent of a `git` branch.  We're just
playing around here and don't intend to soil our `%home` desk with
test files, so let's make a sandbox:
```
|merge %sandbox our %home
```
### Mount the sandbox

Your Urbit pier is in `~/tasfyn-partyv`, or at least mine is.
So we can get our code into Urbit, run the command 
```
~tasfyn-partyv:dojo> |mount /=sandbox=/gen %gen
```
mounts the `/gen` folder from the `%sandbox` desk in your Unix
directory  `~/tasfyn-partyv/gen`.  The mount is a two-way sync,
like your Dropbox.  When you edit a Unix file and save, your edit
is automatically committed as a change to `%sandbox`.

### Execute from the sandbox

The `%sandbox` desk obviously is merged from `%home`, so it
contains find all the default facilities you'd expect there.
Bear in mind, we didn't set it to auto-update when `%home` 
is updated (that would be `|sync` instead of `|merge`).

So we're not roughing it when we set the dojo to load from
`%sandbox`:
```
[switch to %home]
```

### Write your builder

Let's build the simplest possible kind of generator, a builder.
With your favorite Unix text editor (there are Hoon modes for vim
and emacs), create the file `~/tasfyn-partyv/gen/test.hoon`.
Edit it into this:
```
:-  %say  |=  *  :-  %noun
[%hello %world]
```
Get the spaces exactly right, please.  Hoon is not in general a
whitespace-sensitive language, but the difference between one
space and two-or-more matters.  And for the moment, think of
```
:-  %say  |=  *  :-  %noun
```
as gibberish boilerplate at the start of a file, like `#include
"stdio.h"` at the start of a C program.   Any of our old Hoon
constants would work in place of `[%hello %world`].

Now, run your builder:
```
~tasfyn-partyv:dojo/sandbox> +test
[%hello %world]
```
Obviously this is your first Hoon *program* per se.  

## Hoon syntax 101

But what's up with this syntax?

### A syntactic apology

The relationship between ASCII and human programming languages
is like the relationship between the electric guitar and
rock-and-roll.  If it doesn't have a guitar, it's not rock.
Some great rockers play three chords, like Johnny Ramone; some
shred it up, like Jimmy Page.

The two major families of ASCII-shredding languages are Perl and
the even more spectacular APL.  (Using non-ASCII characters is
just a fail, but APL successors like J fixed this.)  No one
has any right to rag on Larry Wall or Ken Iverson, but Hoon, 
though it shreds, shreds very differently.

The philosophical case for a "metalhead" language is threefold.
One, human beings are much better at associating meaning with
symbols than they think they are.  Two, a programming language is
a professional tool and not a plastic shovel for three-year-olds.

And three, the alternative to heavy metal is keywords.  When you
use a keyword language, not only are you forcing the programmer
to tiptoe around a ridiculous maze of restricted words used and
reserved, you're expressing your program through two translation
steps: symbol->English and English->computation.  When you shred,
you are going direct: symbol->computation.  Especially in a pure
language, this creates a sense of "seeing the function" which no
keyword language can quite duplicate.

But any metalhead language you don't yet know is line noise.
Let's get you up to speed as fast as possible.

### A glyphic bestiary

A programming language needs to be not just read but said.  But
no one wants to say "ampersand."  Therefore, we've taken the
liberty of assigning three-letter names to all ASCII glyphs.

Some of these bindings are obvious and some aren't.  You'll be
genuinely surprised at how easy they are to remember:
```
    ace [1 space]  dot .               pan ]
    bar |          fas /               pel )
    bis \          gap [>1 space, nl]  pid }
    buc $          hax #               ran >
    cab _          ket ^               rep '
    cen %          lep (               sac ;
    col :          lit <               tar *
    com ,          lus +               tec `
    das -          mat @               tis =
    den "          med &               wut ?
    dip {          nap [               zap !
```
It's fun to confuse people by using these outside Urbit.  A few
digraphs also have irregular sounds:
```
==  stet
--  shed
++  slus
->  dart
-<  dusk
+>  lark
+<  lush
```

### The shape of a twig

A twig, of course, is a noun.  As usual, the easiest way to
explain both the syntax that compiles into that noun, and the
semantic meaning of the noun, is the noun's physical structure.

#### Autocons

A twig is always a cell, and any cell of twigs is a twig
producing a cell.  As an homage to Lisp, we call this
"autocons."  Where you'd write `(cons a b)` in Lisp, you write
`[a b]` in Hoon, and the shape of the twig follows.

The `???` prefix prints a twig as a noun instead of running it.
Let's see autocons in action:
```
~tasfyn-partyv:dojo/sandbox> ??? 42
[%dtzy %ud 42]
~tasfyn-partyv:dojo/sandbox> ??? 0x2a
[%dtzy %ux 42]
~tasfyn-partyv:dojo/sandbox> ??? [42 0xa]
[[%dtzy %ud 42] %dtzy %ux 42]
```
(As always, it may confuse *you* that this is the same noun as
`[[%dtzy %ud 42] [%dtzy %ux 42]]`, but it doesn't confuse Hoon.)

#### The stem-bulb pattern

If the head of your twig is a cell, it's an autocons.  If the
head is an atom, it's an unpronounceable four-letter symbol like
the `%dtzy` above.

This is the same pattern as we see in the `span` mold -- a
variant record, essentially, in nouns.  The head of one of these
cells is called the "stem."  The tail is the "bulb."  The shape
of the bulb is totally dependent on the value of the stem.

#### Runes and stems

A "rune" (a word intentionally chosen to annoy Go programmers) is
a digraph - a sequence of two ASCII glyphs.  If you know C, you
know digraphs like `->` and `?:` and are used to reading them as
single characters.

In Hoon you can *say* them as words: "dasran" and "wattis"
respectively.  In a metalhead language, if we had to say 
"minus greater-than" and "question-colon", we'd just die.

Most twig stems are made from runes, by concatenating the glyph
names and removing the vowels.  For example, the rune `=+`,
pronounced "tislus," becomes the stem `%tsls`.  (Note that in
many noun implementations, this is a 31-bit direct value.)

(Some stems (like `%dtzy`) are not runes, simply because they
don't have regular-form syntax and don't need to use precious
ASCII real estate.  They are otherwise no different.)

An important point to note about runes: they're organized.  The
first glyph in the rune defines a category.  For instance, runes
starting with `.` compute intrinsics; runes starting with `|`
produce cores; etc.

Another important point about runes: they come in two flavors,
"natural" (stems interpreted directly by the compiler) and
"synthetic" (macros, essentially).

(Language food fight warning: one advantage of Hoon over Lisp is
that all Hoon macros are inherently hygienic.  Another advantage
is that Hoon has no (user-level) macros.  In Hoon terms, nobody 
gets to invent their own runes.  A DSL is always and everywhere
a write-only language.  Hoon shreds its ASCII pretty hard, but
the same squiggles mean the same things in everyone's code.)

#### Wide and tall regular forms

A good rune example is the simple rune `=+`, pronounced "tislus",
which becomes the stem `%tsls`.  A `%tsls` twig has the shape
`[%tsls twig twig]`.

The very elegance of functional languages creates a visual
problem that imperative languages lack.  An imperative language
has distinct statements (with side effects) and (usually pure)
expressions; it's natural that in most well-formatted code,
statements flow vertically down the screen, and expressions grow
horizontally across this.  This interplay creates a natural and
relaxing shape on your screen.

In a functional language, there's no difference.  The trivial
functional syntax is Lisp's, which has two major problems.  One:
piles of expression terminators build up at the bottom of complex
functions.  Two: the natural shape of code is diagonal.  The more
complex a function, the more it wants to besiege the right
margin.  The children of a node have to start to the right of its
parent, so the right margin bounds the tree depth.

Hoon does not completely solve these problems, but alleviates
them.  In Hoon, there are actually two regular syntax forms for
most twig cases: "tall" and "wide" form.  Tall twigs can contain
wide twigs, but not vice versa, so the visual shape of a program
is very like that of a statements-and-expressions language.
 
Also, in tall mode, most runes don't need terminators.  Take
`=+`, for example.  Since the parser knows to expect exactly 
two twigs after the `=+` rune, it doesn't need any extra syntax
to tell it that it's done.

Let's try a wide `=+` in the dojo:
```
~tasfyn-partyv:dojo/sandbox> =+(planet=%world [%hello planet])
[%hello %world]
```
(`=+` seems to be some sort of variable declaration?  Let's not
worry about it right now.  We're on syntax.)

The wide syntax for a `=+` twig, or any binary rune: `(`, the 
first subtwig, one space, the second subtwig, and `)`).  To read
this twig out loud, you'd say:
```
tislus lap planet is cen world ace nep cen hello ace planet pen
pal
```
("tis" not in a rune gets contracted to "is".)

Let's try a tall `=+` in `test.hoon`: 
```
:-  %say  |=  *  :-  %noun
=+  planet=%world
[%hello planet]
```
The tall syntax for a `=+` twig, or any binary rune: the rune, at 
least two spaces or one newline, the first subtwig, at least two 
spaces or one newline, the second subtwig.  Again, tall subtwigs
can be tall or wide; wide subtwigs have to be wide.

(Note that our boilerplate line is a bunch of tall runes on one
line, with two-space gaps.  This is unusual but quite legal, and
not to be confused with the actual wide form.)

To read this twig out loud, you'd say:
```
tislus gap planet is cen world gap nep cen hello ace planet pen
```
#### Layout conventions

Should you use wide twigs or tall twigs?  When?  How?  What
should your code look like?  You're the artist.  Except for the
difference between one space (`ace`) and more space (`gap`), the
parser doesn't care how you format your code.  Hoon is not Go --
there are no fixed rules for doing it right.

However, the universal convention is to keep lines under 80
characters.  Also, hard tab characters are illegal.  And when in
doubt, make your code look like the kernel code.

##### Backstep indentation

Note that the "variable declaration" concept of `=+` (which is no
more a variable declaration than a Tasmanian tiger is a tiger)
works perfectly here.  Because `[%hello planet]` -- despite being
a subtree of the the `=+` twig -- is at the same indent level.
So our code flows down the screen, not down and to the right, and
of course there are no superfluous terminators.  It looks good,
and creates fewer hard-to-find syntax errors than you'd think.

This is called "backstep" indentation.  Another example, using a
ternary rune that has a strange resemblance to C:
```
:-  %say  |=  *  :-  %noun
=+  planet=%world
?:  =(%world planet)
  [%hello planet]
[%goodbye planet]
```
It's not always the case when backstepping that the largest
subtwig is at the bottom and loses no margin, but it often is.
And not all runes have tuple structure; some are n-ary, and use
the `==` terminator (again, pronounced "stet"):
```
:-  %say  |=  *  :-  %noun
=+  planet=%world
?+  planet
          [%unknown planet]
  %world  [%hello planet]
  %ocean  [%goodbye planet]
==
```
So we occasionally lose right-margin as we descend a deep twig.
But we can keep this lossage low with good layout design.  The
goal is to keep the heavy twigs on the right, and Hoon tries as
hard as possible to help you with this.

For instance, `=+` ("tislus") is a binary rune: `=+(a b)`.  In
most cases of `=+` the heavy twig is `b`, but sometimes it's `a`.
So we can use its friend the `=-` rune ("tisdas") to get the same
semantics with the right shape: `=-(b a)`.

#### Irregular forms

There are more regular forms than we've shown above, but not a
lot more.  Hoon would be quite easy to learn if it was only its
regular forms.  It wouldn't be as easy to read or use, though.
The learning curve is important, but not all-important.

Some stems (like the `%dtzy` constants above) obviously don't and
can't have any kind of regular form (which is why `%dtzy` is not
a real digraph rune).  Many of the true runes have only regular
forms.  But some have irregular forms.  Irregular forms are 
always wide, but there is no other constraint on their syntax.

We've already encountered one of the irregular forms: `foo=42`
from the last chapter, and `planet=%world` here.  Let's unpack
this twig:
```
~tasfyn-partyv:dojo/sandbox> ?? %world
  [%cube 431.316.168.567 %atom %tas]
%world

~tasfyn-partyv:dojo/sandbox> ??? %world
[%dtzz %tas 431.316.168.567]
```
Clearly, `%dtzz` is one of our non-regulars.  But we can wrap it
with our irregular form:
```
~tasfyn-partyv:dojo/sandbox> ?? planet=%world
  [%face %planet [%cube 431.316.168.567 %atom %tas]]
planet=%world

~tasfyn-partyv:dojo/sandbox> ??? planet=%world
[%ktts %planet %dtzz %tas 431.316.168.567]
```
Since `%ktts` is "kettis", ie, `^=`, this has to be the irregular
form of
```
~tasfyn-partyv:dojo/sandbox> ^=(planet %world)
planet=world
```
So if we wrote our example without this irregular form, it'd be
```
:-  %say  |=  *  :-  %noun
=+  ^=(planet %world)
[%hello planet]
```
Or with a gratuitous use of tall form:
```
:-  %say  |=  *  :-  %noun
=+  ^=  planet  %world
[%hello planet]
```
Now you know how to read Hoon!  For fun, try to pronounce more of
the code on this page.  Please don't laugh too hard at yourself.
