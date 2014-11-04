/* j/4/gas.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqdb_gas(
                       u3_noun a,
                       u3_noun b)
  {
    if ( u3_nul == b ) {
      return u3k(a);
    }
    else {
      if ( u3_no == u3du(b) ) {
        return u3_cm_bail(c3__exit);
      } else {
        u3_noun i_b = u3h(b);
        u3_noun t_b = u3t(b);

        if ( u3_no == u3du(i_b) ) {
          return u3_cm_bail(c3__exit);
        } else {
          u3_noun pi_b = u3h(i_b);
          u3_noun qi_b = u3t(i_b);
          u3_noun c;

          if ( u3_none == (c = u3_cqdb_put(a, pi_b, qi_b)) ) {
            return u3_cm_bail(c3__exit);
          } else {
            u3_noun d = u3_cqdb_gas(c, t_b);

            u3z(c);
            return d;
          }
        }
      }
    }
  }
  u3_noun
  u3_cwdb_gas(
                      u3_noun cor)
  {
    u3_noun a, b;

    if ( u3_no == u3_cr_mean(cor, u3_cv_sam, &b, u3_cv_con_sam, &a, 0) ) {
      return u3_cm_bail(c3__exit);
    } else {
      return u3_cqdb_gas(a, b);
    }
  }
  u3_noun
  u3_ckdb_gas(u3_noun a, u3_noun b)
  {
    u3_weak c = u3_cqdb_gas(a, b);

    u3z(a); u3z(b);
    if ( u3_none == c ) {
      return u3_cm_bail(c3__exit);
    }
    else return c;
  }

