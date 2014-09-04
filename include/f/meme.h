/* include/meme.h
**
** This file is in the public domain.
*/
  /**  Prefix definitions:
  ***
  ***  u2_ca_: fundamental allocators.
  ***  u2_cc_: constants.
  ***  u2_ch_: HAMT hash tables.
  ***  u2_ci_: noun constructors
  ***  u2_cj_: jets.
  ***  u2_ck*: direct jet calls (modern C convention)
  ***  u2_cm_: system management etc.
  ***  u2_cn_: nock interpreter.
  ***  u2_co_: fundamental macros.
  ***  u2_cq*: direct jet calls (archaic C convention)
  ***  u2_cr_: read functions which never bail out.
  ***  u2_cs_: structures and definitions.
  ***  u2_ct_: tracing.
  ***  u2_cw_: direct jet calls (core noun convention)
  ***  u2_cx_: read functions which do bail out.
  ***  u2_cz_: memoization.
  ***
  ***  u2_cr_, u2_cx_ functions use retain conventions; the caller
  ***  retains ownership of passed-in nouns, the callee preserves 
  ***  ownership of returned nouns.
  ***
  ***  Unless documented otherwise, all other functions use transfer 
  ***  conventions; the caller logically releases passed-in nouns, 
  ***  the callee logically releases returned nouns.
  ***
  ***  In general, exceptions to the transfer convention all occur
  ***  when we're using a noun as a key.
  **/

  /**  Subordinate includes.
  **/
    /** c3: the C layer.
    **/
#     include "c/portable.h"
#     include "c/tune.h"
#     include "c/types.h"
#     include "c/defs.h"
#     include "c/motes.h"
#     include "c/comd.h"

  /**  Nock-specific typedefs.
  **/
    /* u2_yes, u2_no, u2_nul;
    **
    **   Our Martian booleans and list terminator; empty string; not a noun.
    */
#     define u2_yes   0
#     define u2_no    1
#     define u2_nul   0
#     define u2_blip  0

    /* Tools for Martian booleans.
    */
#     define u2_so(x)      (u2_yes == (x))
#     define u2_ne(x)      (u2_no == (x))
#     define u2_say(x)     ( (x) ? u2_yes : u2_no )
#     define u2_not(x)     ( (x == u2_yes) ? u2_no : u2_yes )
#     define u2_and(x, y)  ( (u2_so(x) && u2_so(y)) ? u2_yes : u2_no )
#     define u2_or(x, y)   ( (u2_so(x) || u2_so(y)) ? u2_yes : u2_no )

    /* Word axis macros.  For 31-bit axes only.
    */
      /* u2_ax_dep(): number of axis bits.
      */
#       define u2_ax_dep(a_w)   (c3_bits_word(a_w) - 1)

      /* u2_ax_cap(): root axis, 2 or 3.
      */
#       define u2_ax_cap(a_w)   (0x2 | (a_w >> (u2_ax_dep(a_w) - 1)))

      /* u2_ax_mas(): remainder after cap.
      */
#       define u2_ax_mas(a_w) \
          ( (a_w & ~(1 << u2_ax_dep(a_w))) | (1 << (u2_ax_dep(a_w) - 1)) )

      /* u2_ax_peg(): connect two axes.
      */
#       define u2_ax_peg(a_w, b_w) \
          ( (a_w << u2_ax_dep(b_w)) | (b_w &~ (1 << u2_ax_dep(b_w))) )

    /* Conventional axes for gate call.
    */
#     define u2_cv_pay      3       //  payload
#     define u2_cv_sam      6       //  sample
#       define u2_cv_sam_1  6
#       define u2_cv_sam_2  12
#       define u2_cv_sam_3  13
#       define u2_cv_sam_4  24
#       define u2_cv_sam_5  25
#       define u2_cv_sam_6  26
#       define u2_cv_sam_12 52
#       define u2_cv_sam_13 53
#       define u2_cv_sam_7  27
#     define u2_cv_con      7       //  context
#     define u2_cv_con_2    14      //  context
#     define u2_cv_con_3    15      //  context
#     define u2_cv_con_sam  30      //  sample in gate context
#     define u2_cv_noc      2       //  deprecated
#     define u2_cv_bat      2       //  battery

  /** Aliases - selective and syntactically unique.
  **/
#   define u2h(som)          u2_cx_h(som)
#   define u2t(som)          u2_cx_t(som)
#   define u2at(axe, som)    u2_cx_at(axe, som)

#   define u2nc(a, b)        u2_ci_cell(a, b)
#   define u2nt(a, b, c)     u2_ci_trel(a, b, c)
#   define u2nq(a, b, c, d)  u2_ci_qual(a, b, c, d)

#   define u2du(som)         (u2_cr_du(som))
#   define u2ud(som)         (u2_cr_ud(som))

#   define u2k(som)          u2_ca_gain(som)
#   define u2z(som)          u2_ca_lose(som)


  /** Tuning and configuration.
  **/
#   define u2_cc_fbox_no  28

#   undef U2_MEMORY_DEBUG
#   ifdef U2_MEMORY_DEBUG
#     define  u2_leak_on(x) (COD_w = x)
        extern  c3_w COD_w;
#     define  u2_leak_off  (COD_w = 0)
#   endif


  /** Data structures.
  **/
    /* u2_noun: tagged pointer.
    **
    **  If bit 31 is 0, a u2_noun is a direct 31-bit atom ("cat").
    **  If bit 31 is 1 and bit 30 0, an indirect atom ("pug").
    **  If bit 31 is 1 and bit 30 1, an indirect cell ("pom").
    **
    ** Bits 0-29 are a word offset against u2_Loom.
    */
      typedef c3_w    u2_noun;

    /* u2_none - out-of-band noun.
    */
#     define u2_none  (u2_noun)0xffffffff

    /* Informative typedefs.  Use if you like.
    */
      typedef u2_noun u2_atom;              //  must be atom
      typedef u2_noun u2_term;              //  @tas
      typedef u2_noun u2_mote;              //  @tas
      typedef u2_noun u2_cell;              //  must be cell
      typedef u2_noun u2_trel;              //  must be triple
      typedef u2_noun u2_qual;              //  must be quadruple
      typedef u2_noun u2_quin;              //  must be quintuple
      typedef u2_noun u2_bean;              //  loobean: 0 == u2_yes, 1 == u2_no
      typedef u2_noun u2_weak;              //  may be u2_none

    /* u2_atom, u2_cell: logical atom and cell structures.
    */
      typedef struct {
        c3_w mug_w;
      } u2_cs_noun;

      typedef struct {
        c3_w mug_w;
        c3_w len_w;
        c3_w buf_w[0];
      } u2_cs_atom;

      typedef struct {
        c3_w    mug_w;
        u2_noun hed; 
        u2_noun tel;
      } u2_cs_cell;

    /* Inside a noun.
    */
