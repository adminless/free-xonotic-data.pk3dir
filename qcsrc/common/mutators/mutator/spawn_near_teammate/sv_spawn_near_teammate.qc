#include "sv_spawn_near_teammate.qh"

#include <lib/float.qh>

string autocvar_g_spawn_near_teammate;
float autocvar_g_spawn_near_teammate_distance;
int autocvar_g_spawn_near_teammate_ignore_spawnpoint;
int autocvar_g_spawn_near_teammate_ignore_spawnpoint_max;
float autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay;
float autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay_death;
bool autocvar_g_spawn_near_teammate_ignore_spawnpoint_check_health;
bool autocvar_g_spawn_near_teammate_ignore_spawnpoint_closetodeath;

REGISTER_MUTATOR(spawn_near_teammate, expr_evaluate(autocvar_g_spawn_near_teammate));

.entity msnt_lookat;

.float msnt_timer;

.float cvar_cl_spawn_near_teammate;

MUTATOR_HOOKFUNCTION(spawn_near_teammate, Spawn_Score)
{
	if (!teamplay) return;

	entity player = M_ARGV(0, entity);
	entity spawn_spot = M_ARGV(1, entity);
	vector spawn_score = M_ARGV(2, vector);

	if(autocvar_g_spawn_near_teammate_ignore_spawnpoint == 1 || (autocvar_g_spawn_near_teammate_ignore_spawnpoint == 2 && CS(player).cvar_cl_spawn_near_teammate))
		return;

	spawn_spot.msnt_lookat = NULL;

	RandomSelection_Init();
	FOREACH_CLIENT(IS_PLAYER(it) && it != player && SAME_TEAM(it, player) && !IS_DEAD(it), {
		if(vdist(spawn_spot.origin - it.origin, >, autocvar_g_spawn_near_teammate_distance))
			continue;
		if(vdist(spawn_spot.origin - it.origin, <, 48))
			continue;
		if(!checkpvs(spawn_spot.origin, it))
			continue;
		RandomSelection_AddEnt(it, 1, 1);
	});

	if(RandomSelection_chosen_ent)
	{
		spawn_spot.msnt_lookat = RandomSelection_chosen_ent;
		spawn_score.x += SPAWN_PRIO_NEAR_TEAMMATE_FOUND;
	}
	else if(player.team == spawn_spot.team)
		spawn_score.x += SPAWN_PRIO_NEAR_TEAMMATE_SAMETEAM; // prefer same team, if we can't find a spawn near teammate

	M_ARGV(2, vector) = spawn_score;
}

