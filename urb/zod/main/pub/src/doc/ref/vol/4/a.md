Ames
====

Ames is our networking protocol.  First we give an informal, high-level
description of the protocol, then we get into the nitty-gritty of the
implementation.

The Lifecycle of a Packet (or, How a Packet Becomes Law)
--------------------------------------------------------

Here, we will trace a packet as it makes its way through ames.  There are
actually two pathways through ames:  the legacy path through `%want`, and the
modern way, entered through `%wont`, with full end-to-end acknowledgments.
Here we will only trace the modern way.

When an app (or a vane) wishes to send a packet to another ship, it must send a
`%wont` card:

```
              [%wont p=sock q=path r=*]                 ::  e2e send message
```

This card takes three arguments.  The `p` is a `sock`, that is, a pair of two
ships, the first of which is the sender and the second is the receiver.  But
wait, you ask, why do I get to decide who is the sender?  Can I fake like I'm
someone else?  The reason is that there are potentially multiple ships on the
same pier, and the kernel can send a message from any of them.  If you attempt
to send a message from a ship not on your pier, then ames will refuse to send
it.  If you hack around in your own copy of ames to go ahead and send it
anyway, then the other ship will reject it because your key is bad.  Basically,
only send messages from yourself.

The `q` is a path, representing the place on the other side that you want to
receive your message.  It is approximately equivalent to a port number.
Messages on the same path are guaranteed to arrive in the same order as they
were sent.  No such guarantees are made across paths.

The `r` is the actual data that you are sending.  As the type implies, this can
be an arbitrary noun, and it will be transferred to the receiver exactly as-is,
in a well-typed way.  Of course, this is data that is sent over the wire, so be
careful not to send anything too massive unless you're willing to wait.

But enough about the interface.  Grepping in ames.hoon for `%wont`, we find
that it appears in exactly two places:  at its definition in `++kiss`, and in
`++knob`, where it is handled.  We see that we go directly into `++wise:am`.

```
    ++  wise                                            ::    wise:am
      |=  [soq=sock hen=duct cha=path val=* ete=?]      ::  send a statement
      ^-  [p=(list boon) q=fort]
      zork:zank:(wool:(ho:(um p.soq) q.soq) hen cha val ete)
```

The inputs to this gate are exactly the sort of thing you'd expect.  In
particular, everything in the `%wont` gate is here plus the calling `duct` so
that we know where to send the acknowledgment and `ete` to determine if we're
going to do the modern end-to-end acknowledgments.

The actual line of code looks intimidating, but it's really not all that bad.
Working from the inside out, the call to `++um` sets up our domestic server,
and the call to `++ho` sets up our knowledge about the neighbor we're sending
to.  From the outside, `++zork` and `++zank` just apply the changes made to our
`++um` and `++am` cores, respectively.  If you're familiar with the common
idiom of `++abet`, that's all this is.  The code predates the widespread usage
of that name.

The interesting part, then, is in `++wool:ho:um:am`.  Let's look at the code.

```
        ++  wool                                        ::    wool:ho:um:am
          |=  [hen=duct cha=path val=* ete=?]           ::  send a statement
          ^+  +>
          =+  ^=  rol  ^-  rill
              =+  rol=(~(get by ryl.bah) cha)
              ?~(rol *rill u.rol)
          =+  sex=sed.rol
          ::  ~&  [%tx [our her] cha sex]
          =.  ryl.bah
              %+  ~(put by ryl.bah)  cha
              rol(sed +(sed.rol), san (~(put by san.rol) sex hen))
          =+  cov=[p=p:sen:gus q=clon:diz]
          %+  wind  [cha sex]
          ?:  ete
            [%bund q.cov cha sex val]
          [%bond q.cov cha sex val]
```

This is slightly more complicated, but it's still not all that bad.  Our
inputs, at least, are fairly obvious.

If you glance at the code for a second, you'll see that `++wind:ho:um:am` seems
to be able to send a message, or `++meal`, given a `++soup`.  This gate, then,
just sets up the things we need to for `++wind` to do its job.

We first get `rol`, which is a `++rill`, that is, a particular outbound stream.
This stream is specific to the path on which we're sending.  If the path hasn't
been used before, then we create it.  We let `sex` be the number of messages
we've already sent on this path.

Then, we update the outbound stream by incrementing the number of messages sent
and placing an entry in `san.rol` that associates the message number with the
`duct` that sent the message.  This allows us to give the acknowledgment to the
one who sent the message.

We let `cov` be the current life of our crypto and our neighbor's crypto.  At
the moment, we only need our neighbor's life, which we put into the meal.

