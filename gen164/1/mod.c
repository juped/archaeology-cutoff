/* j/1/mod.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u2_noun
  u2_cqa_mod(
                   u2_atom a,
                   u2_atom b)
  {
    if ( 0 == b ) {
      return u2_cm_bail(c3__exit);
    } else {
      mpz_t a_mp, b_mp;

      u2_cr_mp(a_mp, a);
      u2_cr_mp(b_mp, b);

      mpz_tdiv_r(a_mp, a_mp, b_mp);
      mpz_clear(b_mp);

      return u2_ci_mp(a_mp);
    }
  }

  u2_noun
  u2_cwa_mod(u2_noun cor)
  {
    u2_noun a, b;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a, u2_cv_sam_3, &b, 0)) ||
         (u2_no == u2ud(a)) ||
         (u2_no == u2ud(b)) )
    {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqa_mod(a, b);
    }
  }
