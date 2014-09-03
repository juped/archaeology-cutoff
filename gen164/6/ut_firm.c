/* j/6/firm.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* logic
*/
  u2_noun                                                         //  transfer
  _cqfu_firm(
                        u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun dib)                              //  retain
  {
    u2_noun p_sut, q_sut;

    if ( u2_no == u2du(sut) ) switch ( sut ) {
      default: return u2_cm_bail(c3__fail);

      case c3__noun:
      {
        return u2_yes;
      }
      case c3__void:
      {
        return u2_no;
      }
    }
    else switch ( u2h(sut) ) {
      default: return u2_cm_bail(c3__fail);

      case c3__atom: p_sut = u2t(sut);
      {
        return u2ud(dib);
      }
      case c3__bull: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_weak nun = u2_cr_at(u2h(u2t(u2t(p_sut))), dib);

        if ( u2_none == nun ) {
          return u2_no;
        } else {
          return u2_and(_cqfu_firm(van, q_sut, dib),
                        _cqfu_firm(van, u2t(u2t(u2t(p_sut))),
                                                          nun));
        }
      }
      case c3__cell: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        return u2_and
          (u2du(dib),
           u2_and(_cqfu_firm(van, p_sut, u2h(dib)),
                  _cqfu_firm(van, q_sut, u2t(dib))));
      }
      case c3__core: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun pq_sut, qq_sut, rq_sut, prq_sut, qrq_sut;

        u2_cx_trel(q_sut, &pq_sut, &qq_sut, &rq_sut);
        u2_cx_cell(rq_sut, &prq_sut, &qrq_sut);

        return u2_and
          (u2du(dib),
           u2_and
            (_cqfu_firm(van, p_sut, u2h(dib)),
             ((u2_nul == prq_sut) ? u2_cm_error("firm-core")
                                  : u2_cr_sing(prq_sut, u2t(dib)))));
      }
      case c3__cube: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        return u2_cr_sing(dib, p_sut);
      }
      case c3__face: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        return _cqfu_firm(van, q_sut, dib);
      }
      case c3__fork: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        return u2_or(_cqfu_firm(van, p_sut, dib),
                     _cqfu_firm(van, q_sut, dib));
      }
      case c3__hold:
      {
        u2_noun goy = u2_cqfu_repo(van, sut);
        u2_noun ret = _cqfu_firm(van, goy, dib);

        u2z(goy);
        return ret;
      }
    }
  }

/* boilerplate
*/
  u2_noun                                                         //  transfer
  u2_cwfu_firm(
                       u2_noun cor)                               //  retain
  {
    u2_noun sut, dib, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam, &dib, u2_cv_con, &van, 0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return _cqfu_firm(van, sut, dib);
    }
  }

  u2_noun                                                         //  transfer
  u2_cqfu_firm(u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun dib)                              //  retain
  {
    return _cqfu_firm(van, sut, dib);
  }

  u2_weak
  j2_mck(Pt6, ut, firm)(u2_noun cor)
  {
    u2_noun sut, dib, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam, &dib, u2_cv_con, &van, 0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_none;
    } else {
      return u2nc(u2k(sut), u2k(dib));
    }
  }
