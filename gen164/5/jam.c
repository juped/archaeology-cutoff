/* j/3/jam.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  static u2_noun
  _jam_in(u2_ch_root* har_u, u2_atom, u2_atom, u2_noun);

  static u2_noun                                                  //  produce
  _jam_in_pair(u2_ch_root* har_u,
               u2_atom h_a,                                       //  retain
               u2_atom t_a,                                       //  retain
               u2_atom b,                                         //  retain
               u2_noun l)                                         //  retain
  {
    u2_noun w = u2nc(u2nc(2, 1), u2k(l));
    u2_noun x = j2_mbc(Pt1, add)(2, b);
    u2_noun d = _jam_in(har_u, h_a, x, w);
    u2_noun p_d, q_d, r_d;
    u2_noun r;

    u2_cr_trel(d, &p_d, &q_d, &r_d);
    {
      u2_noun y = j2_mbc(Pt1, add)(x, p_d);
      u2_noun e = _jam_in(har_u, t_a, y, q_d);
      u2_noun p_e, q_e, r_e;

      u2_cr_trel(e, &p_e, &q_e, &r_e);
      {
        u2_noun z = j2_mbc(Pt1, add)(p_d, p_e);

        r = u2nt(j2_mbc(Pt1, add)(2, z), u2k(q_e), 0);

        u2z(z);
      }
      u2z(e);
      u2z(y);
    }
    u2z(d);
    u2z(x);
    u2z(w);

    return r;
  }

  static u2_noun                                                  //  produce
  _jam_in_flat(u2_ch_root* har_u,
               u2_atom a,                                         //  retain
               u2_noun l)                                         //  retain
  {
    u2_noun d = j2_mby(Pt5, mat)(a);
    u2_noun x = j2_mbc(Pt1, add)(1, u2h(d));
    u2_noun y = u2nt
      (u2k(x), u2nc(u2nc(x, j2_mbc(Pt3, lsh)(0, 1, u2t(d))), u2k(l)), 0);

    u2z(d);

    return y;
  }

  static u2_noun                                                  //  produce
  _jam_in_ptr(u2_ch_root* har_u,
              u2_atom u_c,                                        //  retain
              u2_noun l)                                          //  retain
  {
    u2_noun d = j2_mby(Pt5, mat)(u_c);
    u2_atom x = j2_mbc(Pt3, lsh)(0, 2, u2t(d));
    u2_atom y = j2_mbc(Pt1, add)(2, u2h(d));
    u2_noun z = u2nt
      (u2k(y), u2nc(u2nc(y, j2_mbc(Pt3, mix)(3, x)), u2k(l)), 0);

    u2z(d);
    u2z(x);

    return z;
  }

  static u2_noun                                                  //  produce
  _jam_in(u2_ch_root* har_u,
          u2_noun a,                                              //  retain
          u2_atom b,                                              //  retain
          u2_noun l)                                              //  retain
  {
    u2_noun c = u2_ch_get(har_u, u2k(a));
    u2_noun x;

    if ( u2_none == c ) {
        u2_ch_put(har_u, u2k(a), u2k(b));

      if ( u2_yes == u2ud(a) ) {
        x = _jam_in_flat(har_u, a, l);
      } else {
        x = _jam_in_pair(har_u, u2h(a), u2t(a), b, l);
      }
    }
    else {
      if ( u2_yes == u2ud(a) && u2_cr_met(0, a) <= u2_cr_met(0, c) ) {
        x = _jam_in_flat(har_u, a, l);
      }
      else {
        x = _jam_in_ptr(har_u, c, l);
      }
    }
    return x;
  }

  u2_noun                                                         //  transfer
  j2_mby(Pt5, jam)(u2_atom a)                                     //  retain
  {
    u2_ch_root* har_u = u2_ch_new();

    u2_noun x = _jam_in(har_u, a, 0, u2_nul);
    u2_noun q = j2_mbc(Pt2, flop)(u2h(u2t(x)));
    u2_noun r = j2_mbc(Pt3, can)(0, q);

    u2z(x);
    u2z(q);
    u2_ch_free(har_u);
    return r;
  }
  u2_noun                                                         //  transfer
  j2_mb(Pt5, jam)(u2_noun cor)                                    //  retain
  {
    u2_noun a;

    if ( (u2_none == (a = u2_cr_at(u2_cv_sam, cor))) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return j2_mby(Pt5, jam)(a);
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mbj(Pt5, jam)[] = {
    { ".2", c3__hevy, j2_mb(Pt5, jam), Tier5, u2_none, u2_none },
    { }
  };