Finally, we call `++wind:ho:um:am` with the `++soup` of the path and message
number and the `++meal` of the payload itself.  For end-to-end acknowledged
messages, we use `%bund`.

```
              [%bund p=life q=path r=@ud s=*]           ::  e2e message
```

Looking at how we create the `%bund`, we can easily see what each field is for.

Following the trail a little further, we go to `++wind:ho:um:am`.

```
        ++  wind                                        ::    wind:ho:um:am
          |=  [gom=soup ham=meal]
          ::  ~&  [%wind her gom]
          ^+  +>
          =^  wyv  diz  (zuul:diz now ham)
          =^  feh  puz  (whap:puz now gom wyv)
          (busk xong:diz feh)
```

`++wind` does three things:  it (1) encodes the message into a list of
possibly-encrypted packets, (2) puts the message into the packet pump, and (3)
sends any packets that are ready to be sent.  Yes, our nice little linear run
of each gate calling exactly one other interesting gate is over.  We'll go in
order here.

`++zuul:lax:as:go` is the what converts a `++meal` into a list of actual, 1KB
packets.

```
        ++  zuul                                        ::    zuul:lax:as:go
          |=  [now=@da ham=meal]                        ::  encode message
          ^-  [p=(list rock) q=_+>]
          =<  weft
          ++  wasp                                      ::  null security
          ++  weft                                      ::  fragment message
          ++  wisp                                      ::  generate message
```

For organizational purposes, `++zuul` constructs an internal core with three
arms.  `++wasp` encodes the meal into an atom with no encryption.  `++wisp`
encodes a meal with possible encryption (else it simply calls `++wasp`).
`++weft` takes the result of `++wisp` and splits it into actual packets.

```
          ++  wasp                                      ::  null security
            ^-([p=skin q=@] [%none (jam ham)])
```

This simply jams the meal, wrapping it with the `skin` of `%none`, meaning no
encryption.

Since `++wisp` is a little long, we'll go through it line-by-line.

```
          ++  wisp                                      ::  generate message
            ^-  [[p=skin q=@] q=_..wisp]
```

`++wisp` produces a pair of a `skin` and an atom, which is the meal encoded as
a single atom and possibly encrypted.

```
            ?:  =(%carp -.ham)
              [wasp ..wisp]
```

If the meal that we're encoding is a `%carp`, then we don't encrypt it.  A
`%carp` meal is a partial meal, used when a message is more than 1KB.  Since
the entire message is already encrypted, we don't need to encrypt each packet
individually again.

```
            ?:  !=(~ yed.caq.dur)
              ?>  ?=(^ yed.caq.dur)
              :_  ..wisp
              :-  %fast
              %^  cat  7
                p.u.yed.caq.dur
              (en:r:cluy q.u.yed.caq.dur (jam ham))
```

If we have a symmetric key set up with this neighbor, then we simply use it.
The skin `%fast` is used to indicate a symmetric key.

```
            ?:  &(=(~ lew.wod.dur) |(=(%back -.ham) =(%buck -.ham)))
              [wasp ..wisp]
```

If we do not yet have our neighbor's will, then there is no way that we can
seal the message so that only they may read it.  If what we're sending is an
acknowledgment, then we go ahead and just send it in the clear.

```
            =^  tuy  +>.$
              ?:(=(~ lew.wod.dur) [*code +>.$] (griz now))
```

If we don't have our neighbor's will, then we "encrypt" with a key of 0.  If we
do have their will, then we generate a new symmetric key that we will propose.

```
            :_  ..wisp
            =+  yig=sen
            =+  bil=law.saf                             ::  XX send whole will
            =+  hom=(jam ham)
```

`yig` will be the life and engine for our current crypto.  `bil` is our will.
`hom` is the meal encoded as a single atom.

```
            ?:  =(~ lew.wod.dur)
              :-  %open
              %^    jam
                  [~ `life`p.yig]
                bil
              (sign:as:q.yig tuy hom)
```

If we do not have our neighbor's will, then we send our current life along with
our will and the message.  The message itself is "signed" with a key of 0.

```
            :-  %full
              =+  cay=cluy
              %^    jam
                  [`life`p.cay `life`p.yig]
                bil
              (seal:as:q.yig pub:ex:r.cay tuy hom)
          --                                            ::  --zuul:lax:as:go
```

If we do have our neighbor's will, then we send our perception of their current
life, our current life, our will, and the message.  The message is sealed with
their public key so that only they can read our message.

Once we have the message encoded as an atom, `++weft` goes to work.