#     define u2_co_is_cat(som)    (((som) >> 31) ? u2_no : u2_yes)
#     define u2_co_is_dog(som)    (((som) >> 31) ? u2_yes : u2_no)

#     define u2_co_is_pug(som)    ((2 == ((som) >> 30)) ? u2_yes : u2_no)
#     define u2_co_is_pom(som)    ((3 == ((som) >> 30)) ? u2_yes : u2_no)
#     define u2_co_to_off(som)    ((som) & 0x3fffffff)
#     define u2_co_to_ptr(som)    (u2_co_into(u2_co_to_off(som)))
#     define u2_co_to_pug(off)    (off | 0x80000000)
#     define u2_co_to_pom(off)    (off | 0xc0000000)

#     define u2_co_is_atom(som)    u2_or(u2_co_is_cat(som), \
                                         u2_co_is_pug(som))
#     define u2_co_is_cell(som)    u2_co_is_pom(som)
#     define u2_co_de_twin(dog, dog_w)  ((dog & 0xc0000000) | u2_co_outa(dog_w))

#     define u2_co_h(som) \
        ( u2_so(u2_co_is_cell(som)) \
           ? ( ((u2_cs_cell *)u2_co_to_ptr(som))->hed )\
           : u2_cm_bail(c3__exit) )

#     define u2_co_t(som) \
        ( u2_so(u2_co_is_cell(som)) \
           ? ( ((u2_cs_cell *)u2_co_to_ptr(som))->tel )\
           : u2_cm_bail(c3__exit) )

  /**  Straightforward implementation of the classic Bagwell 
  ***  HAMT (hash array mapped trie), using a mug hash.
  ***
  ***  Because a mug is 31 bits, the root table is 64 wide.
  ***  Thereupon 5 bits each are warm for each layer.  The
  ***  final leaf is simply a linear search.
  ***
  ***  We store an extra "freshly warm" bit for a simple
  ***  clock-algorithm reclamation policy, not yet implemented.
  ***  Search "clock algorithm" to figure it out.
  **/
    /* u2_ch_slot: map slot. 
    **
    **   Either a key-value cell or a loom offset, decoded as a pointer 
    **   to a u2_ch_node.  Matches the u2_noun format - coordinate with
    **   meme.h.  The top two bits are:
    **
    **     00 - empty (in the root table only)
    **     01 - table
    **     02 - entry, stale
    **     03 - entry, fresh
    */
      typedef c3_w u2_ch_slot;

    /* u2_ch_node: map node.
    */
      typedef struct {
        c3_w       map_w;
        u2_ch_slot sot_w[0];
      } u2_ch_node;

    /* u2_ch_root: hash root table, with future-proof clock.
    */
      typedef struct {
        c3_w       clk_w;
        u2_ch_slot sot_w[64];
      } u2_ch_root;

    /* u2_ch_buck: bottom bucket.
    */
      typedef struct {
        c3_w    len_w;
        u2_noun kev[0];
      } u2_ch_buck;

  /**  HAMT macros.
  ***
  ***  Coordinate with u2_noun definition!
  **/
    /* u2_ch_slot_is_null(): yes iff slot is empty
    ** u2_ch_slot_is_noun(): yes iff slot contains a key/value cell
    ** u2_ch_slot_is_node(): yes iff slot contains a subtable/bucket
    ** u2_ch_slot_is_warm(): yes iff fresh bit is set
    ** u2_ch_slot_to_node(): slot to node pointer
    ** u2_ch_node_to_slot(): node pointer to slot
    ** u2_ch_slot_to_noun(): slot to cell
    ** u2_ch_noun_to_slot(): cell to slot
    */
#     define  u2_ch_slot_is_null(sot)  ((0 == ((sot) >> 30)) ? u2_yes : u2_no)
#     define  u2_ch_slot_is_node(sot)  ((1 == ((sot) >> 30)) ? u2_yes : u2_no)
#     define  u2_ch_slot_is_noun(sot)  ((1 == ((sot) >> 31)) ? u2_yes : u2_no)
#     define  u2_ch_slot_is_warm(sot)  (((sot) & 0x40000000) ? u2_yes : u2_no)
#     define  u2_ch_slot_to_node(sot)  (u2_co_into((sot) & 0x3fffffff))
#     define  u2_ch_node_to_slot(ptr)  (u2_co_outa(ptr) | 0x40000000)
#     define  u2_ch_slot_to_noun(sot)  (0x40000000 | (sot))
#     define  u2_ch_noun_to_slot(som)  (som)
#     define  u2_ch_noun_be_warm(sot)  ((sot) | 0x40000000)
#     define  u2_ch_noun_be_cold(sot)  ((sot) & ~0x40000000)

    /* u2_cs_box: classic allocation box.
    **
    ** The box size is also stored at the end of the box in classic
    ** bad ass malloc style.  Hence a box is:
    **
    **    ---
    **    siz_w
    **    use_w
    **    if(debug) cod_w
    **      user data
    **    siz_w
    **    ---
    **
    ** Do not attempt to adjust this structure!
    */
      typedef struct _u2_cs_box {
        c3_w   siz_w;                       // size of this box
        c3_w   use_w;                       // reference count; free if 0
#       ifdef U2_MEMORY_DEBUG
          c3_w   cod_w;                     // tracing code
#       endif
      } u2_cs_box;

#     define u2_co_boxed(len_w)  (len_w + c3_wiseof(u2_cs_box) + 1)
#     define u2_co_boxto(box_v)  ( (void *) \
                                   ( ((c3_w *)(void*)(box_v)) + \
                                     c3_wiseof(u2_cs_box) ) )
#     define u2_co_botox(tox_v)  ( (struct _u2_cs_box *) \
                                   (void *) \
                                   ( ((c3_w *)(void*)(tox_v)) - \
                                      c3_wiseof(u2_cs_box)  ) )

    /* u2_cs_fbox: free node in heap.  Sets minimum node size.
    **
    */
      typedef struct _u2_cs_fbox {
        u2_cs_box           box_u;
        struct _u2_cs_fbox* pre_u;
        struct _u2_cs_fbox* nex_u;
      } u2_cs_fbox;