MUTATOR_HOOKFUNCTION(spawn_near_teammate, PlayerSpawn)
{
	if (!teamplay) return;

	entity player = M_ARGV(0, entity);
	entity spawn_spot = M_ARGV(1, entity);

	int num_red = 0, num_blue = 0, num_yellow = 0, num_pink = 0;
	FOREACH_CLIENT(IS_PLAYER(it),
	{
		switch(it.team)
		{
			case NUM_TEAM_1: ++num_red; break;
			case NUM_TEAM_2: ++num_blue; break;
			case NUM_TEAM_3: ++num_yellow; break;
			case NUM_TEAM_4: ++num_pink; break;
		}
	});

	if(num_red == 1 || num_blue == 1 || num_yellow == 1 || num_pink == 1)
		return; // at least 1 team has only 1 player, let's not give the bigger team too much of an advantage!

	// Note: when entering this, fixangle is already set.
	if(autocvar_g_spawn_near_teammate_ignore_spawnpoint == 1 || (autocvar_g_spawn_near_teammate_ignore_spawnpoint == 2 && CS(player).cvar_cl_spawn_near_teammate))
	{
		if(autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay_death)
			player.msnt_timer = time + autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay_death;

		entity best_mate = NULL;
		vector best_pos = '0 0 0';
		float best_dist2 = FLOAT_MAX;
		int tested = 0;
		FOREACH_CLIENT_RANDOM(IS_PLAYER(it), {
			if (autocvar_g_spawn_near_teammate_ignore_spawnpoint_max && tested >= autocvar_g_spawn_near_teammate_ignore_spawnpoint_max) break;

			if (PHYS_INPUT_BUTTON_CHAT(it)) continue;
			if (DIFF_TEAM(player, it)) continue;
			if (autocvar_g_spawn_near_teammate_ignore_spawnpoint_check_health && GetResource(it, RES_HEALTH) < autocvar_g_balance_health_regenstable) continue;
			if (IS_DEAD(it)) continue;
			if (time < it.msnt_timer) continue;
			if (time < it.spawnshieldtime) continue;
			if (weaponLocked(it)) continue;
			if (it == player) continue;

			tested++; // i consider a teammate to be available when he passes the checks above

			vector horiz_vel = vec2(it.velocity);
			// when walking slowly sideways, we assume the player wants a clear shot ahead - spawn behind him according to where he's looking
			// when running fast, spawn behind him according to his direction of movement to prevent colliding with the newly spawned player
			if (vdist(horiz_vel, >, autocvar_sv_maxspeed + 50))
				fixedmakevectors(vectoangles(horiz_vel));
			else
				fixedmakevectors(it.angles); // .angles is the angle of the model - usually/always 0 pitch

			// test different spots close to mate - trace upwards so it works on uneven surfaces
			// don't spawn in front of player or directly behind to avoid players shooting each other
			// test the potential spots in pairs (first pair is better than second and so on) but don't prefer one side
			RandomSelection_Init();
			for(int i = 0; i < 6; ++i)
			{
				switch(i)
				{
					case 0:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin - v_forward * 64 + v_right * 128 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
					case 1:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin - v_forward * 64 - v_right * 128 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
					case 2:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin + v_right * 192 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
					case 3:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin - v_right * 192 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
					case 4:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin - v_forward * 128 + v_right * 64 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
					case 5:
						tracebox(it.origin, STAT(PL_MIN, player), STAT(PL_MAX, player), it.origin - v_forward * 128 - v_right * 64 + v_up * 64, MOVE_NOMONSTERS, it);
						break;
				}

				vector horizontal_trace_endpos = trace_endpos;
				//te_lightning1(NULL, it.origin, horizontal_trace_endpos);
				if (trace_fraction != 1.0) goto skip;

				// 400 is about the height of a typical laser jump (in overkill)
				// not traceline because we need space for the whole player, not just his origin
				tracebox(horizontal_trace_endpos, STAT(PL_MIN, player), STAT(PL_MAX, player), horizontal_trace_endpos - '0 0 400', MOVE_NORMAL, it);
				vector vectical_trace_endpos = trace_endpos;
				//te_lightning1(NULL, horizontal_trace_endpos, vectical_trace_endpos);
				if (trace_startsolid) goto skip; // inside another player
				if (trace_fraction == 1.0) goto skip; // above void or too high
				if (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) goto skip;
				if (pointcontents(vectical_trace_endpos) != CONTENT_EMPTY) goto skip; // no lava or slime (or water which i assume would be annoying anyway)
				if (tracebox_hits_trigger_hurt(horizontal_trace_endpos, STAT(PL_MIN, player), STAT(PL_MAX, player), vectical_trace_endpos)) goto skip;

				// make sure the spawned player will have floor ahead (or at least a wall - he shouldn't fall as soon as he starts moving)
				vector floor_test_start = vectical_trace_endpos + v_up * STAT(PL_MAX, player).z + v_forward * STAT(PL_MAX, player).x; // top front of player's bbox - highest point we know is not inside solid
				traceline(floor_test_start, floor_test_start + v_forward * 100 - v_up * 128, MOVE_NOMONSTERS, it);
				//te_beam(NULL, floor_test_start, trace_endpos);
				if (trace_fraction == 1.0) goto skip;

				if (autocvar_g_nades) {
					bool nade_in_range = false;
					IL_EACH(g_projectiles, it.classname == "nade",
					{
						if (vdist(it.origin - vectical_trace_endpos, <, autocvar_g_nades_nade_radius)) {
							nade_in_range = true;
							goto skip;
						}
					});
					if (nade_in_range) goto skip;
				}

				// here, we know we found a good spot
				RandomSelection_Add(it, 0, string_null, vectical_trace_endpos, 1, 1);
				//te_lightning1(NULL, vectical_trace_endpos, vectical_trace_endpos + v_forward * 10);

LABEL(skip)
				if (i % 2 == 1 && RandomSelection_chosen_ent)
				{
					if (autocvar_g_spawn_near_teammate_ignore_spawnpoint_closetodeath)
					{
						float dist2 = vlen2(RandomSelection_chosen_ent.origin - player.death_origin);
						if (dist2 < best_dist2)
						{
							best_dist2 = dist2;
							best_pos = RandomSelection_chosen_vec;
							best_mate = RandomSelection_chosen_ent;
						}
					}
					else
					{
						setorigin(player, RandomSelection_chosen_vec);
						player.angles = RandomSelection_chosen_ent.angles;
						player.angles_z = 0; // never spawn tilted even if the spot says to
						RandomSelection_chosen_ent.msnt_timer = time + autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay;
						return;
					}
					break; // don't test the other spots near this teammate, go to the next one
				}
			}
		});

		if(autocvar_g_spawn_near_teammate_ignore_spawnpoint_closetodeath)
		if(best_mate)
		{
			setorigin(player, best_pos);
			player.angles = best_mate.angles;
			player.angles_z = 0; // never spawn tilted even if the spot says to
			best_mate.msnt_timer = time + autocvar_g_spawn_near_teammate_ignore_spawnpoint_delay;
		}
	}
	else if(spawn_spot.msnt_lookat)
	{
		player.angles = vectoangles(spawn_spot.msnt_lookat.origin - player.origin);
		player.angles_x = -player.angles.x;
		player.angles_z = 0; // never spawn tilted even if the spot says to
		/*
		sprint(player, "You should be looking at ", spawn_spot.msnt_lookat.netname, "^7.\n");
		sprint(player, "distance: ", vtos(spawn_spot.msnt_lookat.origin - player.origin), "\n");
		sprint(player, "angles: ", vtos(player.angles), "\n");
		*/
	}
}

REPLICATE(cvar_cl_spawn_near_teammate, bool, "cl_spawn_near_teammate");