```
          ++  weft                                      ::  fragment message
            ^-  [p=(list rock) q=_+>.$]
            =^  gim  ..weft  wisp
            :_  +>.$
            ^-  (list rock)
```

We're going to produce a list of the packets to send.  First, we use the
aforementioned `++wisp` to get the message as an atom.

```
            =+  wit=(met 13 q.gim)
            ?<  =(0 wit)
```

`wit` is the number of 1KB (2^13 bit) blocks in the message.  We assert that
there is at least one block.

```
            ?:  =(1 wit)
              =+  yup=(spit [our her] p.gim q.gim)
              [yup ~]
```

If there is exactly one block, then we just call `++spit` to turn the message
into a packet.  We'll explain what `++spit` does momentarily.

```
            =+  ruv=(rip 13 q.gim)
            =+  gom=(shaf %thug q.gim)
            =+  inx=0
```

If there is more than one block, then we rip it into blocks in `ruv`.  `gom` is
a hash of the message, used as an id.  `inx` is the number of packets we've
already made.

```
            |-  ^-  (list rock)
            ?~  ruv  ~
            =+  ^=  vie
                %+  spit
                  [our her]
                wasp(ham [%carp (ksin p.gim) inx wit gom i.ruv])
            :-  vie
            $(ruv t.ruv, inx +(inx))
```

Here we package each block into a packet with `++spit` and produce the list of
packets.

```
  ++  spit                                              ::  cake to packet
    |=  kec=cake  ^-  @
    =+  wim=(met 3 p.p.kec)
    =+  dum=(met 3 q.p.kec)
    =+  yax=?:((lte wim 2) 0 ?:((lte wim 4) 1 ?:((lte wim 8) 2 3)))
    =+  qax=?:((lte dum 2) 0 ?:((lte dum 4) 1 ?:((lte dum 8) 2 3)))
    =+  wix=(bex +(yax))
    =+  vix=(bex +(qax))
    =+  bod=:(mix p.p.kec (lsh 3 wix q.p.kec) (lsh 3 (add wix vix) r.kec))
    =+  tay=(ksin q.kec)
    %+  mix
      %+  can  0
      :~  [3 1]
          [20 (mug bod)]
          [2 yax]
          [2 qax]
          [5 tay]
      ==
    (lsh 5 1 bod)
```

This is how we turn a message into a real packet.  This has the definition of
the packet format.

`wim` is the length of the sending ship, and `dum` is the length of the
receiving ship.  There are only five possibilities for each of those,
corresponding to carriers, cruisers, destroyers, yachts, and submarines.  These
are encoded in `yax` and `qax` as 0, 0, 1, 2, and 3, respectively.  Thus, `wix`
and `vix` are the number of bytes that must be reserved for the ship names in a
packet.

Next, we construct `bod` by simply concatenating the sending ship, the
receiving ship, and the body of the message.  Then, we get the encryption
mechanism from `++skin`, which may be a 0, 1, 2, or 3, and put it in `tay`.

Next, we concatenate together, bit by bit, some final metadata.  We use three
bits for our protocol number, which is incremented modulo eight when there is a
continuity breach or the protocol changes.  We use the final twenty bits of a
hash of the body for error-checking.  We use two bits to tell how much room is
used in the body for the sending ship, and another two bits for the receiving
ship.  Finally, we use five bits to store the encryption type.  Note that since
there are only two bits worth of encryption types, there are three unused bits
here.  This adds up to 32 bits of header data.  Finally, we concatenate this
onto the front of the packet.  Thus, we can summarize the packet header format
as follows.

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Proto|             Hash of Body              |yax|qax| Crypto  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

After this, there are `yax` bits of the sender name, `qax` bits of the receiver
name, and up to 8192 bits of data.  Thus, the maximum size of a packet is
achieved in a message between two submarines with 8192 bits of data.  This will
require 32+128+128+8192 = 8480 bits, or 1060 bytes.

This concludes our discussion of `++zuul:lax:as:go`.  If you recall from
`++wind:ho:um:am`, the list of packets from `++zuul` is passed into `++whap:pu`
to update the packet pump and get any packets that can be sent immediately.

```
    ++  whap                                            ::    whap:pu
      |=  [now=@da gom=soup wyv=(list rock)]            ::  send a message
      ^-  [(list rock) _+>]
      =.  pyz  (~(put by pyz) gom (lent wyv))
      =.  +>
        |-  ^+  +>.^$
        ?~  wyv  +>.^$
        %=  $
          wyv  t.wyv
          nus  +(nus)
          diq  (~(put by diq) (shaf %flap i.wyv) nus)
          puq  (~(put to puq) [nus `soul`[gom 0 | ~2000.1.1 i.wyv]])
        ==
      (harv now)
```

