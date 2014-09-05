/* j/5/loss.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  typedef struct _u3_loss {                 //  loss problem
    u3_noun hel;                            //  a as a list
    c3_w lel_w;                             //  length of a
    c3_w lev_w;                             //  length of b
    u3_noun* hev;                           //  b as an array
    u3_noun sev;                            //  b as a set of lists
    c3_w kct_w;                             //  candidate count
    u3_noun* kad;                           //  candidate array
  } u3_loss;

  //  free loss object
  //
  static void
  _flem(u3_loss* loc_u)
  {
    u3z(loc_u->sev);
    {
      c3_w i_w;

      for ( i_w = 0; i_w < loc_u->kct_w; i_w++ ) {
        u3z(loc_u->kad[i_w]);
      }
    }
    free(loc_u->hev);
    free(loc_u->kad);
  }

  //  extract lcs  -  XX don't use the stack like this
  //
  static u3_noun
  _lext(u3_loss* loc_u, u3_noun kad)
  {
    if ( u3_nul == kad ) {
      return u3_nul;
    } else {
      return u3nc(u3k(loc_u->hev[u3_cr_word(0, u3h(kad))]),
                  _lext(loc_u, u3t(kad)));
    }
  }

  //  extract lcs
  //
  static u3_noun
  _lexs(u3_loss* loc_u)
  {
    if ( 0 == loc_u->kct_w ) {
      return u3_nul;
    } else return u3_ckb_flop(_lext(loc_u, loc_u->kad[loc_u->kct_w - 1]));
  }

  //  initialize loss object
  //
  static void
  _lemp(u3_loss* loc_u,
        u3_noun  hel,
        u3_noun  hev)
  {
    loc_u->hel = hel;
    loc_u->lel_w = u3_ckb_lent(u3k(hel));

    //  Read hev into array.
    {
      c3_w i_w;

      loc_u->hev = c3_malloc(u3_ckb_lent(u3k(hev)) * sizeof(u3_noun));

      for ( i_w = 0; u3_nul != hev; i_w++ ) {
        loc_u->hev[i_w] = u3h(hev);
        hev = u3t(hev);
      }
      loc_u->lev_w = i_w;
    }
    loc_u->kct_w = 0;
    loc_u->kad = c3_malloc(
                              (1 + c3_min(loc_u->lev_w, loc_u->lel_w)) *
                              sizeof(u3_noun));

    //  Compute equivalence classes.
    //
    loc_u->sev = u3_nul;
    {
      c3_w i_w;

      for ( i_w = 0; i_w < loc_u->lev_w; i_w++ ) {
        u3_noun how = loc_u->hev[i_w];
        u3_noun hav;
        u3_noun teg;

        hav = u3_ckdb_get(u3k(loc_u->sev), u3k(how));
        teg = u3nc(u3_ci_words(1, &i_w),
                          (hav == u3_none) ? u3_nul : hav);
        loc_u->sev = u3_ckdb_put(loc_u->sev, u3k(how), teg);
      }
    }
  }

  //  apply
  //
  static void
  _lune(u3_loss* loc_u,
        c3_w     inx_w,
        c3_w     goy_w)
  {
    u3_noun kad;

    kad = u3nc(u3_ci_words(1, &goy_w),
               (inx_w == 0) ? u3_nul
                            : u3k(loc_u->kad[inx_w - 1]));
    if ( loc_u->kct_w == inx_w ) {
      c3_assert(loc_u->kct_w < (1 << 31));
      loc_u->kct_w++;
    } else {
      u3z(loc_u->kad[inx_w]);
    }
    loc_u->kad[inx_w] = kad;
  }

  //  extend fits top
  //
  static u3_bean
  _hink(u3_loss* loc_u,
        c3_w     inx_w,
        c3_w     goy_w)
  {
    return u3_say
         ( (loc_u->kct_w == inx_w) ||
           (u3_cr_word(0, u3h(loc_u->kad[inx_w])) > goy_w) );
  }

  //  extend fits bottom
  //
  static u3_bean
  _lonk(u3_loss* loc_u,
        c3_w     inx_w,
        c3_w     goy_w)
  {
    return u3_say
      ( (0 == inx_w) ||
        (u3_cr_word(0, u3h(loc_u->kad[inx_w - 1])) < goy_w) );
  }

#if 0
  //  search for first index >= inx_w and <= max_w that fits
  //  the hink and lonk criteria.
  //
  static u3_bean
  _binka(u3_loss* loc_u,
         c3_w*    inx_w,
         c3_w     max_w,
         c3_w     goy_w)
  {
    while ( *inx_w <= max_w ) {
      if ( u3_no == _lonk(loc_u, *inx_w, goy_w) ) {
        return u3_no;
      }
      if ( u3_yes == _hink(loc_u, *inx_w, goy_w) ) {
        return u3_yes;
      }
      else ++*inx_w;
    }
    return u3_no;
  }
#endif

  //  search for lowest index >= inx_w and <= max_w for which
  //  both hink(inx_w) and lonk(inx_w) are true.  lonk is false
  //  if inx_w is too high, hink is false if it is too low.
  //
  static u3_bean
  _bink(u3_loss* loc_u,
        c3_w*    inx_w,
        c3_w     max_w,
        c3_w     goy_w)
  {
    c3_assert(max_w >= *inx_w);

    if ( max_w == *inx_w ) {
      if ( u3_no == _lonk(loc_u, *inx_w, goy_w) ) {
        return u3_no;
      }
      if ( u3_yes == _hink(loc_u, *inx_w, goy_w) ) {
        return u3_yes;
      }
      else {
        ++*inx_w;
        return u3_no;
      }
    }
    else {
      c3_w mid_w = *inx_w + ((max_w - *inx_w) / 2);

      if ( (u3_no == _lonk(loc_u, mid_w, goy_w)) ||
           (u3_yes == _hink(loc_u, mid_w, goy_w)) )
      {
        return _bink(loc_u, inx_w, mid_w, goy_w);
      } else {
        *inx_w = mid_w + 1;
        return _bink(loc_u, inx_w, max_w, goy_w);
      }
    }
  }


  static void
  _merg(u3_loss* loc_u,
        c3_w     inx_w,
        u3_noun  gay)
  {
    if ( (u3_nul == gay) || (inx_w > loc_u->kct_w) ) {
      return;
    }
    else {
      u3_noun i_gay = u3h(gay);
      c3_w    goy_w = u3_cr_word(0, i_gay);
      u3_noun bik;

      bik = _bink(loc_u, &inx_w, loc_u->kct_w, goy_w);

      if ( u3_yes == bik ) {
        _merg(loc_u, inx_w + 1, u3t(gay));
        _lune(loc_u, inx_w, goy_w);
      }
      else {
        _merg(loc_u, inx_w, u3t(gay));
      }
    }
  }

  //  compute lcs
  //
  static void
  _loss(u3_loss* loc_u)
  {
    while ( u3_nul != loc_u->hel ) {
      u3_noun i_hel = u3h(loc_u->hel);
      u3_noun guy   = u3_ckdb_get(u3k(loc_u->sev), u3k(i_hel));

      if ( u3_none != guy ) {
        u3_noun gay = u3_ckb_flop(guy);

        _merg(loc_u, 0, gay);
        u3z(gay);
      }

      loc_u->hel = u3t(loc_u->hel);
    }
  }

  u3_noun
  u3_cqe_loss(
                    u3_noun hel,
                    u3_noun hev)
  {
    u3_loss loc_u;
    u3_noun lcs;

    _lemp(&loc_u, hel, hev);
    _loss(&loc_u);
    lcs = _lexs(&loc_u);

    _flem(&loc_u);
    return lcs;
  }

  static u3_bean
  _listp(u3_noun lix)
  {
    while ( 1 ) {
      if ( u3_nul == lix ) return u3_yes;
      if ( u3_no == u3du(lix) ) return u3_no;
      lix = u3t(lix);
    }
  }

  u3_noun
  u3_cwe_loss(u3_noun cor)
  {
    u3_noun hel, hev;

    if ( (u3_none == (hel = u3_cr_at(u3_cv_sam_2, cor))) ||
         (u3_none == (hev = u3_cr_at(u3_cv_sam_3, cor))) ||
         (u3_no == _listp(hel)) ||
         (u3_no == _listp(hev)) )
    {
      return u3_cm_bail(c3__fail);
    } else {
      return u3_cqe_loss(hel, hev);
    }
  }
