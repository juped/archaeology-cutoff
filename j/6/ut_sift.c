/* j/6/sift.c
**
** This file is in the public domain.
*/
#include "all.h"


/* boilerplate
*/
  u3_noun
  u3_cwfu_sift(
                       u3_noun cor)
  {
    u3_noun sut, ref, van;

    if ( (c3n == u3r_mean(cor, u3v_sam, &ref,
                                u3v_con, &van,
                                0)) ||
         (u3_none == (sut = u3r_at(u3v_sam, van))) )
    {
      return u3m_bail(c3__fail);
    } else {
      return u3_cqfu_sift(van, sut, ref);
    }
  }

  u3_noun
  u3_cqfu_sift(u3_noun van,
                        u3_noun sut,
                        u3_noun ref)
  {
    return u3k(ref);
  }