#     define u2_cc_minimum   (1 + c3_wiseof(u2_cs_fbox))

    /* u2_cs_hook: core map from hint.
    */
      typedef struct _u2_cs_hook {
        c3_c*               nam_c;
        c3_l                axe_l;
        struct _u2_cs_hook* nex_u;
      } u2_cs_hook;

    /* u2_cs_hood: battery as instance of core.
    */
      typedef struct _u2_cs_hood {
        c3_l                 mug_l;     //  battery mug
        c3_w                 len_w;     //  dynamic array length
        struct _u2_cs_harm** ray_u;     //  dynamic array by axis
        struct _u2_cs_hook*  huk_u;     //  hooks if any
        struct _u2_cs_hood*  nex_u;     //  next in this core
      } u2_cs_hood;

    /* u2_cs_harm: jet arm.
    */
      typedef struct _u2_cs_harm {
        c3_c*     fcs_c;                //  `.axe` or name
        u2_noun (*fun_f)(u2_noun);      //  0 or compute function / semitransfer
        u2_bean (*val_f)(u2_noun);      //  0 or validate function - retain
        c3_o      ice;                  //  perfect (don't test)
        c3_o      tot;                  //  total (never punts)
        c3_d      paw_d;                //  jammed part memo formula, as c3_d
        c3_l      axe_l;                //  computed/discovered axis
      } u2_cs_harm;

    /* u2_cs_core: driver definition.
    */
      typedef struct _u2_cs_core {
        c3_c*               cos_c;      //  control string
        struct _u2_cs_harm* arm_u;      //  blank-terminated static list
        struct _u2_cs_core* dev_u;      //  blank-terminated static list
        struct _u2_cs_core* par_u;      //  parent pointer
        struct _u2_cs_hood* hud_u;      //  dynamic instance list
        c3_l                jax_l;      //  index in global dashboard
      } u2_cs_core;

    /* u2_cs_dash, u2_Dash, u2D: jet dashboard singleton
    */
      typedef struct _u2_cs_dash {
        u2_cs_core* dev_u;              //  null-terminated static list
        c3_l        len_l;              //  dynamic array length
        u2_cs_core* ray_u;              //  dynamic array by axis
      } u2_cs_dash;

      c3_global u2_cs_dash u2_Dash;
#     define u2D u2_Dash


    /* u2_cs_road: contiguous allocation and execution context.
    **
    **  A road is a normal heap-stack system, except that the heap
    **  and stack can point in either direction.  Therefore, inside
    **  a road, we can nest another road in the opposite direction.
    **
    **  When the opposite road completes, its heap is left on top of
    **  the opposite heap's stack.  It's no more than the normal 
    **  behavior of a stack machine for all subcomputations to push
    **  their results, internally durable, on the stack.
    **
    **  The performance tradeoff of "leaping" - reversing directions 
    **  in the road - is that if the outer computation wants to
    **  preserve the results of the inner one, not just use them for
    **  temporary purposes, it has to copy them.  
    **
    **  This is a trivial cost in some cases, a prohibitive case in 
    **  others.  The upside, of course, is that all garbage accrued
    **  in the inner computation is discarded at zero cost.
    **
    **  The goal of the road system is the ability to *layer* memory
    **  models.  If you are allocating on a road, you have no idea
    **  how deep within a nested road system you are - in other words,
    **  you have no idea exactly how durable your result may be.
    **  But free space is never fragmented within a road.
    **
    **  Roads do not reduce the generality or performance of a memory
    **  system, since even the most complex GC system can be nested
    **  within a road at no particular loss of performance - a road
    **  is just a block of memory.  The cost of road allocation is,
    **  at least in theory, the branch prediction hits when we try to
    **  decide which side of the road we're allocating on.  The road
    **  system imposes no pointer read or write barriers, of course.
    **
    **  The road can point in either direction.  If cap > hat, it
    **  looks like this ("north"):
    **
    **  0           rut   hat                                    ffff
    **  |            |     |                                       |
    **  |~~~~~~~~~~~~-------##########################+++++++$~~~~~|
    **  |                                             |      |     |
    **  0                                            cap    mat  ffff
    **
    **  Otherwise, it looks like this ("south"):
    ** 
    **  0           mat   cap                                    ffff
    **  |            |     |                                       |
    **  |~~~~~~~~~~~~$++++++##########################--------~~~~~|
    **  |                                             |      |     |
    **  0                                            hat    rut  ffff
    **
    **  Legend: - is durable storage (heap); + is temporary storage
    **  (stack); ~ is deep storage (immutable); $ is the allocation block;
    **  # is free memory.
    **
    **  Pointer restrictions: pointers stored in + can point anywhere,
    **  except to more central pointers in +.  (Ie, all pointers from
    **  stack to stack must point downward on the stack.)  Pointers in
    **  - can only point to - or ~; pointers in ~ only point to ~.
    **
    **  To "leap" is to create a new inner road in the ### free space.
    **  but in the reverse direction, so that when the inner road
    **  "falls" (terminates), its durable storage is left on the
    **  temporary storage of the outer road.
    **
    **  In all cases, the pointer in a u2_noun is a word offset into
    **  u2H, the top-level road.
    */
      typedef struct _u2_cs_road {
        struct _u2_cs_road* par_u;          //  parent road
        struct _u2_cs_road* kid_u;          //  child road list
        struct _u2_cs_road* nex_u;          //  sibling road

        c3_w* cap_w;                      //  top of transient region
        c3_w* hat_w;                      //  top of durable region
        c3_w* mat_w;                      //  bottom of transient region
        c3_w* rut_w;                      //  bottom of durable region
#if 0
          c3_w* gar_w;                      //  bottom of guard region (future)
          c3_w* rag_w;                      //  top of guard region (future)

          c3_w  pad_w[4];                   //  future interesting info
#endif

        struct {                            //  escape buffer
          union {
            jmp_buf buf;
            c3_w buf_w[256];                //  futureproofing
          };
        } esc;

        struct {                            //  allocation pools
          u2_cs_fbox* fre_u[u2_cc_fbox_no]; //  heap by node size log
#         ifdef U2_MEMORY_DEBUG
            c3_w liv_w;                     //  number of live words
#         endif
        } all;

        struct {                            //  jet dashboard
          u2_ch_root* har_u;                //  jet index by 
        } jed;

        struct {                            //  namespace
          u2_noun fly;                      //  $+(* (unit))
        } ski;

        struct {                            //  need state
          u2_noun nyd;                      //  (list path)
        } net;

        struct {                            //  trace stack
          u2_noun tax;                      //  (list ,*)
        } bug;

        struct {                            //  profiling stack
          u2_noun don;                      //  (list ,*)
        } pro;

        struct {                            //  memoization
          u2_ch_root* har_u;                //  (map (pair term noun) noun)
        } cax;
      } u2_cs_road;
      typedef u2_cs_road u2_road;


  /** Globals.
  **/
    /* u2_Loom: base of loom, as a word pointer.
    */
      c3_global c3_w* u2_Loom;
#       define u2L  u2_Loom

    /* u2_Home / u2H: root of thread.  Always north.
    */
      c3_global u2_road* u2_Home;
#       define u2H  u2_Home

    /* u2_Road / u2R: current road (thread-local).
    */
      c3_global u2_road* u2_Road;
#       define u2R  u2_Road

  /**  Macros.
  **/
#     define  u2_co_is_north  ((u2R->cap_w > u2R->hat_w) ? u2_yes : u2_no)
#     define  u2_co_is_south  ((u2_yes == u2_co_is_north) ? u2_no : u2_yes)

