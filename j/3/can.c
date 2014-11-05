/* j/3/can.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqc_can(u3_atom a,
                   u3_noun b)
  {
    if ( u3_ne(u3_ca_is_cat(a)) || (a >= 32) ) {
      return u3_cm_bail(c3__fail);
    }
    else {
      c3_g  a_g = a;
      c3_w  tot_w = 0;
      c3_w* sal_w;

      /* Measure and validate the slab required.
      */
      {
        u3_noun cab = b;

        while ( 1 ) {
          u3_noun i_cab, pi_cab, qi_cab;

          if ( 0 == cab ) {
            break;
          }
          if ( u3_no == u3du(cab) ) return u3_cm_bail(c3__fail);
          i_cab = u3h(cab);
          if ( u3_no == u3du(i_cab) ) return u3_cm_bail(c3__fail);
          pi_cab = u3h(i_cab);
          qi_cab = u3t(i_cab);
          if ( u3_no == u3_ca_is_cat(pi_cab) ) return u3_cm_bail(c3__fail);
          if ( u3_no == u3ud(qi_cab) )  return u3_cm_bail(c3__fail);
          if ( (tot_w + pi_cab) < tot_w ) return u3_cm_bail(c3__fail);

          tot_w += pi_cab;
          cab = u3t(cab);
        }
        if ( 0 == tot_w ) {
          return 0;
        }
        if ( 0 == (sal_w = u3_ca_slaq(a_g, tot_w)) ) {
          return u3_cm_bail(c3__fail);
        }
      }

      /* Chop the list atoms in.
      */
      {
        u3_noun cab = b;
        c3_w    pos_w = 0;

        while ( 0 != cab ) {
          u3_noun i_cab = u3h(cab);
          u3_atom pi_cab = u3h(i_cab);
          u3_atom qi_cab = u3t(i_cab);

          u3_cr_chop(a_g, 0, pi_cab, pos_w, sal_w, qi_cab);
          pos_w += pi_cab;
          cab = u3t(cab);
        }
      }
      return u3_ca_malt(sal_w);
    }
  }
  u3_noun
  u3_cwc_can(u3_noun cor)
  {
    u3_noun a, b;

    if ( (u3_no == u3_cr_mean(cor, u3_cv_sam_2, &a, u3_cv_sam_3, &b, 0)) ||
         (u3_no == u3ud(a)) )
    {
      return u3_cm_bail(c3__fail);
    } else {
      return u3_cqc_can(a, b);
    }
  }

