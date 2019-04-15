#include "doublejump.qh"

#ifdef GAMEQC
#ifdef SVQC
	#include <server/antilag.qh>
#endif
#include <common/physics/player.qh>

#ifdef SVQC
REGISTER_MUTATOR(doublejump, autocvar_sv_doublejump);
#elif defined(CSQC)
REGISTER_MUTATOR(doublejump, true);
#endif

/*qc2rust::define::PHYS_DOUBLEJUMP*/
#define PHYS_DOUBLEJUMP(s) /*qc2rust::macro_begin::PHYS_DOUBLEJUMP*/STAT(DOUBLEJUMP,  /*qc2rust::param_begin::s*/s /*qc2rust::param_end::s*/) /*qc2rust::macro_end::PHYS_DOUBLEJUMP*/


MUTATOR_HOOKFUNCTION(doublejump, PlayerJump)
{
    entity player = M_ARGV(0, entity);

	if (PHYS_DOUBLEJUMP(player))
	{
		tracebox(player.origin + '0 0 0.01', player.mins, player.maxs, player.origin - '0 0 0.01', MOVE_NORMAL, player);
		if (trace_fraction < 1 && trace_plane_normal_z > 0.7)
		{
			M_ARGV(2, bool) = true;

			// we MUST clip velocity here!
			float f = player.velocity * trace_plane_normal;
			if (f < 0)
				player.velocity -= f * trace_plane_normal;
		}
	}
}
#endif
