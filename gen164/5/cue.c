/* j/3/cue.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"
#include "f/pork.h"

  static u2_noun                                                  //  produce
  _cue_in(u2_ha_root* har_u,
          u2_atom     a,                                          //  retain
          u2_atom     b)                                          //  retain
  {
    u2_noun p, q;

    if ( 0 == j2_mbc(Pt3, cut)(0, b, 1, a) ) {
      u2_noun x = j2_mbc(Pt1, inc)(b);
      u2_noun c = j2_mby(Pt5, rub)(x, a);

      p = j2_mbc(Pt1, inc)(u2k(u2h(c)));
      q = u2k(u2t(c));

      u2_ha_put(har_u, u2k(b), u2k(q));

      u2z(c);
      u2z(x);
    }
    else {
      u2_noun c = j2_mbc(Pt1, add)(2, b);
      u2_noun l = j2_mbc(Pt1, inc)(b);

      if ( 0 == j2_mbc(Pt3, cut)(0, l, 1, a) ) {
        u2_noun u, v, w;
        u2_noun x, y;

        u = _cue_in(har_u, a, c);
        x = j2_mbc(Pt1, add)(u2h(u), c);
        v = _cue_in(har_u, a, x);
        w = u2nc(u2k(u2h(u2t(u))), u2k(u2h(u2t(v))));

        y = j2_mbc(Pt1, add)(u2h(u), u2h(v));
        p = j2_mbc(Pt1, add)(2, y);

        q = w;
        u2_ha_put(har_u, u2k(b), u2k(q));

        u2z(u); u2z(v); u2z(x); u2z(y);
      }
      else {
        u2_noun d = j2_mby(Pt5, rub)(c, a);
        u2_noun x = u2_ha_get(har_u, u2k(u2t(d)));

        p = j2_mbc(Pt1, add)(2, u2h(d));
        if ( u2_none == x ) {
          return u2_cm_bail(c3__exit);
        }
        q = x;
        u2z(d);
      }
      u2z(l);
      u2z(c);
    }
    return u2nt(p, q, 0);
  }

  u2_noun                                                         //  transfer
  j2_mby(Pt5, cue)(u2_atom a)                                     //  retain
  {
    u2_ha_root* har_u = u2_ha_new();

    u2_noun x = _cue_in(har_u, a, 0);
    u2_noun y = u2k(u2h(u2t(x)));

    u2_ha_free(har_u);

    u2z(x);
    return y;
  }
  u2_noun                                                         //  transfer
  j2_mb(Pt5, cue)(u2_noun cor)                                    //  retain
  {
    u2_noun a;

    if ( (u2_none == (a = u2_cr_at(u2_cv_sam, cor))) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return j2_mby(Pt5, cue)(a);
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mbj(Pt5, cue)[] = {
    { ".2", c3__hevy, j2_mb(Pt5, cue), Tier3, u2_none, u2_none },
    { }
  };