First, we put into `pyz` the id for this message and the number of its packets
that have not yet been acknowledged, which is of course the total number of
packets since we haven't even sent the packets.

For every packet, we change three things in the state (`++shed`) of our packet
pump:  (1) we increment `nus`, the number of packets sent; (2) we put the
packet number into `diq` keyed by a hash of the packet; and (3) we put the
packet into the packet queue, with the basic metadata of its id `gom`, 0
transmissions, not live yet, last sent in the year 2000, and the packet itself.

Finally, we harvest the packet pump.

```
    ++  harv                                            ::    harv:pu
      |=  now=@da                                       ::  harvest queue
      ^-  [(list rock) _+>]
      ?:  =(~ puq)  [~ +>(rtn ~)]
      ?.  (gth caw nif)  [~ +>]
      =+  wid=(sub caw nif)
      =|  rub=(list rock)
      =<  abet  =<  apse
      |%
```

`++harv` contains a core for most of its work.  The meat is in `++apse`.
First, though, it sets itself up.  If there aren't any packets in the queue,
then we simply do nothing except set `rtn`, our next timeout, to nil because we
don't have any packets that may need to be retransmitted.  If we have more live
(that is, sent and unacknowledged) packets than our window size, then we don't
do anything.

Otherwise, we let `wid` be the width of our remaining packet window, and we
initialize `rub` to nil.  `rub` will be the list of packets that are ready to
be sent.  We then call `++apse` and pass the result to `++abet`.  `++apse`
decides which packets are ready to be sent.

```
      ++  apse
        ^+  .
        ?~  puq  .
        ?:  =(0 wid)  .
        =>  rigt  =<  left
        ?>  ?=(^ puq)
        ?:  =(0 wid)  .
        ?.  =(| liv.q.n.puq)  .
        ::  ~&  [%harv nux.q.n.puq p.n.puq]
        %_    .
          wid          (dec wid)
          rub          [pac.q.n.puq rub]
          nif          +(nif)
          liv.q.n.puq  &
          nux.q.n.puq  +(nux.q.n.puq)
          lys.q.n.puq  now
        ==
```

If there are no remaining packets to send, or if we've filled the packet
window, do nothing.  We call `++rigt` and `++left` to process the left and
right branches of the packet queue.

Now we assert that the queue is not empty, and we again check that we haven't
filled the packet window.  We will operate on the head of the queue.  If the
packet is live, then do nothing.  Otherwise, we go ahead and send it.

To send, we (1) decrement `wid`, our packet window width; (2) cons the packet
onto the `rub`, which will be returned as the list of packets to send; (3)
increment `nif`, the number of live packets; (4) set the packet to be live;
(5) increment the number of transmissions of the packet; and (6) set the last
sent time of the packet to now.

```
      ++  left
        ?>  ?=(^ puq)
        ^+(. =+(lef=apse(puq l.puq) lef(puq [n.puq puq.lef r.puq])))
      ++  rigt
        ?>  ?=(^ puq)
        ^+(. =+(rig=apse(puq r.puq) rig(puq [n.puq l.puq puq.rig])))
```

These do exactly what you would expect:  they traverse the packet queue so that
`++apse` gets called recursively through it.

Finally, `++abet` gets called, which resolves the changes.

```
      ++  abet
        ?~  rub  [~ +>.$]
        [(flop rub) +>.$(rtn [~ (add rto now)])]
```

This returns the packets that we wish to send, and it updates the timeout so
that we know when to try resending unacknowledged packets.

This concludes our discussion of `++whap:pu`.  To finish `++wind:ho:um:am`, we
just need to delve into `++busk:ho:um:am`.  But wait, in the call to `++busk`,
the first argument is `xong:diz`.  What is this?  This, my dear reader, is one
more detour, this time into `++xong:lax:as:go`.

```
        ++  xong                                        ::    xong:lax:as:go
          ^-  (list ship)                               ::  route unto
          =+  [fro=xen too=xeno]
          =+  ^=  oot  ^-  (list ship)
              =|  oot=(list ship)
              |-  ^+  oot
              ?~  too  ~
              ?:  (lien fro |=(a=ship =(a i.too)))  ~
              [i.too $(too t.too)]
          ::  ~&  [%xong-to [our her] (weld oot ?>(?=(^ fro) t.fro))]
          (weld oot ?>(?=(^ fro) t.fro))
```

This gets the list of intermediate ships needed to get a packet from us to our
neighbor.  First, we get `fro` and `too`, the "canons" of ourself and our
neighbor, respectively.

