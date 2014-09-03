/* j/1/lte.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun
  u2_cqa_lte(u2_atom a,
                   u2_atom b)
  {
    if ( u2_co_is_cat(a) && u2_co_is_cat(b) ) {
      return u2_say(a <= b);
    }
    else {
      mpz_t   a_mp, b_mp;
      u2_bean cmp;

      u2_cr_mp(a_mp, a);
      u2_cr_mp(b_mp, b);

      cmp = (mpz_cmp(a_mp, b_mp) <= 0) ? u2_yes : u2_no;

      mpz_clear(a_mp);
      mpz_clear(b_mp);

      return cmp;
    }
  }
  u2_noun
  u2_cwa_lte(u2_noun cor)
  {
    u2_noun a, b;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a, u2_cv_sam_3, &b, 0)) ||
         (u2_no == u2ud(a)) ||
         (u2_no == u2ud(b)) )
    {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqa_lte(a, b);
    }
  }