#     define  u2_co_open      ( (u2_yes == u2_co_is_north) \
                                  ? (c3_w)(u2R->cap_w - u2R->hat_w) \
                                  : (c3_w)(u2R->hat_w - u2R->cap_w) )

#     define  u2_co_into(x) ((void *)(u2_Loom + (x)))
#     define  u2_co_outa(p) (((c3_w*)(void*)(p)) - u2_Loom)


  /** Functions.
  **/
    /** u2_cx_*: read, but bail with c3__exit on a crash.
    **/
#if 1
#     define u2_cx_h(som)  u2_co_h(som)
#     define u2_cx_t(som)  u2_co_t(som)
#else
      /* u2_cx_h (u2h): head.
      */
        u2_noun
        u2_cx_h(u2_noun som);

      /* u2_cx_t (u2t): tail.
      */
        u2_noun
        u2_cx_t(u2_noun som);
#endif
      /* u2_cx_good(): test for u2_none.
      */
        u2_noun
        u2_cx_good(u2_weak som);

      /* u2_cx_at (u2at): fragment.
      */
        u2_noun
        u2_cx_at(u2_noun axe, u2_noun som);

      /* u2_cx_cell():
      **
      **   Divide `a` as a cell `[b c]`.
      */
        void
        u2_cx_cell(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c);

      /* u2_cx_trel():
      **
      **   Divide `a` as a trel `[b c d]`, or bail.
      */
        void
        u2_cx_trel(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c,
                   u2_noun* d);

      /* u2_cx_qual():
      **
      **   Divide `a` as a quadruple `[b c d e]`.
      */
        void
        u2_cx_qual(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c,
                   u2_noun* d,
                   u2_noun* e);

    /** u2_cr_*: read without ever crashing.
    **/
#if 1
#       define u2_cr_du(a)  u2_co_is_cell(a)
#       define u2_cr_ud(a)  u2_co_is_atom(a)
#else
      /* u2_cr_du(): u2_yes iff `a` is cell.
      */
        u2_bean
        u2_cr_du(u2_noun a);

      /* u2_cr_ud(): u2_no iff `a` is cell.
      */
        u2_bean
        u2_cr_ud(u2_noun a);
