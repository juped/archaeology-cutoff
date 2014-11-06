/* j/3/cap.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqc_cap(
                   u3_atom a)
  {
    c3_w met_w = u3r_met(0, a);

    if ( met_w < 2 ) {
      return u3m_bail(c3__exit);
    }
    else if ( (1 == u3r_bit((met_w - 2), a)) ) {
      return 3;
    } else {
      return 2;
    }
  }
  u3_noun
  u3_cwc_cap(
                  u3_noun cor)
  {
    u3_noun a;

    if ( (u3_none == (a = u3r_at(u3v_sam, cor))) ||
         (c3n == u3ud(a)) )
    {
      return u3m_bail(c3__exit);
    } else {
      return u3_cqc_cap(a);
    }
  }