What is this "canon", you ask?  A canon is simply a ship plus its "ancestors",
as defined by `++sein`.  For example, the canon of `~hoclur-bicrel` is:

```
~hoclur-bicrel/try=> (saxo ~hoclur-bicrel)
~[~hoclur-bicrel ~tasruc ~tug]
```

If we follow the algorithm in `++xong`, we see that we are simply creating a
list of ships that form a path from our neighbor to ourself.  Essentially, we
look through the canon of our neighbor until we find something in our own
cannon -- a common ancestor.  Or, if we are from different carriers, then there
is no common ancestor.  We then weld this onto the tail of our own canon.  In
the end, this is simply a list of possible ships to try to route via to get to
our neighbor, ordered by preferability (that is, closeness to our neighbor).
We will end up trying, in order, to find a lane to these.

Now, we can finally get to `++busk:ho:um:am`.

```
        ++  busk                                        ::    busk:ho:um:am
          |=  [waz=(list ship) pax=(list rock)]         ::  send packets
          %_    +>
              bin
            |-  ^+  bin
            ?~  pax  bin
            $(pax t.pax, bin (weld (flop (wist:diz now waz ~ i.pax)) bin))
          ==
```

Thankfully, `++busk` is fairly simple.  We go through the list of packets and
convert them to `++boon`s with `++wist:lax:as:go`.  These boons are placed into
`bin`, and they end up getting processed by `++clop` (this happens in
`++knob`).

```
        ++  wist                                        ::    wist:lax:as:go
          |=  $:  now=@da                               ::  route via
                  waz=(list ,@p)
                  ryn=(unit lane)
                  pac=rock
              ==
          ^-  (list boon)
          ?:  =(our her)  [[%ouzo *lane pac] ~]
          ?~  waz  ~
          =+  dyr=?:(=(her i.waz) dur (gur i.waz))
          ?.  ?&  !=(our i.waz)
                  ?=(^ lun.wod.dyr)
              ==
            $(waz t.waz)
          :_  ?:  ?=(%ix -.u.lun.wod.dyr)
                $(waz t.waz)
              ~
          :+  %ouzo  u.lun.wod.dyr
          ?:  &(=(i.waz her) =(~ ryn))  pac
          =+  mal=(jam `meal`[%fore her ryn pac])
          %-  spit
          ^-  cake
          :*  [our i.waz]
              ?~  yed.caq.dyr  [%none mal]
              :-  %fast
              %^  cat  7
                p.u.yed.caq.dyr
              (en:crua q.u.yed.caq.dyr mal)
          ==
```

This takes a sample of the current time, the list of ships that we just
generated, a lane if we already know it, and the packet itself.

First, if we are sending a message to ourself, then we simply create a `%ouzo`
boon with a bunted lane.  Otherwise, if there are no routing candidates, there
is nothing we can do, so we return nil.

data models
-----------

###`++fort`, formal state

```
++  fort                                                ::  formal state
          $:  %0                                        ::  version
              gad=duct                                  ::  client interface
              hop=@da                                   ::  network boot date
              ton=town                                  ::  security
              zac=(map ship corn)                       ::  flows by server
          ==                                            ::
```

This is the state of our vane.  Anything that must be remembered between
calls to ames must be stored in this state.

`%0` is the version of the ames state model itself.  If the data model `++fort`
changes, then this number needs to be incremented, and an adapter must be
written to upgrade the old state into the new state.  Note that this is the
version number of the model itself, not the contents.  When the data changes,
there is of course no need to change this.

`gad` is a `duct` over which we send `%send` cards to unix.  This card is
initialized when unix sends a `%barn` card as vere starts up.  Vere treats this
duct specially -- don't send anything weird over it.

`hop` is the network boot date.  This is set when the `%kick` card is sent by
vere on start up.

`ton` is a `++town`, where we store all of our security/encryption state.  Note
that this is shared across all ships on a pier.

`zac` is a map of ships to `++corn`.  This stores all the per-ship state.  The
keys to this map are the ships on the current pier.

###`++town`, all security state

```
++  town                                                ::  all security state
          $:  lit=@ud                                   ::  imperial modulus
              any=@                                     ::  entropy
              urb=(map ship sufi)                       ::  all keys and routes
              fak=?                                     ::
          ==                                            ::
```

This is the security state of our pier.

`lit` is unused.

`any` is 256 bits of entropy.  This entropy is used and updated in exactly two
places: when we send a `%junk` card, and when we generate a new symmetric key
in `++griz:lax:as:go`.  When it is updated, it is updated by a SHA-256 hash of
the current time and the old value of the entropy.

