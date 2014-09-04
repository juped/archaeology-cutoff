/* j/2/roll.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u2_noun
  u2_cqb_roll(u2_noun a,
                    u2_noun b)
  {
    if ( 0 == a ) {
      return u2k(u2_cr_at(u2_cv_sam_3, b));
    }
    else if ( u2_no == u2du(a) ) {
      return u2_cm_bail(c3__exit);
    }
    else {
      u2_noun gim = u2k(u2h(a));
      u2_noun zor = u2k(u2_cr_at(u2_cv_sam_3, b));
      u2_noun daz = u2_cn_slam_on(u2k(b), u2nc(gim, zor));
      u2_noun vel = u2_ci_molt(u2k(b), u2_cv_sam_3, daz, 0);

      if ( u2_none == vel ) {
        return u2_cm_bail(c3__exit);
      } else {
        u2_noun hox = u2_cqb_roll(u2t(a), vel);

        u2z(vel);
        return hox;
      }
    }
  }
  u2_noun
  u2_cwb_roll(u2_noun cor)
  {
    u2_noun a, b;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a, u2_cv_sam_3, &b, 0) ) {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqb_roll(a, b);
    }
  }