#endif

      /* u2_cr_at(): fragment `a` of `b`, or u2_none.
      */
        u2_weak
        u2_cr_at(u2_atom a,
                 u2_weak b);

      /* u2_cr_mean():
      **
      **   Attempt to deconstruct `a` by axis, noun pairs; 0 terminates.
      **   Axes must be sorted in tree order.
      */
        u2_bean
        u2_cr_mean(u2_noun a,
                   ...);

      /* u2_cr_mug():
      **
      **   Compute and/or recall the mug (31-bit hash) of (a).
      */
        c3_w
        u2_cr_mug(u2_noun a);

      /* u2_cr_mug_string():
      **
      **   Compute the mug of `a`, LSB first.
      */
        c3_w
        u2_cr_mug_string(const c3_c *a_c);

      /* u2_cr_mug_words():
      **
      **   Compute the mug of `buf`, `len`, LSW first.
      */
        c3_w
        u2_cr_mug_words(const c3_w *buf_w,
                        c3_w        len_w);

      /* u2_cr_mug_cell():
      **
      **   Compute the mug of `[a b]`.
      */
        c3_w
        u2_cr_mug_cell(u2_noun a,
                       u2_noun b);

      /* u2_cr_mug_trel():
      **
      **   Compute the mug of `[a b c]`.
      */
        c3_w
        u2_cr_mug_trel(u2_noun a,
                       u2_noun b,
                       u2_noun c);

      /* u2_cr_mug_qual():
      **
      **   Compute the mug of `[a b c d]`.
      */
        c3_w
        u2_cr_mug_qual(u2_noun a,
                       u2_noun b,
                       u2_noun c,
                       u2_noun d);

      /* u2_cr_mug_both():
      **
      **   Join two mugs.
      */
        c3_w
        u2_cr_mug_both(c3_w a_w,
                       c3_w b_w);

      /* u2_cr_fing():
      **
      **   Yes iff (a) and (b) are the same copy of the same noun.
      **   (Ie, by pointer equality - u2_cr_sing with false negatives.)
      */
        u2_bean
        u2_cr_fing(u2_noun a,
                   u2_noun b);

      /* u2_cr_fing_cell():
      **
      **   Yes iff `[p q]` and `b` are the same copy of the same noun.
      */
        u2_bean
        u2_cr_fing_cell(u2_noun p,
                        u2_noun q,
                        u2_noun b);

      /* u2_cr_fing_mixt():
      **
      **   Yes iff `[p q]` and `b` are the same copy of the same noun.
      */
        u2_bean
        u2_cr_fing_mixt(const c3_c* p_c,
                        u2_noun     q,
                        u2_noun     b);

      /* u2_cr_fing_trel():
      **
      **   Yes iff `[p q r]` and `b` are the same copy of the same noun.
      */
        u2_bean
        u2_cr_fing_trel(u2_noun p,
                        u2_noun q,
                        u2_noun r,
                        u2_noun b);

      /* u2_cr_fing_qual():
      **
      **   Yes iff `[p q r s]` and `b` are the same copy of the same noun.
      */
        u2_bean
        u2_cr_fing_qual(u2_noun p,
                        u2_noun q,
                        u2_noun r,
                        u2_noun s,
                        u2_noun b);

      /* u2_cr_sing():
      **
      **   Yes iff (a) and (b) are the same noun.
      */
        u2_bean
        u2_cr_sing(u2_noun a,
                   u2_noun b);

      /* u2_cr_sing_c():
      **
      **   Yes iff (b) is the same noun as the C string [a].
      */
        u2_bean
        u2_cr_sing_c(const c3_c* a_c,
                     u2_noun     b);

      /* u2_cr_sing_cell():
      **
      **   Yes iff `[p q]` and `b` are the same noun.
      */
        u2_bean
        u2_cr_sing_cell(u2_noun p,
                        u2_noun q,
                        u2_noun b);

      /* u2_cr_sing_mixt():
      **
      **   Yes iff `[p q]` and `b` are the same noun.
      */
        u2_bean
        u2_cr_sing_mixt(const c3_c* p_c,
                        u2_noun     q,
                        u2_noun     b);

      /* u2_cr_sing_trel():
      **
      **   Yes iff `[p q r]` and `b` are the same noun.
      */
        u2_bean
        u2_cr_sing_trel(u2_noun p,
                        u2_noun q,
                        u2_noun r,
                        u2_noun b);

      /* u2_cr_sing_qual():
      **
      **   Yes iff `[p q r s]` and `b` are the same noun.
      */
        u2_bean
        u2_cr_sing_qual(u2_noun p,
                        u2_noun q,
                        u2_noun r,
                        u2_noun s,
                        u2_noun b);

      /* u2_cr_nord():
      **
      **   Return 0, 1 or 2 if `a` is below, equal to, or above `b`.
      */
        u2_atom
        u2_cr_nord(u2_noun a,
                   u2_noun b);

      /* u2_cr_mold():
      **
      **   Divide `a` as a mold `[b.[p q] c]`.
      */
        u2_bean
        u2_cr_mold(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c);

      /* u2_cr_cell():
      **
      **   Divide `a` as a cell `[b c]`.
      */
        u2_bean
        u2_cr_cell(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c);

      /* u2_cr_trel():
      **
      **   Divide `a` as a trel `[b c]`.
      */
        u2_bean
        u2_cr_trel(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c,
                   u2_noun* d);

      /* u2_cr_qual():
      **
      **   Divide (a) as a qual (b c d e).
      */
        u2_bean
        u2_cr_qual(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c,
                   u2_noun* d,
                   u2_noun* e);

      /* u2_cr_p():
      **
      **   & [0] if [a] is of the form [b *c].
      */
        u2_bean
        u2_cr_p(u2_noun  a,
                u2_noun  b,
                u2_noun* c);

      /* u2_cr_bush():
      **
      **   Factor [a] as a bush [b.[p q] c].
      */
        u2_bean
        u2_cr_bush(u2_noun  a,
                   u2_noun* b,
                   u2_noun* c);

      /* u2_cr_pq():
      **
      **   & [0] if [a] is of the form [b *c d].
      */
        u2_bean
        u2_cr_pq(u2_noun  a,
                 u2_noun  b,
                 u2_noun* c,
                 u2_noun* d);

      /* u2_cr_pqr():
      **
      **   & [0] if [a] is of the form [b *c *d *e].
      */
        u2_bean
        u2_cr_pqr(u2_noun  a,
                  u2_noun  b,
                  u2_noun* c,
                  u2_noun* d,
                  u2_noun* e);

      /* u2_cr_pqrs():
      **
      **   & [0] if [a] is of the form [b *c *d *e *f].
      */
        u2_bean
        u2_cr_pqrs(u2_noun  a,
                   u2_noun  b,
                   u2_noun* c,
                   u2_noun* d,
                   u2_noun* e,
                   u2_noun* f);

      /* u2_cr_met():
      **
      **   Return the size of (b) in bits, rounded up to
      **   (1 << a_y).
      **
      **   For example, (a_y == 3) returns the size in bytes.
      */
        c3_w
        u2_cr_met(c3_y    a_y,
                  u2_atom b);

      /* u2_cr_bit():
      **
      **   Return bit (a_w) of (b).
      */
        c3_b
        u2_cr_bit(c3_w    a_w,
                  u2_atom b);

      /* u2_cr_byte():
      **
      **   Return byte (a_w) of (b).
      */
        c3_y
        u2_cr_byte(c3_w    a_w,
                   u2_atom b);

      /* u2_cr_bytes():
      **
      **   Copy bytes (a_w) through (a_w + b_w - 1) from (d) to (c).
      */
        void
        u2_cr_bytes(c3_w    a_w,
                    c3_w    b_w,
                    c3_y*   c_y,
                    u2_atom d);

      /* u2_cr_chop():
      **
      **   Into the bloq space of `met`, from position `fum` for a
      **   span of `wid`, to position `tou`, XOR from atom `src`
      **   into ray `dst`.
      */
        void
        u2_cr_chop(c3_g    met_g,
                   c3_w    fum_w,
                   c3_w    wid_w,
                   c3_w    tou_w,
                   c3_w*   dst_w,
                   u2_atom src);

      /* u2_cr_mp():
      **
      **   Copy (b) into (a_mp).
      */
        void
        u2_cr_mp(mpz_t   a_mp,
                 u2_atom b);

      /* u2_cr_word():
      **
      **   Return word (a_w) of (b).
      */
        c3_w
        u2_cr_word(c3_w    a_w,
                   u2_atom b);

      /* u2_cr_chub():
      **
      **   Return double-word (a_w) of (b).
      */
        c3_d
        u2_cr_chub(c3_w    a_w,
                   u2_atom b);

      /* u2_cr_words():
      **
      **  Copy words (a_w) through (a_w + b_w - 1) from (d) to (c).
      */
        void
        u2_cr_words(c3_w    a_w,
                    c3_w    b_w,
                    c3_w*   c_w,
                    u2_atom d);

      /* u2_cr_string(): `a`, a text atom, as malloced C string.
      */
        c3_c*
        u2_cr_string(u2_atom a);

      /* u2_cr_tape(): `a`, a list of bytes, as malloced C string.
      */
        c3_y*
        u2_cr_tape(u2_noun a);


    /** System management.
    **/
      /* u2_cm_boot(): make u2R and u2H from `len` words at `adr`.
      */
        void
        u2_cm_boot(c3_p adr_p, c3_w len_w);

      /* u2_cm_trap(): setjmp within road.
      */
#if 0
        u2_bean
        u2_cm_trap(void);
