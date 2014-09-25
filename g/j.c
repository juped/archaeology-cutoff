/* g/j.c
**
** This file is in the public domain.
*/
#include "all.h"

  /* _cj_count(): count and link dashboard entries.
  */
  static c3_w 
  _cj_count(u3_cs_core* par_u, u3_cs_core* dev_u)
  {
    c3_w len_l = 0;
    c3_w i_w;

    if ( dev_u ) {
      for ( i_w = 0; 0 != dev_u[i_w].cos_c; i_w++ ) {
        u3_cs_core* kid_u = &dev_u[i_w];

        kid_u->par_u = par_u;
        len_l += _cj_count(kid_u, kid_u->dev_u);
      }
    }
    return 1 + len_l;
  }
  /* _cj_install(): install dashboard entries.
  */
  static c3_w
  _cj_install(u3_cs_core* ray_u, c3_w jax_l, u3_cs_core* dev_u)
  {
    c3_w i_w;

    if ( dev_u ) {
      for ( i_w = 0; 0 != dev_u[i_w].cos_c; i_w++ ) {
        u3_cs_core* kid_u = &dev_u[i_w];

        kid_u->jax_l = jax_l;
        ray_u[jax_l++] = *kid_u;

        jax_l = _cj_install(ray_u, jax_l, kid_u->dev_u);
      }
    }
    return jax_l;
  }

/* u3_cj_boot(): initialize jet system.
*/
void
u3_cj_boot(void)
{
  c3_w jax_l;

  u3D.len_l =_cj_count(0, u3D.dev_u);
  u3D.all_l = (2 * u3D.len_l) + 64;     //  horrid heuristic

  u3D.ray_u = (u3_cs_core*) malloc(u3D.all_l * sizeof(u3_cs_core));
  memset(u3D.ray_u, 0, (u3D.all_l * sizeof(u3_cs_core)));

  jax_l = _cj_install(u3D.ray_u, 1, u3D.dev_u);
  printf("boot: installed %d jets\n", jax_l);
}

/* _cj_insert(): append copy of core driver to jet table.  For dummies.
*/
static c3_l
_cj_insert(u3_cs_core* cop_u)
{
  c3_l jax_l = u3D.len_l;

  u3D.len_l += 1;
  c3_assert(u3D.len_l < u3D.all_l);

  memcpy(&u3D.ray_u[jax_l], cop_u, sizeof(u3_cs_core));
  cop_u->jax_l = jax_l;

  return jax_l;
}

/* u3_cj_find(): search for jet.  `cor` is RETAINED.
*/
c3_l
u3_cj_find(u3_noun bat)
{
  u3_weak jax = u3_ch_get(u3R->jed.har_u, bat);

  if ( u3_none == jax ) {
    return 0;
  } else {
    u3_assure(u3_co_is_cat(jax));

    return (c3_l)jax;
  }
}

/* _cj_soft(): kick softly by arm axis.
*/
static u3_noun
_cj_soft(u3_noun cor, c3_l axe_l)
{
  u3_noun arm = u3_cx_at(axe_l, cor);

  return u3_cn_nock_on(cor, u3k(arm));
}

