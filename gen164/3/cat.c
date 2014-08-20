/* j/3/cat.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_weak                                                         //  transfer
  j2_mbc(Pt3, cat)(u2_atom a,                                     //  retain
                   u2_atom b,                                     //  retain
                   u2_atom c)                                     //  retain
  {
    if ( u2_ne(u2_co_is_cat(a)) || (a >= 32) ) {
      return u2_cm_bail(c3__fail);
    }
    else {
      c3_g   a_g = a;
      c3_w   lew_w = u2_cr_met(a_g, b);
      c3_w   ler_w = u2_cr_met(a_g, c);
      c3_w   all_w = (lew_w + ler_w);

      if ( 0 == all_w ) {
        return 0;
      } else {
        c3_w* sal_w = u2_ca_slaq(a_g, all_w);

        if ( 0 == sal_w ) {
          return u2_cm_bail(c3__fail);
        }
        else {
          u2_cr_chop(a_g, 0, lew_w, 0, sal_w, b);
          u2_cr_chop(a_g, 0, ler_w, lew_w, sal_w, c);
        }
        // return u2_ca_moot(sal_w);
        return u2_ca_malt(sal_w);
      }
    }
  }

  u2_weak                                                         //  transfer
  j2_mb(Pt3, cat)(u2_noun cor)                                    //  retain
  {
    u2_noun a, b, c;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a,
                                u2_cv_sam_6, &b,
                                u2_cv_sam_7, &c, 0)) ||
         (u2_no == u2ud(a)) ||
         (u2_no == u2ud(b)) ||
         (u2_no == u2ud(c)) )
    {
      return u2_cm_bail(c3__exit);
    } else {
      return j2_mbc(Pt3, cat)(a, b, c);
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mbj(Pt3, cat)[] = {
    { ".2", c3__lite, j2_mb(Pt3, cat), Tier3, u2_none, u2_none },
    { }
  };