#else
#       define u2_cm_trap() (u2_noun)(setjmp(u2R->esc.buf))
#endif

      /* u2_cm_bail(): bail out.  Does not return.
      **
      **  Bail motes:
      **
      **    %exit               ::  semantic failure
      **    %evil               ::  bad crypto
      **    %intr               ::  interrupt
      **    %fail               ::  execution failure
      **    %foul               ::  assert failure
      **    %need               ::  network block
      **    %meme               ::  out of memory
      */ 
        c3_i
        u2_cm_bail(c3_m how_m);

      /* u2_cm_error(): bail out with %exit, ct_pushing error.
      */
        c3_i
        u2_cm_error(c3_c* str_c);

      /* u2_cm_grab(): garbage-collect memory.  Asserts u2R == u2H.
      */
        void
        u2_cm_grab(void);

      /* u2_cm_check(): checkpoint memory to file.  Asserts u2R == u2H.
      */
        void
        u2_cm_check(void);

      /* u2_cm_fall(): return to parent road.
      */
        void
        u2_cm_fall(void);

      /* u2_cm_leap(): advance to inner road.
      */
        void
        u2_cm_leap(void);

      /* u2_cm_golf(): record cap length for u2_flog().
      */
        c3_w
        u2_cm_golf(void);

      /* u2_cm_flog(): pop the cap.
      **
      **    A common sequence for inner allocation is:
      **
      **    c3_w gof_w = u2_cm_golf();
      **    u2_cm_leap();
      **    //  allocate some inner stuff...
      **    u2_cm_fall();
      **    //  inner stuff is still valid, but on cap
      **    u2_cm_flog(gof_w);
      **
      ** u2_cm_flog(0) simply clears the cap.
      */
        void
        u2_cm_flog(c3_w gof_w);

      /* u2_cm_water(): produce high and low watermarks.  Asserts u2R == u2H.
      */
        void
        u2_cm_water(c3_w *low_w, c3_w *hig_w);


    /**  Allocation.
    **/
      /* Basic allocation.
      */
        /* u2_ca_walloc(): allocate storage measured in words.
        */
          void*
          u2_ca_walloc(c3_w len_w);

        /* u2_ca_malloc(): allocate storage measured in bytes.
        */
          void*
          u2_ca_malloc(c3_w len_w);

        /* u2_ca_free(): free storage.
        */
          void
          u2_ca_free(void* lag_v);

        /* u2_ca_wealloc(): word realloc.
        */
          void*
          u2_ca_wealloc(void* lag_v, c3_w len_w);

        /* u2_ca_realloc(): byte realloc.
        */
          void*
          u2_ca_realloc(void* lag_v, c3_w len_w);


      /* Reference and arena control.
      */
        /* u2_ca_gain(): gain and/or copy juniors.
        */
          u2_weak
          u2_ca_gain(u2_weak som);

        /* u2_ca_lose(): lose a reference.
        */
          void
          u2_ca_lose(u2_weak som);

        /* u2_ca_use(): reference count.
        */
          c3_w
          u2_ca_use(u2_noun som);

        /* u2_ca_mark(): mark for gc, returning allocated words.
        */
          c3_w
          u2_ca_mark(u2_noun som);

        /* u2_ca_sweep(): sweep after gc, freeing, matching live count.
        */
          c3_w
          u2_ca_sweep(c3_w liv_w);


      /* Atoms from proto-atoms.
      */
        /* u2_ca_slab(): create a length-bounded proto-atom.
        */
          c3_w*
          u2_ca_slab(c3_w len_w);

        /* u2_ca_slaq(): u2_ca_slaq() with a defined blocksize.
        */
          c3_w*
          u2_ca_slaq(c3_g met_g, c3_w len_w);

        /* u2_ca_malt(): measure and finish a proto-atom.
        */
          u2_noun
          u2_ca_malt(c3_w* sal_w);

        /* u2_ca_moot(): finish a pre-measured proto-atom; dangerous.
        */
          u2_noun
          u2_ca_moot(c3_w* sal_w);

        /* u2_ca_mint(): finish a measured proto-atom.
        */
          u2_noun
          u2_ca_mint(c3_w* sal_w, c3_w len_w);


      /* General constructors.
      */
        /* u2_ci_words():
        **
        **   Copy [a] words from [b] into an atom.
        */
          u2_noun
          u2_ci_words(c3_w        a_w,
                      const c3_w* b_w);

        /* u2_ci_bytes():
        **
        **   Copy `a` bytes from `b` to an LSB first atom.
        */
          u2_noun
          u2_ci_bytes(c3_w        a_w,
                      const c3_y* b_y);

        /* u2_ci_mp():
        **
        **   Copy the GMP integer `a` into an atom, and clear it.
        */
          u2_noun
          u2_ci_mp(mpz_t a_mp);

        /* u2_ci_vint():
        **
        **   Create `a + 1`.
        */
          u2_noun
          u2_ci_vint(u2_noun a);

        /* u2_ci_cell():
        **
        **   Produce the cell `[a b]`.
        */
          u2_noun
          u2_ci_cell(u2_noun a, u2_noun b);

        /* u2_ci_trel():
        **
        **   Produce the triple `[a b c]`.
        */
          u2_noun
          u2_ci_trel(u2_noun a, u2_noun b, u2_noun c);

        /* u2_ci_qual():
        **
        **   Produce the cell `[a b c d]`.
        */
          u2_noun
          u2_ci_qual(u2_noun a, u2_noun b, u2_noun c, u2_noun d);

        /* u2_ci_string():
        **
        **   Produce an LSB-first atom from the C string `a`.
        */
          u2_noun
          u2_ci_string(const c3_c* a_c);

        /* u2_ci_molt():
        **
        **   Mutate `som` with a 0-terminated list of axis, noun pairs.
        **   Axes must be cats (31 bit).
        */
          u2_noun 
          u2_ci_molt(u2_noun som, ...);

        /* u2_ci_chubs():
        **
        **   Construct `a` double-words from `b`, LSD first, as an atom.
        */
          u2_atom
          u2_ci_chubs(c3_w        a_w,
                      const c3_d* b_d);

        /* u2_ci_tape(): from a C string, to a list of bytes.
        */
          u2_atom
          u2_ci_tape(const c3_c* txt_c);


    /**  Generic computation.
    **/
      /* u2_cn_nock_on(): produce .*(bus fol).
      */
        u2_noun
        u2_cn_nock_on(u2_noun bus, u2_noun fol);

      /* u2_cn_slam_on(): produce (gat sam).
      */
        u2_noun
        u2_cn_slam_on(u2_noun gat, u2_noun sam);

      /* u2_cn_kick_on(): fire `gat` without changing the sample.
      */
        u2_noun
        u2_cn_kick_on(u2_noun gat);

      /* u2_cn_nock_un(): produce .*(bus fol), as ++toon.
      */
        u2_noun
        u2_cn_nock_un(u2_noun bus, u2_noun fol);

      /* u2_cn_slam_un(): produce (gat sam), as ++toon.
      */
        u2_noun
        u2_cn_slam_un(u2_noun gat, u2_noun sam);

      /* u2_cn_nock_in(): produce .*(bus fol), as ++toon, in namespace.
      */
        u2_noun
        u2_cn_nock_in(u2_noun fly, u2_noun bus, u2_noun fol);

      /* u2_cn_slam_in(): produce (gat sam), as ++toon, in namespace.
      */
        u2_noun
        u2_cn_slam_in(u2_noun fly, u2_noun gat, u2_noun sam);

      /* u2_cn_nock_an(): as slam_in(), but with empty fly.
      */
        u2_noun
        u2_cn_nock_an(u2_noun bus, u2_noun fol);


    /**  Functions.
    ***
    ***  Needs: delete and merge functions; clock reclamation function.
    **/
      /* u2_ch_new(): create hashtable.
      */
        u2_ch_root* 
        u2_ch_new(void);

      /* u2_ch_put(): insert in hashtable.
      **
      ** `key` is RETAINED; `val` is transferred.
      */
        void
        u2_ch_put(u2_ch_root* har_u, u2_noun key, u2_noun val);

      /* u2_ch_get(): read from hashtable.
      **
      ** `key` is RETAINED.
      */
        u2_weak
        u2_ch_get(u2_ch_root* har_u, u2_noun key);

      /* u2_ch_free(): free hashtable.
      */
        void
        u2_ch_free(u2_ch_root* har_u);


    /**  Jets.
    **/
      /* u2_cj_boot(): initialize jet system.
      */
        void
        u2_cj_boot(void);

      /* u2_cj_hook():
      **
      **   Execute hook from core. 
      */
        u2_noun
        u2_cj_hook(u2_noun     cor,
                   const c3_c* tam_c);

      /* u2_cj_find(): battery to driver number, or 0.
      **
      ** `bat` is RETAINED by the caller.
      */
        c3_l
        u2_cj_find(u2_noun bat);

      /* u2_cj_kick(): try to kick by jet.  If no kick, produce u2_none.
      **
      ** `axe` is RETAINED by the caller; `cor` is RETAINED iff there 
      ** is no kick, TRANSFERRED if one.
      */
        u2_weak
        u2_cj_kick(u2_noun cor,
                   u2_noun axe);

      /* u2_cj_kink(): kick either by jet or by nock.
      */
        u2_noun
        u2_cj_kink(u2_noun cor,
                   u2_noun axe);
        
      /* u2_cj_mine(): register core for jets.
      */
        u2_noun
        u2_cj_mine(u2_noun clu,
                   u2_noun cor);

    /** Tracing.
    **/
      /* u2_ct_push(): push on trace stack.
      */
        void
        u2_ct_push(u2_noun mon);

      /* u2_ct_mean(): push `[%mean roc]` on trace stack.
      */
        void
        u2_ct_mean(u2_noun roc);

      /* u2_ct_drop(): drop from meaning stack.
      */
        void
        u2_ct_drop(void);

      /* u2_ct_slog(): print directly.
      */
        void
        u2_ct_slog(u2_noun hod);


    /**  Memoization.
    ***
    ***  The memo cache is keyed by an arbitrary symbolic function
    ***  and a noun argument to that (logical) function.  Functions
    ***  are predefined by C-level callers, but 0 means nock.
    ***
    ***  The memo cache is within its road and dies when it falls.
    ***
    ***  Memo functions RETAIN keys and transfer values.
    **/
      /* u2_cz_find*(): find in memo cache.
      */
        u2_weak u2_cz_find(u2_mote, u2_noun);
        u2_weak u2_cz_find_2(u2_mote, u2_noun, u2_noun);
        u2_weak u2_cz_find_3(u2_mote, u2_noun, u2_noun, u2_noun);
        u2_weak u2_cz_find_4(u2_mote, u2_noun, u2_noun, u2_noun, u2_noun);

      /* u2_cz_save*(): save in memo cache.
      */
        u2_noun u2_cz_save(u2_mote, u2_noun, u2_noun);
        u2_noun u2_cz_save_2(u2_mote, u2_noun, u2_noun, u2_noun);
        u2_noun u2_cz_save_3(u2_mote, u2_noun, u2_noun, u2_noun, u2_noun);
        u2_noun u2_cz_save_4
                  (u2_mote, u2_noun, u2_noun, u2_noun, u2_noun, u2_noun);

      /* u2_cz_uniq(): uniquify with memo cache.
      */
        u2_noun 
        u2_cz_uniq(u2_noun som);


    /* u2_ck: kernel and related functions
    **
    **   All nouns transferred unless otherwise stated.
    */
      /* u2_cka: tier 1 functions
      */
          u2_noun
          u2_cka_add(u2_noun a, u2_noun b);

          u2_noun
          u2_cka_sub(u2_noun a, u2_noun b);

          u2_noun
          u2_cka_mul(u2_noun a, u2_noun b);

          u2_noun
          u2_cka_gth(u2_noun a, u2_noun b);

          u2_bean
          u2_cka_lte(u2_noun a, u2_noun b);

      /* u2_ckb: tier 2 functions
      */
        /* u2_ckb_lent(): length of a list.
        */
          u2_noun
          u2_ckb_lent(u2_noun a);

        /* u2_ckb_weld(): concatenate list `a` before `b`.
        */
          u2_noun
          u2_ckb_weld(u2_noun a, u2_noun b);

        /* u2_ckb_flop(): reverse list `a`.
        */
          u2_noun
          u2_ckb_flop(u2_noun a);

      /* u2_ckc: tier 3 functions
      */
        /* u2_ckc_lsh(): left shift.
        */
          u2_noun
          u2_ckc_lsh(u2_noun a, u2_noun b, u2_noun c);

        /* u2_ckc_rsh(): right shift.
        */
          u2_noun
          u2_ckc_rsh(u2_noun a, u2_noun b, u2_noun c);

      /* u2_ckd: tier 4 functions
      */
        /* u2_ckdb_get(): map get for key `b` in map `a` with u2_none.
        */
          u2_weak
          u2_ckdb_get(u2_noun a, u2_noun b);

        /* u2_ckdb_got(): map get for key `b` in map `a` with bail.
        */
          u2_noun
          u2_ckdb_got(u2_noun a, u2_noun b);

        /* u2_ckdb_put(): map put for key `b`, value `c` in map `a`.
        */
          u2_weak
          u2_ckdb_put(u2_noun a, u2_noun b, u2_noun c);

        /* u2_ckdb_has(): test for get.
        */
          u2_bean
          u2_ckdb_has(u2_noun a, u2_noun b);

        /* u2_ckdb_gas(): list to map.
        */
          u2_noun
          u2_ckdb_gas(u2_noun a, u2_noun b);

        /* u2_ckdi_gas(): list to map.
        */
          u2_noun
          u2_ckdi_gas(u2_noun a, u2_noun b);

        /* u2_ckdi_has(): test for presence.
        */
          u2_bean
          u2_ckdi_has(u2_noun a, u2_noun b);

        /* u2_ckdi_tap(): map/set convert to list.  (solves by_tap also.)
        */
          u2_noun
          u2_ckdi_tap(u2_noun a, u2_noun b);