`urb` is a map of ships to `++sufi`.  This is where we store all the per-ship
state for the pier.  The keys to this map are the ships on the current pier.

`fak` is true if we are on a fake network.  This disables certain security
checks so that anyone may run a fake `~zod`.  This is used only for development.
To use, run vere with the `-F` option (and the `-I ~zod` option for a fake
`~zod`).

###`++sufi`, domestic host

```
++  sufi                                                ::  domestic host
          $:  hoy=(list ship)                           ::  hierarchy
              val=wund                                  ::  private keys
              law=will                                  ::  server will
              seh=(map hand ,[p=ship q=@da])            ::  key cache
              hoc=(map ship dore)                       ::  neighborhood
          ==                                            ::
```

This is the security state of a domestic server.

`hoy` is a list of the ships directly above us in the hierarchy of ships.  For
example, for `~hoclur-bicrel`, this would be `~tasruc` and `~tug`.  See
`++sein`.

`val` is a list of our private keys.

`law` is our certificate, which is a list of the XXX

`seh`

`hoc` is a map of ships to `++dore`.  The stores all the security informatoin
about foreign ships.  The keys to this map are the neighbors (ships we have
been in contact with) of this domestic server.

###`++wund`, private keys

```
++  wund  (list ,[p=life q=ring r=acru])                ::  mace in action
```

This is a list of our own private keys, indexed by life.  The key itself is
the `++ring`, and the `++acru` is the encryption engine.  We generate the
`++acru` from the private key by calling `++weur`.  Thus, we can at any time
regenerate our `++wund` from a `++mace`.  The current crypto is at the head of
the list and can be accessed with
`++sen:as:go`.

###`++ring`, private key

```
++  ring  ,@                                            ::  private key
```

This is a private key.  The first byte is reserved to identify the type of
cryptography.  Lower-case means public key, upper-case means public key, and
the letter identifies which `++acru` to use.

###`++pass`, public key

```
++  pass  ,@                                            ::  public key
```

This is a public key.  The first byte is reserved to identify the type of
cryptography.  Lower-case means public key, upper-case means public key, and
the letter identifies which `++acru` to use.

###`++mace`, private secrets

```
++  mace  (list ,[p=life q=ring])                       ::  private secrets
```

This is a list of the our private keys, indexed by life.  From this we can
generate a `++wund` for actual use.

###`++skin`, encoding stem

```
++  skin  ?(%none %open %fast %full)                    ::  encoding stem
```

This defines the type of encryption used for each message.  `%none` refers
to messages sent in the clear, `%open` refers to signed messages, `%full`
refers to sealed messages, and `%fast` refers to symmetrically encrypted
messages.  See `++acru` for details.

###`++acru`, asymmetric cryptosuite

```
++  acru                                                ::  asym cryptosuite
          $_  ^?  |%                                    ::  opaque object
          ++  as  ^?                                    ::  asym ops
            |%  ++  seal  |=([a=pass b=@ c=@] _@)       ::  encrypt to a
                ++  sign  |=([a=@ b=@] _@)              ::  certify as us
                ++  sure  |=([a=@ b=@] *(unit ,@))      ::  authenticate from us
                ++  tear  |=  [a=pass b=@]              ::  accept from a 
                          *(unit ,[p=@ q=@])            ::
            --                                          ::
          ++  de  |+([a=@ b=@] *(unit ,@))              ::  symmetric de, soft
          ++  dy  |+([a=@ b=@] _@)                      ::  symmetric de, hard
          ++  en  |+([a=@ b=@] _@)                      ::  symmetric en
          ++  ex  ^?                                    ::  export
            |%  ++  fig  _@uvH                          ::  fingerprint
                ++  pac  _@uvG                          ::  default passcode
                ++  pub  *pass                          ::  public key
                ++  sec  *ring                          ::  private key
            --
          ++  nu  ^?                                    ::  reconstructors
             |%  ++  pit  |=([a=@ b=@] ^?(..nu))        ::  from [width seed]
                 ++  nol  |=(a=@ ^?(..nu))              ::  from naked ring
                 ++  com  |=(a=@ ^?(..nu))              ::  from naked pass
            --
          --
```

This is an opaque interface for a general asymmetric cryptosuite.  Any form
of asymmetric cryptography can be dropped in to be used instead of the default.
Right now, there are two cryptosuites, `++crua`, which is your standard RSA,
and `++crub`, which is elliptic curve crypto but is mostly stubbed out at the
moment.

####`++as:acru`, asymmetric operations

