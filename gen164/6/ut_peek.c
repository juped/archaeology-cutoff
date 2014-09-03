/* j/6/peek.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* logic
*/
  u2_noun
  j2_mcx(Pt6, ut, peek)(u2_noun, u2_noun, u2_noun, u2_atom);

  static u2_noun                                                  //  produce
  _peek_in(
           u2_noun van,                                           //  retain
           u2_noun sut,                                           //  retain
           u2_noun way,                                           //  retain
           u2_atom axe,                                           //  retain
           u2_noun gil)                                           //  retain
  {
    u2_noun p_sut, q_sut;
    u2_noun pro;

    if ( (u2_no == u2du(sut)) ) switch ( sut ) {
      default: return u2_cm_bail(c3__fail);

      case c3__noun: {
        return c3__noun;
      }
      case c3__void: {
        return c3__void;
      }
    }
    else switch ( u2h(sut) ) {
      default: return u2_cm_bail(c3__fail);

      case c3__atom: {
        return c3__void;
      }
      case c3__bull: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          return _peek_in(van, q_sut, way, axe, gil);
        }
      }
      case c3__cell: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          u2_atom tip = u2_cqc_cap(axe);
          u2_atom tap = u2_cqc_mas(axe);

          if ( 2 == tip ) {
            pro = j2_mcx(Pt6, ut, peek)(van, p_sut, way, tap);
          }
          else {
            pro = j2_mcx(Pt6, ut, peek)(van, q_sut, way, tap);
          }
          u2z(tap);
          u2z(tip);

          return pro;
        }
      }
      case c3__core: {
        u2_noun pq_sut, qq_sut, rq_sut;
        u2_noun prq_sut, qrq_sut;

        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ||
             (u2_no == u2_cr_trel(q_sut, &pq_sut, &qq_sut, &rq_sut)) ||
             (u2_no == u2_cr_cell(rq_sut, &prq_sut, &qrq_sut)) )
        {
          return u2_cm_bail(c3__fail);
        } else {
          u2_atom tip = u2_cqc_cap(axe);
          u2_atom tap = u2_cqc_mas(axe);

          if ( 3 == tip ) {
            if ( u2_no == u2_cqfu_park(van, sut, way, tap) )
            {
              // u2_noun dun = u2_cqfu_dunq(van, "type", sut);
              u2_noun waz = u2_cqfu_shep
                (van, "axis", 'd', u2k(axe));

              // u2_ct_push(u2nc(c3__mean, dun));
              u2_ct_push(u2nc(c3__mean, waz));

              return u2_cm_error("peek-park");
            }
            else pro = j2_mcx(Pt6, ut, peek)(van, p_sut, way, tap);
          }
          else {
            pro = c3__noun;
          }
          u2z(tap);
          u2z(tip);

          return pro;
        }
      }
      case c3__cube: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          return _peek_in(van, q_sut, way, axe, gil);
        }
      }
      case c3__face: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          return _peek_in(van, q_sut, way, axe, gil);
        }
      }
      case c3__fork: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          u2_noun hed = _peek_in(van, p_sut, way, axe, gil);
          u2_noun tal = _peek_in(van, q_sut, way, axe, gil);

          pro = u2_cqf_fork(hed, tal);

          u2z(hed);
          u2z(tal);

          return pro;
        }
      }
      case c3__hold: {
        p_sut = u2t(sut);
        if ( (u2_yes == u2_cqdi_has(gil, sut)) ) {
          return c3__void;
        }
        else {
          u2_noun zoc = u2_cqdi_put(gil, sut);
          u2_noun fop = u2_cqfu_repo(van, sut);
          u2_noun pro = _peek_in(van, fop, way, axe, zoc);

          u2z(fop);
          u2z(zoc);

          return pro;
        }
      }
    }
  }

  u2_noun                                                         //  transfer
  j2_mcx(Pt6, ut, peek)(
                        u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun way,
                        u2_atom axe)                              //  retain
  {
    if ( 1 == axe ) {
      return u2k(sut);
    }
    else return _peek_in(van, sut, way, axe, u2_nul);
  }

/* boilerplate
*/
  u2_ho_jet
  j2_mcj(Pt6, ut, peek)[];

  u2_noun                                                         //  transfer
  j2_mc(Pt6, ut, peek)(
                       u2_noun cor)                               //  retain
  {
    u2_noun sut, way, axe, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &way,
                                u2_cv_sam_3, &axe,
                                u2_cv_con, &van,
                                0)) ||
         (u2_no == u2ud(axe)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return j2_mcx(Pt6, ut, peek)(van, sut, way, axe);
    }
  }

  u2_noun                                                         //  transfer
  u2_cqfu_peek(u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun way,                              //  retain
                        u2_noun axe)                              //  retain
  {
    c3_m    fun_m = c3__peek;
    u2_noun pro   = u2_cz_find_3(fun_m, sut, way, axe);

    if ( u2_none != pro ) {
      return pro;
    }
    else {
      pro = j2_mcx(Pt6, ut, peek)(van, sut, way, axe);

      return u2_cz_save_3(fun_m, sut, way, axe, pro);
    }
  }

  u2_weak
  j2_mck(Pt6, ut, peek)(u2_noun cor)
  {
    u2_noun sut, way, axe, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &way,
                                u2_cv_sam_3, &axe,
                                u2_cv_con, &van,
                                0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_none;
    } else {
      return u2nt
        (u2k(sut), u2k(way), u2k(axe));
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mcj(Pt6, ut, peek)[] = {
    { ".2", c3__hevy,
        j2_mc(Pt6, ut, peek),
        Tier6_b_memo,
        u2_none, u2_none,
        j2_mck(Pt6, ut, peek), c3__peek
    },
    { }
  };