#define u2_ckd_by_tap(a, b) u2_ckdi_tap(a, b)

      /* u2_cke: tier 5 functions
      */
        /* u2_cke_cue(): expand saved pill.
        */
          u2_noun
          u2_cke_cue(u2_atom a);

        /* u2_cke_jam(): pack noun as atom.
        */
          u2_atom
          u2_cke_jam(u2_noun a);

        /* u2_cke_trip: atom to tape.
        */
          u2_noun
          u2_cke_trip(u2_noun a);

#include "qjet.h"

    /* Symbol composition.  Horrid.
    */
#     define _j2_xd(x)        j2_##x##_d
#     define _j2_xm(x)        j2_##x##_m
#     define _j2_xmc(x)       j2_##x##_mc
#     define _j2_xmy(x)       j2_##x##_my
#     define _j2_xmx(x)       j2_##x##_mx
#     define _j2_xmk(x)       j2_##x##_mk
#     define _j2_xmi(x)       j2_##x##_mi
#     define _j2_xmj(x)       j2_##x##_jets
#     define _j2_xmd(x)       j2_##x##_drivers
#     define _j2_xp(p, x)     j2_##x##_p_##p
#     define _j2_xpc(p, x)    j2_##x##_pc_##p
#     define _j2_xss(x)       #x
#     define _j2_xs(x)        _j2_xss(x)

