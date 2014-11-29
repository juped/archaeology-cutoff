/* g/t.c
**
** This file is in the public domain.
*/
#include "all.h"

/* u3t_push(): push on trace stack.
*/
void
u3t_push(u3_noun mon)
{
  u3R->bug.tax = u3nc(mon, u3R->bug.tax);
}

/* u3t_mean(): push `[%mean roc]` on trace stack.
*/
void
u3t_mean(u3_noun roc)
{
  u3R->bug.tax = u3nc(u3nc(c3__mean, roc), u3R->bug.tax);
}

/* u3t_drop(): drop from meaning stack.
*/
void
u3t_drop(void)
{
  c3_assert(_(u3du(u3R->bug.tax)));
  {
    u3_noun tax = u3R->bug.tax;

    u3R->bug.tax = u3k(u3t(tax));
    u3z(tax);
  }
}

extern void
u3_lo_tank(c3_l tab_l, u3_noun tac);

/* u3t_slog(): print directly.
*/
void
u3t_slog(u3_noun hod)
{
  if ( c3y == u3du(hod) ) {
    u3_noun pri = u3h(hod);

    switch ( pri ) {
      case 3: printf(">>> "); break;
      case 2: printf(">> "); break;
      case 1: printf("> "); break;
    }
    u3_lo_tank(0, u3k(u3t(hod)));
  }
  u3z(hod);
}

/* u3t_heck(): profile point.
*/
void
u3t_heck(u3_atom cog)
{
  //  Profile sampling, because it allocates on the home road,
  //  only works on when we're not at home.
  //
  if ( &(u3H->rod_u) != u3R ) {
    u3a_road* rod_u;
   
    rod_u = u3R;
    u3R = &(u3H->rod_u);
    {

      if ( 0 == u3R->pro.day ) { 
        u3R->pro.day = u3v_do("doss", 0);
      }
      u3R->pro.day = u3dc("pi-heck", cog, u3R->pro.day);
    }
    u3R = rod_u;
  }
}

/* _t_samp_process(): process raw sample data from live road.
*/
static u3_noun
_t_samp_process(u3_road* rod_u)
{
  u3_noun pef   = u3_nul;           // (list (pair path (map path ,@ud)))
  u3_noun muf   = u3_nul;           // (map path ,@ud)
  c3_w    len_w = 0;

  //  Accumulate a label/map stack which collapses recursive segments.
  //
  while ( rod_u ) {
    u3_noun don = rod_u->pro.don;

    while ( u3_nul != don ) {
      u3_noun bat = u3h(don);
      u3_noun lab;

      //  Find the label from this battery, surface allocated.
      //
      {
        u3R = rod_u;
        {
          u3_noun cax;

          if ( u3_none == (cax = u3j_find(bat)) ) {
            abort(); // probably a little drastic
          }
          lab = u3h(u3t(u3t(cax)));
        }
        u3R = &u3H->rod_u;

        lab = u3a_take(lab);
      }

      //  Add the label to the traced label stack, trimming recursion.
      //  
      {
        u3_noun old;

        if ( u3_none == (old = u3kdb_get(u3k(muf), u3k(lab))) ) {
          muf = u3kdb_put(muf, u3k(lab), len_w);
          pef = u3nc(u3nc(lab, u3k(muf)), pef);
          len_w += 1;
        }
        else {
          u3_assure(u3a_is_cat(old));

          u3z(muf);
          while ( len_w > (old + 1) ) {
            u3_noun t_pef = u3k(u3t(pef));
 
            len_w -= 1;
            u3z(pef);
            pef = t_pef;
          }
          muf = u3k(u3t(u3h(pef)));
        }
      }
      don = u3t(don);
    }
  }
  
  //  Lose the maps and save a pure label stack in original order.
  //
  {
    u3_noun pal = u3_nul;

    while ( u3_nul != pef ) {
      u3_noun h_pef = u3h(pef);
      u3_noun t_pef = u3k(u3t(pef));

      pal = u3nc(u3k(u3h(h_pef)), pal);

      u3z(pef);
      pef = t_pef;
    }

    return pal;
  }
}

