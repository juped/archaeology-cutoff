/* j/6/tock.c
**
** This file is in the public domain.
*/
#include "all.h"


/* internals
*/
  static u3_noun
  _tock_in(
           u3_noun van,
           u3_noun sut,
           u3_noun peh,
           u3_noun mur,
           u3_noun men)
  {
    if ( u3_no == u3du(men) ) {
      return u3nc(u3_nul, u3_nul);
    }
    else {
      u3_noun i_men  = u3h(men);
      u3_noun pi_men = u3h(i_men);
      u3_noun qi_men = u3t(i_men);
      u3_noun t_men  = u3t(men);
      u3_noun geq    = u3_cqfu_tack(van, pi_men, peh, mur);
      u3_noun p_geq  = u3h(geq);
      u3_noun q_geq  = u3t(geq);
      u3_noun mox    = _tock_in(van, sut, peh, mur, t_men);
      u3_noun p_mox  = u3h(mox);
      u3_noun q_mox  = u3t(mox);
      u3_noun ret;

      ret = u3nc(
                  ( (u3_nul == p_mox)
                      ? u3nc(u3_nul, u3k(p_geq))
                      : (u3_no == u3_cr_sing(p_geq, u3t(p_mox)))
                        ? u3_cm_bail(c3__exit)
                        : u3k(p_mox) ),
                  u3nc(u3nc(u3k(q_geq),
                                            u3k(qi_men)),
                               u3k(q_mox)));

      u3z(mox);
      u3z(geq);
      return ret;
    }
  }

/* functions
*/
  u3_noun
  _cqfu_tock(
                        u3_noun van,
                        u3_noun sut,
                        u3_noun peh,
                        u3_noun mur,
                        u3_noun men)
  {
    u3_noun wib = _tock_in(van, sut, peh, mur, men);
    u3_noun p_wib = u3h(wib);
    u3_noun q_wib = u3t(wib);

    if ( u3_nul == p_wib ) {
      return u3_cm_bail(c3__exit);
    } else {
      u3_noun ret = u3nc(u3k(u3t(p_wib)),
                                 u3k(q_wib));

      u3z(wib);
      return ret;
    }
  }

/* boilerplate
*/
  u3_noun
  u3_cwfu_tock(
                       u3_noun cor)
  {
    u3_noun van, sut, peh, mur, men;

    if ( (u3_no == u3_cr_mean(cor, u3_cv_sam_2, &peh,
                                u3_cv_sam_6, &mur,
                                u3_cv_sam_7, &men,
                                u3_cv_con, &van,
                                0)) ||
         (u3_none == (sut = u3_cr_at(u3_cv_sam, van))) )
    {
      return u3_cm_bail(c3__fail);
    } else {
      return _cqfu_tock(van, sut, peh, mur, men);
    }
  }

  u3_noun
  u3_cqfu_tock(u3_noun van,
                        u3_noun sut,
                        u3_noun peh,
                        u3_noun mur,
                        u3_noun men)
  {
    return _cqfu_tock(van, sut, peh, mur, men);
  }