#     define _j2_qd(x)        _j2_xd(x)
#     define _j2_qm(x)        _j2_xm(x)
#     define _j2_qmc(x)       _j2_xmc(x)
#     define _j2_qmy(x)       _j2_xmy(x)
#     define _j2_qmx(x)       _j2_xmx(x)
#     define _j2_qmi(x)       _j2_xmi(x)
#     define _j2_qmk(x)       _j2_xmk(x)
#     define _j2_qmd(x)       _j2_xmd(x)
#     define _j2_qmj(x)       _j2_xmj(x)
#     define _j2_qp(p, x)     _j2_xp(p, x)
#     define _j2_qpc(p, x)    _j2_xpc(p, x)

#     define _j2_a(a)                   a
#     define _j2_ab(a, b)               a##__##b
#     define _j2_abc(a, b, c)           a##__##b##__##c
#     define _j2_abcd(a, b, c, d)       a##__##b##__##c##__##d
#     define _j2_abcde(a, b, c, d, e)   a##__##b##__##c##__##d##__##e

#     define j2_sa(a)                   _j2_xs(_j2_a(a))
#     define j2_sb(a, b)                _j2_xs(_j2_ab(a, b))
#     define j2_sc(a, b, c)             _j2_xs(_j2_abc(a, b, c))
#     define j2_sd(a, b, c, d)          _j2_xs(_j2_abcd(a, b, c, d))
#     define j2_se(a, b, c, d, e)       _j2_xs(_j2_abcde(a, b, c, d, e))

#     define j2_da(a)                   _j2_qd(_j2_a(a))
#     define j2_db(a, b)                _j2_qd(_j2_ab(a, b))
#     define j2_dc(a, b, c)             _j2_qd(_j2_abc(a, b, c))
#     define j2_dd(a, b, c, d)          _j2_qd(_j2_abcd(a, b, c, d))
#     define j2_de(a, b, c, d, e)       _j2_qd(_j2_abcde(a, b, c, d, e))

#     define j2_ma(a)                   _j2_qm(_j2_a(a))
#     define j2_mb(a, b)                _j2_qm(_j2_ab(a, b))
#     define j2_mc(a, b, c)             _j2_qm(_j2_abc(a, b, c))
#     define j2_md(a, b, c, d)          _j2_qm(_j2_abcd(a, b, c, d))
#     define j2_me(a, b, c, d, e)       _j2_qm(_j2_abcde(a, b, c, d, e))

#     define j2_mac(a)                  _j2_qmc(_j2_a(a))
#     define j2_mbc(a, b)               _j2_qmc(_j2_ab(a, b))
#     define j2_mcc(a, b, c)            _j2_qmc(_j2_abc(a, b, c))
#     define j2_mdc(a, b, c, d)         _j2_qmc(_j2_abcd(a, b, c, d))
#     define j2_mec(a, b, c, d, e)      _j2_qmc(_j2_abcde(a, b, c, d, e))

#     define j2_may(a)                  _j2_qmy(_j2_a(a))
#     define j2_mby(a, b)               _j2_qmy(_j2_ab(a, b))
#     define j2_mcy(a, b, c)            _j2_qmy(_j2_abc(a, b, c))
#     define j2_mdy(a, b, c, d)         _j2_qmy(_j2_abcd(a, b, c, d))
#     define j2_mey(a, b, c, d, e)      _j2_qmy(_j2_abcde(a, b, c, d, e))

#     define j2_max(a)                  _j2_qmx(_j2_a(a))
#     define j2_mbx(a, b)               _j2_qmx(_j2_ab(a, b))
#     define j2_mcx(a, b, c)            _j2_qmx(_j2_abc(a, b, c))
#     define j2_mdx(a, b, c, d)         _j2_qmx(_j2_abcd(a, b, c, d))
#     define j2_mex(a, b, c, d, e)      _j2_qmx(_j2_abcde(a, b, c, d, e))

#     define j2_mai(a)                  _j2_qmi(_j2_a(a))
#     define j2_mbi(a, b)               _j2_qmi(_j2_ab(a, b))
#     define j2_mci(a, b, c)            _j2_qmi(_j2_abc(a, b, c))
#     define j2_mdi(a, b, c, d)         _j2_qmi(_j2_abcd(a, b, c, d))
#     define j2_mei(a, b, c, d, e)      _j2_qmi(_j2_abcde(a, b, c, d, e))

#     define j2_mak(a)                  _j2_qmk(_j2_a(a))
#     define j2_mbk(a, b)               _j2_qmk(_j2_ab(a, b))
#     define j2_mck(a, b, c)            _j2_qmk(_j2_abc(a, b, c))
#     define j2_mdk(a, b, c, d)         _j2_qmk(_j2_abcd(a, b, c, d))
#     define j2_mek(a, b, c, d, e)      _j2_qmk(_j2_abcde(a, b, c, d, e))

#     define j2_maj(a)                  _j2_qmj(_j2_a(a))
#     define j2_mbj(a, b)               _j2_qmj(_j2_ab(a, b))
#     define j2_mcj(a, b, c)            _j2_qmj(_j2_abc(a, b, c))
#     define j2_mdj(a, b, c, d)         _j2_qmj(_j2_abcd(a, b, c, d))
#     define j2_mej(a, b, c, d, e)      _j2_qmj(_j2_abcde(a, b, c, d, e))

#     define j2_mad(a)                  _j2_qmd(_j2_a(a))
#     define j2_mbd(a, b)               _j2_qmd(_j2_ab(a, b))
#     define j2_mcd(a, b, c)            _j2_qmd(_j2_abc(a, b, c))
#     define j2_mdd(a, b, c, d)         _j2_qmd(_j2_abcd(a, b, c, d))
#     define j2_med(a, b, c, d, e)      _j2_qmd(_j2_abcde(a, b, c, d, e))

#     define j2_pa(a, p)                _j2_qp(p, _j2_a(a))
#     define j2_pb(a, b, p)             _j2_qp(p, _j2_ab(a, b))
#     define j2_pc(a, b, c, p)          _j2_qp(p, _j2_abc(a, b, c))
#     define j2_pd(a, b, c, d, p)       _j2_qp(p, _j2_abcd(a, b, c, d))
#     define j2_pe(a, b, c, d, e, p)    _j2_qp(p, _j2_abcde(a, b, c, d, e))

#     define j2_pac(a, p)               _j2_qpc(p, _j2_a(a))
#     define j2_pbc(a, b, p)            _j2_qpc(p, _j2_ab(a, b))
#     define j2_pcc(a, b, c, p)         _j2_qpc(p, _j2_abc(a, b, c))
#     define j2_pdc(a, b, c, d, p)      _j2_qpc(p, _j2_abcd(a, b, c, d))
#     define j2_pec(a, b, c, d, e, p)   _j2_qpc(p, _j2_abcde(a, b, c, d, e))

