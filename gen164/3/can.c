/* j/3/can.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun
  u2_cqc_can(u2_atom a,
                   u2_noun b)
  {
    if ( u2_ne(u2_co_is_cat(a)) || (a >= 32) ) {
      return u2_cm_bail(c3__fail);
    }
    else {
      c3_g  a_g = a;
      c3_w  tot_w = 0;
      c3_w* sal_w;

      /* Measure and validate the slab required.
      */
      {
        u2_noun cab = b;

        while ( 1 ) {
          u2_noun i_cab, pi_cab, qi_cab;

          if ( 0 == cab ) {
            break;
          }
          if ( u2_no == u2du(cab) ) return u2_cm_bail(c3__fail);
          i_cab = u2h(cab);
          if ( u2_no == u2du(i_cab) ) return u2_cm_bail(c3__fail);
          pi_cab = u2h(i_cab);
          qi_cab = u2t(i_cab);
          if ( u2_no == u2_co_is_cat(pi_cab) ) return u2_cm_bail(c3__fail);
          if ( u2_no == u2ud(qi_cab) )  return u2_cm_bail(c3__fail);
          if ( (tot_w + pi_cab) < tot_w ) return u2_cm_bail(c3__fail);

          tot_w += pi_cab;
          cab = u2t(cab);
        }
        if ( 0 == tot_w ) {
          return 0;
        }
        if ( 0 == (sal_w = u2_ca_slaq(a_g, tot_w)) ) {
          return u2_cm_bail(c3__fail);
        }
      }

      /* Chop the list atoms in.
      */
      {
        u2_noun cab = b;
        c3_w    pos_w = 0;

        while ( 0 != cab ) {
          u2_noun i_cab = u2h(cab);
          u2_atom pi_cab = u2h(i_cab);
          u2_atom qi_cab = u2t(i_cab);

          u2_cr_chop(a_g, 0, pi_cab, pos_w, sal_w, qi_cab);
          pos_w += pi_cab;
          cab = u2t(cab);
        }
      }
      return u2_ca_malt(sal_w);
    }
  }
  u2_noun
  u2_cwc_can(u2_noun cor)
  {
    u2_noun a, b;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a, u2_cv_sam_3, &b, 0)) ||
         (u2_no == u2ud(a)) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqc_can(a, b);
    }
  }