/* _cj_kick_a(): try to kick by jet.  If no kick, produce u3_none.
**
** `cor` is RETAINED iff there is no kick, TRANSFERRED if one.
*/
static u3_weak
_cj_kick_a(u3_noun cor, u3_cs_hood* hud_u, c3_l axe_l)
{
  u3_cs_harm* ham_u;

  if ( axe_l >= hud_u->len_w ) {
    return u3_none;
  }
  if ( !(ham_u = hud_u->ray_u[axe_l]) ) {
    return u3_none;
  }
  if ( 0 == ham_u->fun_f ) {
    return u3_none;
  }

  if ( u3_ne(ham_u->liv) ) {
    return u3_none;
  }
  else {
    if ( u3_so(ham_u->ice) ) {
      u3_weak pro = ham_u->fun_f(cor);

      if ( u3_none != pro ) {
        u3z(cor);
        return pro;
      }
    }
    else {
      u3_weak pro, ame;

      ham_u->ice = u3_yes;
      pro = ham_u->fun_f(u3k(cor));
      ham_u->ice = u3_no;

      if ( u3_none == pro ) {
        u3z(cor);
        return pro;
      }
      ham_u->liv = u3_no;
      ame = _cj_soft(cor, axe_l);
      ham_u->liv = u3_yes;

      if ( u3_no == u3_cr_sing(ame, pro) ) {
        printf("test: %s %s: mismatch: good %x, bad %x\r\n",
               ham_u->cop_u->cos_c,
               (!strcmp(".2", ham_u->fcs_c)) ? "$" : ham_u->fcs_c,
               u3_cr_mug(ame), 
               u3_cr_mug(pro));
       
        c3_assert(0);
        return u3_cm_bail(c3__fail);
      }
      else {
#if 1
        printf("test: %s %s\r\n",
               ham_u->cop_u->cos_c,
               (!strcmp(".2", ham_u->fcs_c)) ? "$" : ham_u->fcs_c);
#endif
      }
    }
    return u3_none;
  }
}

/* _cj_kick_b(): try to kick by jet.  If no kick, produce u3_none.
**
** `cor` is RETAINED iff there is no kick, TRANSFERRED if one.
*/
static u3_weak
_cj_kick_b(u3_noun cor, c3_l jax_l, c3_l axe_l)
{
  c3_l        mug_l = u3_cr_mug(u3h(cor));
  u3_cs_core* cop_u = &u3D.ray_u[jax_l];
  u3_cs_hood* hud_u = cop_u->hud_u;

  // printf("kick: %s\r\n", cop_u->cos_c);

  while ( 1 ) {
    if ( 0 == hud_u )                     { break; }
    if ( mug_l != hud_u->mug_l )          { hud_u = hud_u->nex_u; continue; }
    return _cj_kick_a(cor, hud_u, axe_l);
  }
  return u3_none;
}

/* _cj_hook_in(): execute hook from core, or fail.
*/
static u3_noun
_cj_hook_in(u3_noun     cor,
            const c3_c* tam_c,
            c3_o        jet_o)
{
  u3_noun bat   = u3h(cor);
  c3_l    jax_l = u3_cj_find(bat);

  // printf("hook: %s\n", tam_c);

  if ( 0 == jax_l ) { return 0; }
  else {
    u3_cs_core* cop_u = &u3D.ray_u[jax_l];

    while ( cop_u ) {
      u3_cs_hood* hud_u = cop_u->hud_u;
      c3_l        mug_l = u3_cr_mug(bat);

      while ( 1 ) {
        if ( 0 == hud_u )            { break; }
        if ( mug_l != hud_u->mug_l ) { break; hud_u = hud_u->nex_u; continue; }
        {
          u3_cs_hook* huk_u = hud_u->huk_u;

          while ( huk_u ) {
            if ( !strcmp(huk_u->nam_c, tam_c) ) {
              u3_noun pro; 

              if ( u3_so(jet_o) &&
                   (u3_none != (pro = _cj_kick_a(cor, hud_u, huk_u->axe_l))) )
              {
                return pro;
              } 
              else {
                return _cj_soft(cor, huk_u->axe_l);
              }
            }
            huk_u = huk_u->nex_u;
          }
        }
        hud_u = hud_u->nex_u;
      }

      //  For convenience, search in deeper cores.
      {
        if ( cop_u->axe_l && cop_u->par_u ) {
          u3_noun inn = u3_cr_at(cop_u->axe_l, cor);

          u3k(inn); u3z(cor); cor = inn; bat = u3h(cor);
          cop_u = cop_u->par_u;
        }
        else cop_u = 0;
      }
    }
  }
  u3z(cor);
  return u3_cm_bail(c3__fail);
}
/* u3_cj_soft(): execute soft hook.
*/
u3_noun
u3_cj_soft(u3_noun cor, 
           const c3_c* tam_c)
{
  return _cj_hook_in(cor, tam_c, u3_no);
}

