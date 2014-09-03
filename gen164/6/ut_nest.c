/* j/6/ut_nest.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* logic
*/
  /* forward
  */
    static u2_bean
    _nest_sint(u2_noun, u2_noun, u2_bean, u2_noun, u2_noun);
    static u2_bean
    _nest_dext(u2_noun, u2_noun, u2_bean, u2_noun, u2_noun);

  static u2_bean
  _nest_cram(
             u2_noun van,
             u2_noun sut,
             u2_bean tel,
             u2_noun ref,
             u2_noun dab,
             u2_noun hem,
             u2_noun gil)
  {
    if ( u2_nul == dab ) {
      return u2_cr_sing(u2_nul, hem);
    } else if ( u2_nul == hem ) {
      return u2_no;
    } else {
      u2_noun n_dab, l_dab, r_dab;
      u2_noun n_hem, l_hem, r_hem;
      u2_noun pn_hem, qn_hem, pn_dab, qn_dab;

      u2_cx_trel(dab, &n_dab, &l_dab, &r_dab);
      u2_cx_trel(hem, &n_hem, &l_hem, &r_hem);

      if ( (u2_no == _nest_cram
                        (van, sut, tel, ref, l_dab, l_hem, gil)) ||
           (u2_no == _nest_cram
                        (van, sut, tel, ref, r_dab, r_hem, gil)) ) {
        return u2_no;
      }
      u2_cx_cell(n_dab, &pn_dab, &qn_dab);
      u2_cx_cell(n_hem, &pn_hem, &qn_hem);

      if ( u2_no == u2_cr_sing(pn_dab, pn_hem) ) {
        return u2_no;
      } else {
        if ( (u2_no == u2du(qn_dab)) || (u2_no == u2du(qn_hem)) ) {
          return u2_cm_bail(c3__fail);
        }
        else switch ( u2h(qn_dab) ) {
          default: return u2_cm_bail(c3__exit);
          case c3__ash: {
            if ( c3__ash != u2h(qn_hem) ) {
              return u2_no;
            } else {
              u2_noun pqn_dab = u2t(qn_dab);
              u2_noun pqn_hem = u2t(qn_hem);
              u2_noun vis = u2_cqfu_play(van, sut, pqn_dab);
              u2_noun lon = u2_cqfu_play(van, ref, pqn_hem);
              u2_bean ret = _nest_dext(van, vis, tel, lon, gil);

              u2z(vis);
              u2z(lon);
              return ret;
            }
          }
          case c3__elm: {
            return u2_cr_sing(qn_dab, qn_hem);
          }
        }
      }
    }
  }

  static u2_bean
  _nest_cong(
             u2_noun van,
             u2_noun sut,
             u2_bean tel,
             u2_noun ref,
             u2_noun gil)
  {
    u2_noun p_sut, q_sut, p_ref, q_ref;
    u2_noun pq_sut, qq_sut, rq_sut;
    u2_noun pq_ref, qq_ref, rq_ref;
    u2_noun prq_sut, qrq_sut, prq_ref, qrq_ref;
    u2_bean ret;

    u2_cx_trel(sut, 0, &p_sut, &q_sut);
    u2_cx_trel(ref, 0, &p_ref, &q_ref);

    u2_cx_trel(q_sut, &pq_sut, &qq_sut, &rq_sut);
    u2_cx_trel(q_ref, &pq_ref, &qq_ref, &rq_ref);

    u2_cx_cell(rq_sut, &prq_sut, &qrq_sut);
    u2_cx_cell(rq_ref, &prq_ref, &qrq_ref);

    if ( u2_yes == u2_cr_sing(q_sut, q_ref) ) {
      return _nest_dext(van, p_sut, tel, p_ref, gil);
    }
    else if ( (u2_no == _nest_dext(van, qq_sut, tel, p_sut, gil)) ||
              (u2_no == _nest_dext(van, p_sut, tel, qq_sut, gil)) ||
              (u2_no == _nest_dext(van, qq_ref, tel, p_ref, gil)) )
    {
      return u2_no;
    }
    else {
      if ( (pq_sut != pq_ref) && (c3__gold != pq_ref) ) {
        return u2_no;
      }
      else {
        u2_noun hud = u2nc(u2k(sut), u2k(ref));

        if ( (u2_yes == u2_cqdi_has(gil, hud)) ) {
          u2z(hud);

          return u2_yes;
        }
        else {
          u2_noun zoc = u2_cqdi_put(gil, hud);
          u2_noun tus = u2nt(c3__core,
                                     u2k(qq_sut),
                                     u2k(q_sut));
          u2_noun fer = u2nt(c3__core,
                                     u2k(qq_ref),
                                     u2k(q_ref));

          ret = _nest_cram(van, tus, tel, fer, qrq_sut, qrq_ref, zoc);
          u2z(fer);
          u2z(tus);
          u2z(zoc);
          u2z(hud);

          if ( u2_no == ret ) {
            return u2_no;
          }
          else {
            switch ( pq_sut ) {
              default: return u2_cm_bail(c3__fail);

              case c3__gold: {
                return
                  u2_and(_nest_dext(van, qq_sut, tel, qq_ref, gil),
                         _nest_dext(van, qq_ref, tel, qq_sut, gil));
              }
              case c3__iron: {
                u2_noun s_sam = u2_cqfu_peek
                                        (van, qq_sut, c3__rite, 2);
                u2_noun r_sam = u2_cqfu_peek
                                        (van, qq_ref, c3__rite, 2);
                u2_bean ret = _nest_dext(van, r_sam, tel, s_sam, gil);

                u2z(r_sam);
                u2z(s_sam);
                return ret;
              }
              case c3__lead: {
                return u2_yes;
              }
              case c3__zinc: {
                u2_noun s_pal = u2_cqfu_peek
                                        (van, qq_sut, c3__read, 2);
                u2_noun r_pal = u2_cqfu_peek
                                        (van, qq_ref, c3__read, 2);
                u2_bean ret = _nest_dext(van, s_pal, tel, r_pal, gil);

                u2z(r_pal);
                u2z(s_pal);

                return ret;
              }
            }
          }
        }
      }
    }
  }

  static u2_bean
  _nest_dext_in(
                u2_noun van,
                u2_noun sut,
                u2_bean tel,
                u2_noun ref,
                u2_noun gil)
  {
    u2_noun p_sut, q_sut, p_ref, q_ref;

    if ( (u2_no == u2du(sut)) ) switch ( sut ) {
      default: return u2_cm_bail(c3__fail);

      case c3__noun: {
        return u2_yes;
      }
      case c3__void: {
        return _nest_sint(van, sut, tel, ref, gil);
      }
    }
    else switch ( u2h(sut) ) {
      default: return u2_cm_bail(c3__fail);

      case c3__atom: {
        if ( (u2_yes == u2du(ref)) && (c3__atom == u2h(ref)) ) {
          if ( u2_no == u2_cqf_fitz(u2t(sut), u2t(ref)) ) {
            // u2_err("fitz: need", u2t(sut));
            // u2_err("fitz: have", u2t(ref));
            return u2_no;
          }
          return u2_yes;
        }
        else return _nest_sint(van, sut, tel, ref, gil);
      }
      case c3__bull: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          return _nest_dext(van, q_sut, tel, ref, gil);
        }
      }
      case c3__cell: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          if ( u2_yes == u2_cr_pq(ref, c3__cell, &p_ref, &q_ref) ) {
            return u2_and(_nest_dext(van, p_sut, tel, p_ref, gil),
                          _nest_dext(van, q_sut, tel, q_ref, gil));
          }
          else return _nest_sint(van, sut, tel, ref, gil);
        }
      }
      case c3__core: {
        if ( u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut) ) {
          return u2_cm_bail(c3__fail);
        } else {
          if ( (u2_yes == u2_cr_pq(ref, c3__core, &p_ref, &q_ref)) ) {
            return _nest_cong(van, sut, tel, ref, gil);
          }
          else return _nest_sint(van, sut, tel, ref, gil);
        }
      }
      case c3__cube: {
        if ( u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut) ) {
          return u2_cm_bail(c3__fail);
        } else {
          if ( u2_yes == u2_cr_pq(ref, c3__cube, &p_ref, &q_ref) ) {
            return u2_cr_sing(p_sut, p_ref);
          }
          else return _nest_sint(van, sut, tel, ref, gil);
        }
      }
      case c3__face: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        } else {
          return _nest_dext(van, q_sut, tel, ref, gil);
        }
      }
      case c3__fork: {
        if ( (u2_no == u2_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u2_cm_bail(c3__fail);
        }
        else {
          if ( u2_no == u2du(ref) ) switch ( ref ) {
            default: return _nest_sint(van, sut, tel, ref, gil);

            case c3__noun:
              break;
          }
          else switch ( u2h(ref) ) {
            default: return _nest_sint(van, sut, tel, ref, gil);

            case c3__atom:
            case c3__cell:
            case c3__cube:
            case c3__core:
              break;
          }

          return u2_or(_nest_dext(van, p_sut, u2_no, ref, gil),
                       _nest_dext(van, q_sut, u2_no, ref, gil));
        }
      }
      case c3__hold: p_sut = u2t(sut);
      {
        u2_noun hud = u2nc(u2k(sut),
                                   u2k(ref));

        if ( (u2_yes == u2_cqdi_has(gil, hud)) ) {
          u2z(hud);

          return u2_yes;
        } else {
          u2_noun zoc = u2_cqdi_put(gil, hud);
          u2_noun fop = u2_cqfu_rest(van, sut, p_sut);
          u2_bean hiv = _nest_dext(van, fop, tel, ref, zoc);

          u2z(hud);
          u2z(fop);
          u2z(zoc);

          return hiv;
        }
      }
    }
  }

  static u2_bean
  _nest_dext_to(
                u2_noun van,
                u2_noun sut,
                u2_bean tel,
                u2_noun ref,
                u2_noun gil)
  {
    u2_bean tyn = _nest_dext_in(van, sut, tel, ref, gil);

    if ( (u2_yes == tyn) || (u2_no == tel) ) {
      return tyn;
    } else {
      // u2_noun dun = u2_cqfu_dunq(van, "need", sut);
      // u2_noun niz = u2_cqfu_dunq(van, "have", ref);

      // u2_ct_push(u2nc(c3__mean, dun));
      // u2_ct_push(u2nc(c3__mean, niz));

      return u2_cm_error("type-fail");
    }
  }

  static u2_bean
  _nest_dext(
             u2_noun van,
             u2_noun sut,
             u2_bean tel,
             u2_noun ref,
             u2_noun gil)
  {
    if ( (u2_yes == u2_cr_sing(sut, ref)) ) {
      return u2_yes;
    }

    {
      c3_m    fun_m = c3__nest;
      u2_noun pro   = u2_cz_find_2(fun_m, sut, ref);

      if ( u2_none != pro ) {
        return pro;
      }
      else {
        pro = _nest_dext_to(van, sut, tel, ref, gil);

        return u2_cz_save_2(fun_m, sut, ref, pro);
      }
    }
  }

  static u2_bean
  _nest_sint(
             u2_noun van,
             u2_noun sut,
             u2_bean tel,
             u2_noun ref,
             u2_noun gil)
  {
    u2_noun p_ref, q_ref;

    if ( (u2_no == u2du(ref)) ) {
      switch ( ref ) {
        default: return u2_cm_bail(c3__fail);

        case c3__noun: return u2_no;
        case c3__void: return u2_yes;
      }
    }
    else {
      switch ( u2h(ref) ) {
        default: {
          return u2_cm_bail(c3__fail);
        }
        case c3__atom: return u2_no;
        case c3__bull: {
          if ( u2_no == u2_cr_trel(ref, 0, &p_ref, &q_ref) ) {
            return u2_cm_bail(c3__fail);
          } else {
            return _nest_dext(van, sut, tel, q_ref, gil);
          }
        }
        case c3__cell: return u2_no;
        case c3__core: {
          u2_noun gam = u2_cqfu_repo(van, ref);
          u2_bean hiv = _nest_dext(van, sut, tel, gam, gil);

          u2z(gam);
          return hiv;
        }
        case c3__cube: {
          if ( u2_no == u2_cr_trel(ref, 0, &p_ref, &q_ref) ) {
            return u2_cm_bail(c3__fail);
          } else {
            return _nest_dext(van, sut, tel, q_ref, gil);
          }
        }
        case c3__face: {
          if ( u2_no == u2_cr_trel(ref, 0, &p_ref, &q_ref) ) {
            return u2_cm_bail(c3__fail);
          } else {
            return _nest_dext(van, sut, tel, q_ref, gil);
          }
        }
        case c3__fork: {
          if ( (u2_yes == u2_cr_mean(ref, 6, &p_ref, 7, &q_ref, 0)) ) {
            return u2_and(_nest_dext(van, sut, u2_no, p_ref, gil),
                          _nest_dext(van, sut, u2_no, q_ref, gil));
          }
          else return u2_cm_bail(c3__fail);
        }
        case c3__hold: {
          p_ref = u2t(ref);
          {
            u2_noun hud = u2nc(u2k(sut),
                                       u2k(ref));

            if ( (u2_yes == u2_cqdi_has(gil, hud)) ) {
              u2z(hud);

              return u2_yes;
            } else {
              u2_noun zoc = u2_cqdi_put(gil, hud);
              u2_noun gam = u2_cqfu_repo(van, ref);

              {
                u2_bean hiv = _nest_dext(van, sut, tel, gam, zoc);

                u2z(hud);
                u2z(gam);
                u2z(zoc);

                return hiv;
              }
            }
          }
        }
      }
    }
  }

  u2_bean                                                         //  transfer
  _cqfu_nest(
                        u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_bean tel,                              //  retain
                        u2_noun ref)                              //  retain
  {
    return _nest_dext(van, sut, tel, ref, u2_nul);
  }

/* boilerplate
*/
  u2_noun                                                         //  transfer
  u2_cwfu_nest(u2_noun cor)                               //  retain
  {
    u2_noun sut, tel, ref, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &tel,
                                u2_cv_sam_3, &ref,
                                u2_cv_con, &van,
                                0)) ||
         (u2_no == u2ud(tel)) || (tel > 1) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return _cqfu_nest(van, sut, tel, ref);
    }
  }

  u2_noun                                                         //  transfer
  u2_cqfu_nest(u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_bean tel,                              //  retain
                        u2_noun ref)                              //  retain
  {
    return _cqfu_nest(van, sut, tel, ref);
  }

  u2_weak
  j2_mck(Pt6, ut, nest)(u2_noun cor)
  {
    u2_noun sut, ref, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_3, &ref, u2_cv_con, &van, &ref, 0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_none;
    } else {
      return u2nc(u2k(sut), u2k(ref));
    }
  }
