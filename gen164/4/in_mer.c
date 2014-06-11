/* j/4/in_mer.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_weak                                                         //  transfer
  j2_mcc(Pt4, in, mer)(u2_wire wir_r,
                       u2_noun a,                                 //  retain
                       u2_noun b)                                 //  retain
  {
    if ( u2_nul == a ) {
      return u2_rx(wir_r, b);
    }
    else if ( u2_nul == b ) {
      return u2_rx(wir_r, a);
    }
    else {
      u2_noun l_a, n_a, r_a, lr_a;  //  XX copy tree boilerplate to other pt4
      u2_noun l_b, n_b, r_b, lr_b;
      u2_noun c;

      if ( (u2_no == u2_as_cell(a, &n_a, &lr_a)) ) {
        return u2_bl_bail(wir_r, c3__exit);
      }
      else if ( (u2_no == u2_as_cell(b, &n_b, &lr_b)) ) {
        return u2_bl_bail(wir_r, c3__exit);
      }
      else {
        if ( u2_yes == j2_mbc(Pt3, vor)(wir_r, n_b, n_a) ) {
          c = a;    a = b;       b = c;
          c = n_a;  n_a = n_b;   n_b = c;
          c = lr_a; lr_a = lr_b; lr_b = c;
        }
        if ( u2_no == u2_as_cell(lr_a, &l_a, &r_a) ) {
          return u2_bl_bail(wir_r, c3__exit);
        }
        else if ( u2_no == u2_as_cell(lr_b, &l_b, &r_b) ) {
          return u2_bl_bail(wir_r, c3__exit);
        }
        else if ( u2_yes == u2_sing(n_a, n_b) ) {
          return u2_rt(wir_r, u2_rx(wir_r, n_a),
                              j2_mcc(Pt4, in, mer)(wir_r, l_a, l_b),
                              j2_mcc(Pt4, in, mer)(wir_r, r_a, r_b));
        }
        else if ( u2_yes == j2_mbc(Pt3, hor)(wir_r, n_b, n_a) ) {
          return j2_mcc(Pt4, in, mer)(wir_r,
                                      u2_rt(wir_r,
                                            n_a,
                                            j2_mcc(Pt4, in, mer)(wir_r,
                                                                l_a,
                                                                u2_rt(wir_r,
                                                                      n_b,
                                                                      l_b,
                                                                      u2_nul)),
                                            r_a),
                                      r_b);
        }
        else {
          return j2_mcc(Pt4, in, mer)(wir_r,
                                      u2_rt(wir_r,
                                            n_a,
                                            l_a,
                                            j2_mcc(Pt4, in, mer)(wir_r,
                                                                r_a,
                                                                u2_rt(wir_r,
                                                                      n_b,
                                                                      u2_nul,
                                                                      r_b))),
                                      l_b);
        }
      }
    }
  }
  u2_weak                                                         //  transfer
  j2_mc(Pt4, in, mer)(u2_wire wir_r,
                      u2_noun cor)                                //  retain
  {
    u2_noun a, b;

    if ( u2_no == u2_mean(cor, u2_cv_sam, &b, u2_cv_con_sam, &a, 0) ) {
      return u2_bl_bail(wir_r, c3__exit);
    } else {
      return j2_mcc(Pt4, in, mer)(wir_r, a, b);
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mcj(Pt4, in, mer)[] = {
    { ".2", c3__lite, j2_mc(Pt4, in, mer), Tier4, u2_none, u2_none },
    { }
  };