/* u3_cj_hook(): execute hook from core, or fail.
*/
u3_noun
u3_cj_hook(u3_noun     cor,
           const c3_c* tam_c)
{
  return _cj_hook_in(cor, tam_c, u3_yes);
}

/* u3_cj_kick(): try to kick by jet.  If no kick, produce u3_none.
**
** `axe` is RETAINED by the caller; `cor` is RETAINED iff there 
** is no kick, TRANSFERRED if one.
*/
u3_weak
u3_cj_kick(u3_noun cor, u3_noun axe)
{
  c3_l axe_l, jax_l;
 
  if ( u3_ne(u3_co_is_cat(axe)) ) { 
    return u3_none;
  } 
  axe_l = axe;

  if ( 0 == (jax_l = u3_cj_find(u3h(cor))) ) { 
    return u3_none;
  }
  return _cj_kick_b(cor, jax_l, axe_l);
}

/* u3_cj_kink(): kick either by jet or by nock.
*/
u3_noun
u3_cj_kink(u3_noun cor,
           u3_noun axe)
{
  u3_weak pro = u3_cj_kick(cor, axe);

  if ( u3_none != pro ) {
    return pro;
  } else {
    return u3_cn_nock_on(cor, u3nq(9, axe, 0, 1));
  }
}

/* _cj_axis(): axis from formula, or 0.  `fol` is RETAINED.
*/
static c3_l
_cj_axis(u3_noun fol)
{
  u3_noun p_fol, q_fol, r_fol;

  while ( u3_so(u3du(fol)) && (10 == u3h(fol)) )
    { fol = u3t(u3t(fol)); }

  if ( u3_ne(u3_cr_trel(fol, &p_fol, &q_fol, &r_fol)) ) {
    if ( u3_ne(u3_cr_cell(fol, &p_fol, &q_fol)) ||
         (0 != p_fol) ||
         (u3_ne(u3_co_is_cat(q_fol))) )
    { 
      printf("axis: bad a\r\n"); 
      return 0;
    }
    return q_fol;
  }
  else {
    if ( 9 != p_fol )
      { printf("axis: bad b\r\n"); return 0; }
    if ( u3_ne(u3_co_is_cat(q_fol)) )
      { printf("axis: bad c\r\n"); return 0; }
    if ( u3_ne(u3du(r_fol)) || (0 != u3h(r_fol)) || (1 != u3t(r_fol)) )
      { printf("axis: bad d\r\n"); return 0; }

    return q_fol;
  }
}

/* _cj_activate(): activate jets in `cop` for `hud`.
*/
static void
_cj_activate(u3_cs_core* cop_u, u3_cs_hood* hud_u)
{
  c3_l max_l = 0;

  /* Check for mismatched duplicates - very unlikely.
  */
  {
    u3_cs_hood* duh_u = cop_u->hud_u;

    while ( duh_u ) {
      if ( duh_u->mug_l == hud_u->mug_l ) {
        printf("jets: mug collision!\r\n");
        return;
      }
      duh_u = duh_u->nex_u;
    }
  }

  /* Compute axes of all correctly declared arms.
  */
  if ( cop_u->arm_u ) {
    c3_l i_l = 0;

    while ( 1 ) {
      u3_cs_harm* jet_u = &cop_u->arm_u[i_l];

      jet_u->cop_u = cop_u;
      if ( 0 == jet_u->fcs_c ) {
        break;
      } 
      else {
        c3_l axe_l = 0;
        if ( '.' == *(jet_u->fcs_c) ) {
          c3_d axe_d = 0;

          if ( (1 != sscanf(jet_u->fcs_c+1, "%llu", &axe_d)) ||
               axe_d >> 32ULL ||
               ((1 << 31) & (axe_l = (c3_w)axe_d)) ||
               (axe_l < 2) )
          {
            printf("jets: activate: bad fcs %s\r\n", jet_u->fcs_c);
          }
        }
        else {
          u3_cs_hook* huk_u = hud_u->huk_u;

          while ( huk_u ) {
            if ( !strcmp(huk_u->nam_c, jet_u->fcs_c) ) {
              axe_l = huk_u->axe_l;
              break;
            }
            huk_u = huk_u->nex_u;
          }
        }
        max_l = c3_max(max_l, axe_l);
        jet_u->axe_l = axe_l;
      }
      i_l++;
    }
  
    /* Allocate jet table for this battery.
    */
    {
      c3_w i_l;

      if ( !max_l ) {
        hud_u->len_w = 0;
      }
      else {
        hud_u->len_w = (max_l + 1);
        hud_u->ray_u = malloc(hud_u->len_w * (sizeof(u3_cs_harm *)));

        for ( i_l = 0; i_l < hud_u->len_w; i_l++ ) {
          hud_u->ray_u[i_l] = 0;
        }
      }
    }

    /* Fill jet table.
    */
    {
      c3_l i_l = 0;

      while ( 1 ) {
        u3_cs_harm* jet_u = &cop_u->arm_u[i_l];

        if ( !jet_u->fcs_c ) break;
        if ( jet_u->axe_l ) {
          hud_u->ray_u[jet_u->axe_l] = jet_u;
        }
        i_l++;
      }
    }
  }
 
  /* Link in new battery record.
  */
  {
    hud_u->nex_u = cop_u->hud_u;
    cop_u->hud_u = hud_u;
  }
}