```
          ++  as  ^?                                    ::  asym ops
            |%  ++  seal  |=([a=pass b=@ c=@] _@)       ::  encrypt to a
                ++  sign  |=([a=@ b=@] _@)              ::  certify as us
                ++  sure  |=([a=@ b=@] *(unit ,@))      ::  authenticate from us
                ++  tear  |=  [a=pass b=@]              ::  accept from a 
                          *(unit ,[p=@ q=@])            ::
            --                                          ::
```

This is the core that defines the standard asymmetric cryptography
operations.

`++seal:as:acru` allows us to send a message encrypted with someone's public
key so that only they may read it.  If Alice seals a message with Bob's public
key, then she can be sure that Bob is the only one who can read it.  This is
associated with the `++skin` `%full`.

`++sign:as:acru` allows us to sign a message with our private key so that
others can verify that we sent the message.  If Alice signs a message with her
private key, then Bob can verify with her public key that it was indeed Alice
who sent it.  This is associated with the `++skin` `%open`.

`++sure:as:acru` is the dual to `++sign:as:acru`.  It allows us to verify that
a message we have received is indeed from the claimed sender.  If Alice sends a
message with her private key, then Bob can use this arm to verify that it was
indeed Alice who sent it.  This is associated with the `++skin` `%open`.

`++tear:as:acru` is the dual to `++seal:as:acru`.  It allows us to read a
message that we can be sure is only read by us.  If Alice seals a message with
Bob's public key, then Bob can use this arm to read it.  This is associated
with the `++skin` `%full`.

####`++de:acru`, `++dy:acru`, and `++en:acru`, symmetric encryption/decryption

```
          ++  de  |+([a=@ b=@] *(unit ,@))              ::  symmetric de, soft
          ++  dy  |+([a=@ b=@] _@)                      ::  symmetric de, hard
          ++  en  |+([a=@ b=@] _@)                      ::  symmetric en
```

Symmetric encryption is associated with the `++skin` `%fast`.

`++de:acru` decrypts a message with a symmetric key, returning `~` on failure
and `[~ u=data]` on success.

`++dy:acru` decrypts a message with a symmetric key, crashing on failure.  This
should almost always be defined as, and should always be semantically
equivalent to, `(need (de a b))`.

`++en:acru` encrypts a message with a symmetric key.

####`++ex:acru`, exporting data

```
          ++  ex  ^?                                    ::  export
            |%  ++  fig  _@uvH                          ::  fingerprint
                ++  pac  _@uvG                          ::  default passcode
                ++  pub  *pass                          ::  public key
                ++  sec  *ring                          ::  private key
            --
```

`++fig:ex:acru` is our fingerprint, usually a hash of our public key.  This is
used, for example, in `++zeno`, where every carrier owner's fingerprint is
stored so that we can ensure that carriers are indeed owned by their owners

`++pac:ex:acru` is our default passcode, which is unused at present.

`++pub:ex:acru` is the `++pass` form of our public key.

`++sec:ex:acru` is the `++ring` form of our private key.

####`++nu:acru`, reconstructors

```
          ++  nu  ^?                                    ::  reconstructors
             |%  ++  pit  |=([a=@ b=@] ^?(..nu))        ::  from [width seed]
                 ++  nol  |=(a=@ ^?(..nu))              ::  from naked ring
                 ++  com  |=(a=@ ^?(..nu))              ::  from naked pass
            --
```

These arms allow us to reconstruct a `++acru` from basic data.

`++pit:nu:acru` constructs a `++acru` from the width of our intended key and
seed entropy.  This is usually used in the initial construction of the
`++acru`.

`++nol:nu:acru` constructs a `++acru` from a "naked ring", meaning a `++ring`
without the initial byte identifying the type of crypto.  There is often a
helper arm that that wraps this; see `++weur` for `++crua` and `++wear` for
`++crub`.

`++com:nu:acru` constructs a `++acru` from a "naked pass", meaning a `++ring`
without the initial byte identifying the type of crypto.  There is often a
helper arm that that wraps this; see `++haul` for `++crua` and `++hail` for
`++crub`.

###`++will`, certificate

```
++  will  (list deed)                                   ::  certificate
```

This is a list of deeds associated with the current ship.  There should be
an item in this list for every ship from this point up in the hierarchy times
the number of lives that each ship has had.  For example, ~hoclur-bicrel may
have a will with three items: one for itself, one for ~tasruc (who issued
~hoclur-bicrel's deed) and one for ~tug (who issued ~tasruc's deed).

###`++deed`, identity

