/* j/2/turn.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqb_turn(u3_noun a,
                    u3_noun b)
  {
    if ( 0 == a ) {
      return a;
    }
    else if ( u3_no == u3du(a) ) {
      return u3_cm_bail(c3__exit);
    }
    else {
      u3_noun one = u3_cn_slam_on(b, u3k(u3h(a)));
      u3_noun two = u3_cqb_turn(u3t(a), b);

      return u3nc(one, two);
    }
  }
  u3_noun
  u3_cwb_turn(
                   u3_noun cor)
  {
    u3_noun a, b;

    if ( u3_no == u3_cr_mean(cor, u3_cv_sam_2, &a, u3_cv_sam_3, &b, 0) ) {
      return u3_cm_bail(c3__exit);
    } else {
      return u3_cqb_turn(a, b);
    }
  }