/* _cj_chum(): decode chum as string.
*/
static c3_c* 
_cj_chum(u3_noun chu)
{
  if ( u3_so(u3ud(chu)) ) {
    return u3_cr_string(chu);
  } 
  else {
    u3_noun h_chu = u3h(chu);
    u3_noun t_chu = u3t(chu);
    
    if ( u3_ne(u3_co_is_cat(t_chu)) ) {
      return 0;
    } else {
      c3_c* h_chu_c = u3_cr_string(h_chu);
      c3_c  buf[33];

      memset(buf, 0, 33);
      snprintf(buf, 32, "%s%d", h_chu_c, t_chu);

      free(h_chu_c);
      return strdup(buf);
    }
  }
}

/* u3_cj_clear(): clear jet table to re-register.
*/
void
u3_cj_clear(void)
{
  u3_ch_free(u3R->jed.har_u);
  u3R->jed.har_u = u3_ch_new();
}

/* u3_cj_mine(): register core for jets.
*/
u3_noun
u3_cj_mine(u3_noun clu,
           u3_noun cor)
{
  if ( u3_none != u3_ch_get(u3R->jed.har_u, u3h(cor)) ) {
    u3z(clu);
    return cor;
  }
  else {
    u3_noun     p_clu, q_clu, r_clu;
    u3_cs_hook* huk_u;
    u3_cs_hood* hud_u;
    c3_c*       nam_c;
    c3_l        axe_l, par_l;
    u3_noun     pab;

    if ( u3_no == u3_cr_trel(clu, &p_clu, &q_clu, &r_clu) )
      { printf("mine: bad z\r\n"); u3z(clu); return cor; }
    if ( 0 == (nam_c = _cj_chum(p_clu)) ) 
      { printf("mine: bad a\r\n"); u3z(clu); return cor; }

    printf("mine: chum: %s\r\n", nam_c);

    while ( u3_so(u3du(q_clu)) && (10 == u3h(q_clu)) ) { 
      q_clu = u3t(u3t(q_clu));
    }

    if ( u3_ne(u3du(q_clu)) )
      { printf("mine: bad b\r\n"); u3z(clu); return cor; }

    if ( (1 == u3h(q_clu)) && (0 == u3t(q_clu)) ) {
      axe_l = 0;
    }
    else {
      if ( (0 != u3h(q_clu)) )
        { printf("mine: bad c\r\n"); u3z(clu); return cor; c3_assert(0); }
      if ( u3_ne(u3_co_is_cat(axe_l = u3t(q_clu))) )
        { printf("mine: bad d\r\n"); u3z(clu); return cor; }
    }

    if ( 0 != axe_l ) {
      if ( (u3_none == (pab = u3_cr_at(axe_l, cor))) )
        { printf("mine: bad e\r\n"); u3z(clu); return cor; }

      if ( (0 == (par_l = u3_cj_find(u3h(pab)))) ) 
        { 
          printf("mine: bad f\r\n"); 
          printf("battery mug %x\r\n", u3_cr_mug(u3h(pab)));

          u3z(clu); 
          c3_assert(0); 
          return cor;
        }
      else {
        // printf("parent %d, mug %x\r\n", par_l, u3_cr_mug(u3h(pab)));
      }
    }

    huk_u = 0;
    while ( 0 != r_clu ) {
      u3_noun ir_clu, tr_clu, pir_clu, qir_clu;
      u3_cs_hook* kuh_u;
      c3_l        kax_l;

      if ( u3_no == u3_cr_cell(r_clu, &ir_clu, &tr_clu) )
        { printf("mine: bad g\r\n"); u3z(clu); return cor; }
      if ( u3_no == u3_cr_cell(ir_clu, &pir_clu, &qir_clu) )
        { printf("mine: bad h\r\n"); u3z(clu); return cor; }
      if ( u3_ne(u3ud(pir_clu)) )
        { printf("mine: bad i\r\n"); u3z(clu); return cor; }
      if ( 0 == (kax_l = _cj_axis(qir_clu)) ) 
        { printf("mine: bad j\r\n"); u3z(clu); return cor; }

      kuh_u = malloc(sizeof(u3_cs_hook));
      kuh_u->nam_c = u3_cr_string(pir_clu);
      kuh_u->axe_l = kax_l;

      kuh_u->nex_u = huk_u;
      huk_u = kuh_u;
      r_clu = tr_clu;
    }
    hud_u = malloc(sizeof(u3_cs_hood));
    hud_u->mug_l = u3_cr_mug(u3h(cor));
    hud_u->len_w = 0;
    hud_u->ray_u = 0;
    hud_u->huk_u = huk_u;
    hud_u->nex_u = 0;

    // Find the child, if possible, in the parent.  Otherwise, 
    // register it to avoid slow repeated search.
    //
    { 
      u3_cs_core* par_u = axe_l ? &u3D.ray_u[par_l] : 0;
      u3_cs_core* dev_u = par_u ? par_u->dev_u : u3_Dash.dev_u;
      c3_l        jax_l = 0;
      c3_w        i_l = 0;

      if ( dev_u ) {
        while ( 1 ) {
          u3_cs_core* cop_u = &dev_u[i_l];

          if ( 0 == cop_u->cos_c ) { break; }
          if ( !strcmp(cop_u->cos_c, nam_c) ) {
            jax_l = cop_u->jax_l;
            u3D.ray_u[jax_l].axe_l = axe_l;
            u3D.ray_u[jax_l].par_u = par_u;
            c3_assert(0 != jax_l);
            free(nam_c);

            printf("mine: bound jet %d/%s\r\n", 
                cop_u->jax_l, cop_u->cos_c);
            break;
          }
          i_l++;
        }
      }

      if ( 0 == jax_l ) {
        u3_cs_core fak_u;

        memset(&fak_u, 0, sizeof(u3_cs_core));
        fak_u.cos_c = nam_c;
        fak_u.par_u = par_u;
        fak_u.axe_l = axe_l;

        jax_l = _cj_insert(&fak_u);
        printf("mine: dummy jet %d/%s\r\n", jax_l, fak_u.cos_c);
      }
      u3_ch_put(u3R->jed.har_u, u3h(cor), jax_l);
      u3z(clu);

      _cj_activate(&u3D.ray_u[jax_l], hud_u);

#if 0
      {
        u3_cs_core* cop_u = &u3D.ray_u[jax_l];
        u3_cs_core* par_u = cop_u->par_u;

        printf("cop %s/%p/%d; par_u %p/%s/%d/%p; hud_u %p\n\n",
              cop_u->cos_c, cop_u, jax_l, 
              par_u, par_u ? par_u->cos_c : "none", 
              par_l,
              par_l ? &u3D.ray_u[par_l] : 0,
              cop_u->hud_u);
      }
#endif
      return cor;
    }
  }
}