```
++  deed  ,[p=@ q=step r=?]                             ::  sig, stage, fake?
```

`p` is the signature of a particular deed, which is a signed copy of `q`.

`q` is the stage in the identity.

`r` is true if we're working on a fake network, where we don't check that the
carrier fingerprints are correct.  This allows us to create fake networks for
development without interfering with the real network.

###`++step`, identity stage

```
++  step  ,[p=bray q=gens r=pass]                       ::  identity stage
```

This is a single stage in our identity.  Thus, this is specific to a single
life in a single ship.  Everything in here may change between lives.

`p`

`q`

`r` is the public key for this stage in the identity.

###`++bray`

```
++  bray  ,[p=life q=(unit life) r=ship s=@da]          ::  our parent us now
```

XXX

###`++gens`, general identity

```
++  gens  ,[p=lang q=gcos]                              ::  general identity
```

`p` is the IETF language code for the preferred language of this identity.
This is unused at the moment, but in the future text should be localized based
on this.

`q` is the description of the ship.

###`++gcos`, identity description

```
++  gcos                                                ::  id description
          $%  [%czar ~]                                 ::  8-bit ship
              [%duke p=what]                            ::  32-bit ship
              [%earl p=@t]                              ::  64-bit ship
              [%king p=@t]                              ::  16-bit ship
              [%pawn p=(unit ,@t)]                      ::  128-bit ship
          ==                                            ::
```

This is the description of the identity of a ship.  Most types of identity have
a `@t` field, which is their human-readable name.  The identity of a `%duke` is
more involved.

A `%czar`, a carrier, is a ship with an 8-bit address.  Thus, there are only
256 carriers.  These are at the top of the namespace hierarchy, and the
fingerprint of each carrier is stored in `++zeno`.  These are the "senators" of
Urbit.

A `%king`, a cruiser, is a ship with a 16-bit address.  Thus, there are 65,536
cruisers.  Each carrier may issue 256 cruisers.  These are the infrastructure
of Urbit.

A `%duke`, a destroyer, is a ship with a 32-bit address.  Thus, there are
4,294,967,296 destroyers.  Each cruiser may issue 65,536 cruisers.  These are
the individuals of Urbit.

A `%earl`, a yacht, is a ship with a 64-bit address.  Thus, there are
18,446,744,073,709,551,616 yachts.  Each destroyer may issue 4,294,967,296
yachts.  These are the devices of Urbit.

A `%pawn`, a submarine, is a ship with a 128-bit address.  Thus, there are a
lot of submarines.  The chance of random name collision is negligible, so
submarines are not issued by any ship.  They must simply assert their presence,
and they are all considered children of ~zod.  This is the underworld of Urbit,
where anonymity reigns supreme.

###`++what`, logical destroyer identity

```
++  what                                                ::  logical identity
          $%  [%anon ~]                                 ::  anonymous
              [%lady p=whom]                            ::  female person ()
              [%lord p=whom]                            ::  male person []
              [%punk p=sect q=@t]                       ::  opaque handle ""
          ==                                            ::
```

This is the logical identity of a destroyer.

A `%anon` is a completely anonymous destroyer.  The difference between this and
a submarine is that a submarine is ephemeral while a `%anon` destroyer is not.
Thus, we may not know who ~hoclur-bicrel is, but we do know that it's always
the same person.

A `%lady` is a female person.  The name used here should be a real name.

A `%lord` is a male person.  The name used here should be a real name.

A `%punk` is a person who is identified only by a handle.

###`++whom`, real person

```
++  whom  ,[p=@ud q=govt r=sect s=name]                 ::  year/govt/id
```

Ths is the information associated with a real person.  It is mostly information
that could be observed with the briefest of interactions.

`p` is the birth year.

`q` is the location of a user, usually of the form "country/zip".

`r` is the sect of the user.

`s` is the real name of the person.


###`++govt`

```
++  govt  path                                          ::  country/postcode
```

This is the location of the user, usually of the form "country/zip".

###`++sect`

```
++  sect  ?(%black %blue %red %orange %white)           ::  banner
```

XXX

###`++name`

```
++  name  ,[p=@t q=(unit ,@t) r=(unit ,@t) s=@t]        ::  first mid/nick last
```

This is the given name, possible middle name/initial, possible nickname, and
surname of a user.

packet format
-------------

`++go`, PKI engine
------------------

###`++as`, per server

####`++born`, register user

#####`++lax`, per client

`++pu`, packet pump
-------------------

`++am`, protocol engine
-----------------------

###`++um`, per server

####`++ho`, per friend

#####`++la`, per packet

protocol vane
-------------