/* u3t_samp(): sample.
*/
void
u3t_samp(void)
{
  //  Profile sampling, because it allocates on the home road,
  //  only works on when we're not at home.
  //
  if ( &(u3H->rod_u) != u3R ) {
    u3a_road* rod_u;
   
    rod_u = u3R;
    u3R = &(u3H->rod_u);
    {
      u3_noun lab = _t_samp_process(rod_u);
  
      c3_assert(u3R == &u3H->rod_u);
      if ( 0 == u3R->pro.day ) { 
        u3R->pro.day = u3v_do("doss", 0);
      }
      u3R->pro.day = u3dc("pi-noon", lab, u3R->pro.day);
    }
    u3R = rod_u;
  }
}

/* u3t_come(): push on profile stack; return yes if active push.  RETAIN.
*/
c3_o
u3t_come(u3_noun bat)
{
  if ( (u3_nul == u3R->pro.don) || !_(u3r_sing(bat, u3h(u3R->pro.don))) ) {
    u3R->pro.don = u3nc(u3k(bat), u3R->pro.don);
    return c3y;
  } 
  else return c3n;
}

/* u3t_flee(): pop off profile stack.
*/
void
u3t_flee(void)
{
  u3_noun t_don = u3k(u3t(u3R->pro.don));

  u3z(u3R->pro.don);
  u3R->pro.don = t_don;
}

/* u3t_damp(): print and clear profile data.
*/
void
u3t_damp(void)
{
  if ( 0 != u3R->pro.day ) {
    u3_noun wol = u3do("pi-tell", u3R->pro.day);
    u3m_wall(wol);

    u3R->pro.day = u3v_do("doss", 0);
  }

  if ( 0 != u3R->pro.nox_d ) {
    printf("knox: %llu\r\n", (u3R->pro.nox_d / 1000ULL));
    u3R->pro.nox_d = 0;
  }
}

/* _ct_sigaction(): profile sigaction callback.
*/
void _ct_sigaction(c3_i x_i) { u3t_samp(); } 

/* u3t_boot(): turn sampling on.
*/
void
u3t_boot(void)
{
  if ( u3C.wag_w & u3o_debug_cpu ) {
    printf("ct: now profiling.\r\n");

    printf("knox: %llu\r\n", (u3R->pro.nox_d / 1000ULL));
    u3R->pro.nox_d = 0;

#if defined(U3_OS_osx)
#if 1
    {
      struct itimerval itm_v;
      struct sigaction sig_s;

      sig_s.__sigaction_u.__sa_handler = _ct_sigaction;
      sig_s.sa_mask = 0;
      sig_s.sa_flags = 0;
      sigaction(SIGPROF, &sig_s, 0);

      itm_v.it_interval.tv_sec = 0;
      //  itm_v.it_interval.tv_usec = 10000;
      itm_v.it_interval.tv_usec = 100000;
      itm_v.it_value = itm_v.it_interval;

      setitimer(ITIMER_PROF, &itm_v, 0);
    }
#endif
#elif defined(U3_OS_linux)
    // TODO: support profiling on linux
#elif defined(U3_OS_bsd)
    // TODO: support profiling on bsd
#else
#   error "port: profiling"
#endif
  }
}

/* u3t_boff(): turn profile sampling off.
*/
void
u3t_boff(void)
{
  if ( u3C.wag_w & u3o_debug_cpu ) {
#if defined(U3_OS_osx)
    struct sigaction sig_s;
    struct itimerval itm_v;

    printf("ct: end profiling.\r\n");

    itm_v.it_interval.tv_sec = 0;
    itm_v.it_interval.tv_usec = 0;
    itm_v.it_value = itm_v.it_interval;

    setitimer(ITIMER_PROF, &itm_v, 0);
    sigaction(SIGPROF, &sig_s, 0);

    u3t_damp();
#elif defined(U3_OS_linux)
    // TODO: support profiling on linux
#elif defined(U3_OS_bsd)
    // TODO: support profiling on bsd
#else
#   error "port: profiling"
#endif
  }
}
