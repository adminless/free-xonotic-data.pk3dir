#include "sv_dodging.qh"

// TODO the CSQC blocks in this sv_ file are currently not compiled but will be when dodging prediction gets enabled

/*qc2rust::define::PHYS_DODGING*/
#define PHYS_DODGING /*qc2rust::macro_begin::PHYS_DODGING*/g_dodging /*qc2rust::macro_end::PHYS_DODGING*/
/*qc2rust::define::PHYS_DODGING_DELAY*/
#define PHYS_DODGING_DELAY /*qc2rust::macro_begin::PHYS_DODGING_DELAY*/autocvar_sv_dodging_delay /*qc2rust::macro_end::PHYS_DODGING_DELAY*/
/*qc2rust::define::PHYS_DODGING_DISTANCE_THRESHOLD*/
#define PHYS_DODGING_DISTANCE_THRESHOLD /*qc2rust::macro_begin::PHYS_DODGING_DISTANCE_THRESHOLD*/autocvar_sv_dodging_wall_distance_threshold /*qc2rust::macro_end::PHYS_DODGING_DISTANCE_THRESHOLD*/
/*qc2rust::define::PHYS_DODGING_FROZEN_DOUBLETAP*/
#define PHYS_DODGING_FROZEN_DOUBLETAP /*qc2rust::macro_begin::PHYS_DODGING_FROZEN_DOUBLETAP*/autocvar_sv_dodging_frozen_doubletap /*qc2rust::macro_end::PHYS_DODGING_FROZEN_DOUBLETAP*/
/*qc2rust::define::PHYS_DODGING_HEIGHT_THRESHOLD*/
#define PHYS_DODGING_HEIGHT_THRESHOLD /*qc2rust::macro_begin::PHYS_DODGING_HEIGHT_THRESHOLD*/autocvar_sv_dodging_height_threshold /*qc2rust::macro_end::PHYS_DODGING_HEIGHT_THRESHOLD*/
/*qc2rust::define::PHYS_DODGING_HORIZ_SPEED_MIN*/
#define PHYS_DODGING_HORIZ_SPEED_MIN /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_SPEED_MIN*/autocvar_sv_dodging_horiz_speed_min /*qc2rust::macro_end::PHYS_DODGING_HORIZ_SPEED_MIN*/
/*qc2rust::define::PHYS_DODGING_HORIZ_SPEED_MAX*/
#define PHYS_DODGING_HORIZ_SPEED_MAX /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_SPEED_MAX*/autocvar_sv_dodging_horiz_speed_max /*qc2rust::macro_end::PHYS_DODGING_HORIZ_SPEED_MAX*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/
#define PHYS_DODGING_HORIZ_FORCE_SLOWEST /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/autocvar_sv_dodging_horiz_force_slowest /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_FASTEST*/
#define PHYS_DODGING_HORIZ_FORCE_FASTEST /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_FASTEST*/autocvar_sv_dodging_horiz_force_fastest /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_FASTEST*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_FROZEN*/
#define PHYS_DODGING_HORIZ_FORCE_FROZEN /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_FROZEN*/autocvar_sv_dodging_horiz_force_frozen /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_FROZEN*/
/*qc2rust::define::PHYS_DODGING_RAMP_TIME*/
#define PHYS_DODGING_RAMP_TIME /*qc2rust::macro_begin::PHYS_DODGING_RAMP_TIME*/autocvar_sv_dodging_ramp_time /*qc2rust::macro_end::PHYS_DODGING_RAMP_TIME*/
/*qc2rust::define::PHYS_DODGING_UP_SPEED*/
#define PHYS_DODGING_UP_SPEED /*qc2rust::macro_begin::PHYS_DODGING_UP_SPEED*/autocvar_sv_dodging_up_speed /*qc2rust::macro_end::PHYS_DODGING_UP_SPEED*/
/*qc2rust::define::PHYS_DODGING_WALL*/
#define PHYS_DODGING_WALL /*qc2rust::macro_begin::PHYS_DODGING_WALL*/autocvar_sv_dodging_wall_dodging /*qc2rust::macro_end::PHYS_DODGING_WALL*/
/*qc2rust::define::PHYS_DODGING_AIR*/
#define PHYS_DODGING_AIR /*qc2rust::macro_begin::PHYS_DODGING_AIR*/autocvar_sv_dodging_air_dodging /*qc2rust::macro_end::PHYS_DODGING_AIR*/
/*qc2rust::define::PHYS_DODGING_MAXSPEED*/
#define PHYS_DODGING_MAXSPEED /*qc2rust::macro_begin::PHYS_DODGING_MAXSPEED*/autocvar_sv_dodging_maxspeed /*qc2rust::macro_end::PHYS_DODGING_MAXSPEED*/
/*qc2rust::define::PHYS_DODGING_AIR_MAXSPEED*/
#define PHYS_DODGING_AIR_MAXSPEED /*qc2rust::macro_begin::PHYS_DODGING_AIR_MAXSPEED*/autocvar_sv_dodging_air_maxspeed /*qc2rust::macro_end::PHYS_DODGING_AIR_MAXSPEED*/

// we ran out of stats slots! TODO: re-enable this when prediction is available for dodging
#if 0
/*qc2rust::define::PHYS_DODGING*/
#define PHYS_DODGING /*qc2rust::macro_begin::PHYS_DODGING*/STAT(DODGING, this) /*qc2rust::macro_end::PHYS_DODGING*/
/*qc2rust::define::PHYS_DODGING_DELAY*/
#define PHYS_DODGING_DELAY /*qc2rust::macro_begin::PHYS_DODGING_DELAY*/STAT(DODGING_DELAY, this) /*qc2rust::macro_end::PHYS_DODGING_DELAY*/
/*qc2rust::define::PHYS_DODGING_DISTANCE_THRESHOLD*/
#define PHYS_DODGING_DISTANCE_THRESHOLD /*qc2rust::macro_begin::PHYS_DODGING_DISTANCE_THRESHOLD*/STAT(DODGING_DISTANCE_THRESHOLD, this) /*qc2rust::macro_end::PHYS_DODGING_DISTANCE_THRESHOLD*/
/*qc2rust::define::PHYS_DODGING_FROZEN_DOUBLETAP*/
#define PHYS_DODGING_FROZEN_DOUBLETAP /*qc2rust::macro_begin::PHYS_DODGING_FROZEN_DOUBLETAP*/STAT(DODGING_FROZEN_DOUBLETAP, this) /*qc2rust::macro_end::PHYS_DODGING_FROZEN_DOUBLETAP*/
/*qc2rust::define::PHYS_DODGING_HEIGHT_THRESHOLD*/
#define PHYS_DODGING_HEIGHT_THRESHOLD /*qc2rust::macro_begin::PHYS_DODGING_HEIGHT_THRESHOLD*/STAT(DODGING_HEIGHT_THRESHOLD, this) /*qc2rust::macro_end::PHYS_DODGING_HEIGHT_THRESHOLD*/
/*qc2rust::define::PHYS_DODGING_HORIZ_SPEED_MIN*/
#define PHYS_DODGING_HORIZ_SPEED_MIN /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_SPEED_MIN*/STAT(DODGING_HORIZ_SPEED_MIN, this) /*qc2rust::macro_end::PHYS_DODGING_HORIZ_SPEED_MIN*/
/*qc2rust::define::PHYS_DODGING_HORIZ_SPEED_MAX*/
#define PHYS_DODGING_HORIZ_SPEED_MAX /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_SPEED_MAX*/STAT(DODGING_HORIZ_SPEED_MAX, this) /*qc2rust::macro_end::PHYS_DODGING_HORIZ_SPEED_MAX*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/
#define PHYS_DODGING_HORIZ_FORCE_SLOWEST /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/STAT(DODGING_HORIZ_FORCE_SLOWEST, this) /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_SLOWEST*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_FASTEST*/
#define PHYS_DODGING_HORIZ_FORCE_FASTEST /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_FASTEST*/STAT(DODGING_HORIZ_FORCE_FASTEST, this) /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_FASTEST*/
/*qc2rust::define::PHYS_DODGING_HORIZ_FORCE_FROZEN*/
#define PHYS_DODGING_HORIZ_FORCE_FROZEN /*qc2rust::macro_begin::PHYS_DODGING_HORIZ_FORCE_FROZEN*/STAT(DODGING_HORIZ_FORCE_FROZEN, this) /*qc2rust::macro_end::PHYS_DODGING_HORIZ_FORCE_FROZEN*/
/*qc2rust::define::PHYS_DODGING_RAMP_TIME*/
#define PHYS_DODGING_RAMP_TIME /*qc2rust::macro_begin::PHYS_DODGING_RAMP_TIME*/STAT(DODGING_RAMP_TIME, this) /*qc2rust::macro_end::PHYS_DODGING_RAMP_TIME*/
/*qc2rust::define::PHYS_DODGING_UP_SPEED*/
#define PHYS_DODGING_UP_SPEED /*qc2rust::macro_begin::PHYS_DODGING_UP_SPEED*/STAT(DODGING_UP_SPEED, this) /*qc2rust::macro_end::PHYS_DODGING_UP_SPEED*/
/*qc2rust::define::PHYS_DODGING_WALL*/
#define PHYS_DODGING_WALL /*qc2rust::macro_begin::PHYS_DODGING_WALL*/STAT(DODGING_WALL, this) /*qc2rust::macro_end::PHYS_DODGING_WALL*/
/*qc2rust::define::PHYS_DODGING_AIR*/
#define PHYS_DODGING_AIR /*qc2rust::macro_begin::PHYS_DODGING_AIR*/STAT(DODGING_AIR, this) /*qc2rust::macro_end::PHYS_DODGING_AIR*/
/*qc2rust::define::PHYS_DODGING_MAXSPEED*/
#define PHYS_DODGING_MAXSPEED /*qc2rust::macro_begin::PHYS_DODGING_MAXSPEED*/STAT(DODGING_MAXSPEED, this) /*qc2rust::macro_end::PHYS_DODGING_MAXSPEED*/
/*qc2rust::define::PHYS_DODGING_AIR_MAXSPEED*/
#define PHYS_DODGING_AIR_MAXSPEED /*qc2rust::macro_begin::PHYS_DODGING_AIR_MAXSPEED*/STAT(DODGING_AIR_MAXSPEED, this) /*qc2rust::macro_end::PHYS_DODGING_AIR_MAXSPEED*/
#endif

#ifdef CSQC
/*qc2rust::define::PHYS_DODGING_FRAMETIME*/
#define PHYS_DODGING_FRAMETIME /*qc2rust::macro_begin::PHYS_DODGING_FRAMETIME*/(1 / (frametime <= 0 ? 60 : frametime)) /*qc2rust::macro_end::PHYS_DODGING_FRAMETIME*/
/*qc2rust::define::PHYS_DODGING_TIMEOUT*/
#define PHYS_DODGING_TIMEOUT(s) /*qc2rust::macro_begin::PHYS_DODGING_TIMEOUT*/STAT(DODGING_TIMEOUT) /*qc2rust::macro_end::PHYS_DODGING_TIMEOUT*/
/*qc2rust::define::PHYS_DODGING_PRESSED_KEYS*/
#define PHYS_DODGING_PRESSED_KEYS(s) /*qc2rust::macro_begin::PHYS_DODGING_PRESSED_KEYS*/( /*qc2rust::param_begin::s*/s /*qc2rust::param_end::s*/).pressedkeys /*qc2rust::macro_end::PHYS_DODGING_PRESSED_KEYS*/
#elif defined(SVQC)
/*qc2rust::define::PHYS_DODGING_FRAMETIME*/
#define PHYS_DODGING_FRAMETIME /*qc2rust::macro_begin::PHYS_DODGING_FRAMETIME*/sys_frametime /*qc2rust::macro_end::PHYS_DODGING_FRAMETIME*/
/*qc2rust::define::PHYS_DODGING_TIMEOUT*/
#define PHYS_DODGING_TIMEOUT(s) /*qc2rust::macro_begin::PHYS_DODGING_TIMEOUT*/CS( /*qc2rust::param_begin::s*/s /*qc2rust::param_end::s*/).cvar_cl_dodging_timeout /*qc2rust::macro_end::PHYS_DODGING_TIMEOUT*/
/*qc2rust::define::PHYS_DODGING_PRESSED_KEYS*/
#define PHYS_DODGING_PRESSED_KEYS(s) /*qc2rust::macro_begin::PHYS_DODGING_PRESSED_KEYS*/CS( /*qc2rust::param_begin::s*/s /*qc2rust::param_end::s*/).pressedkeys /*qc2rust::macro_end::PHYS_DODGING_PRESSED_KEYS*/
#endif

#ifdef SVQC

bool autocvar_sv_dodging_sound;

#include <common/animdecide.qh>
#include <common/physics/player.qh>

.float cvar_cl_dodging_timeout;

REGISTER_MUTATOR(dodging, cvar("g_dodging"))
{
	// this just turns on the cvar.
	MUTATOR_ONADD
	{
		g_dodging = cvar("g_dodging");
	}

	// this just turns off the cvar.
	MUTATOR_ONROLLBACK_OR_REMOVE
	{
		g_dodging = 0;
	}

	return false;
}

#elif defined(CSQC)
REGISTER_MUTATOR(dodging, true);
#endif

// set to 1 to indicate dodging has started.. reset by physics hook after dodge has been done..
.float dodging_action;

// the jump part of the dodge cannot be ramped
.float dodging_single_action;

// these are used to store the last key press time for each of the keys..
.float last_FORWARD_KEY_time;
.float last_BACKWARD_KEY_time;
.float last_LEFT_KEY_time;
.float last_RIGHT_KEY_time;

// these store the movement direction at the time of the dodge action happening.
.vector dodging_direction;

// this indicates the last time a dodge was executed. used to check if another one is allowed
// and to ramp up the dodge acceleration in the physics hook.
.float last_dodging_time;

// the total speed that will be added over the ramp time
.float dodging_force_total;
// the part of total yet to be added
.float dodging_force_remaining;

#ifdef CSQC
.int pressedkeys;
#endif

/*qc2rust::define::X*/
#define X(dir) /*qc2rust::macro_begin::X*/tracebox(this.origin, this.mins, this.maxs, this.origin + threshold *  /*qc2rust::param_begin::dir*/dir /*qc2rust::param_end::dir*/, true, this); 	if (trace_fraction < 1 && !(trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY)) 		return true; /*qc2rust::macro_end::X*/

// returns true if the player is close to a wall
bool is_close_to_wall(entity this, float threshold)
{
	X(v_right);
	X(-v_right);
	X(v_forward);
	X(-v_forward);

	return false;
}

bool is_close_to_ground(entity this, float threshold)
{
	if (IS_ONGROUND(this)) return true;
	X(-v_up); // necessary for dodging down a slope using doubletap (using `+dodge` works anyway)

	return false;
}

#undef X

float determine_force(entity player) {
	if (PHYS_FROZEN(player)) return PHYS_DODGING_HORIZ_FORCE_FROZEN;

	float horiz_vel = vlen(vec2(player.velocity));
	return map_bound_ranges(horiz_vel,
	                        PHYS_DODGING_HORIZ_SPEED_MIN, PHYS_DODGING_HORIZ_SPEED_MAX,
	                        PHYS_DODGING_HORIZ_FORCE_SLOWEST, PHYS_DODGING_HORIZ_FORCE_FASTEST);
}

bool PM_dodging_checkpressedkeys(entity this)
{
	bool frozen_dodging = (PHYS_FROZEN(this) && PHYS_DODGING_FROZEN(this));
	bool frozen_no_doubletap = (frozen_dodging && !PHYS_DODGING_FROZEN_DOUBLETAP);

	float tap_direction_x = 0;
	float tap_direction_y = 0;
	bool dodge_detected = false;
	vector mymovement = PHYS_CS(this).movement;

	#define X(COND,BTN,RESULT)																					if (mymovement_##COND) {																						/* is this a state change? */																				if(!(PHYS_DODGING_PRESSED_KEYS(this) & KEY_##BTN) || frozen_no_doubletap) {										tap_direction_##RESULT;																						if ((time - this.last_##BTN##_KEY_time) < PHYS_DODGING_TIMEOUT(this) || frozen_no_doubletap) {					dodge_detected = true;																					} else if(PHYS_INPUT_BUTTON_DODGE(this)) {																		dodge_detected = true;																					}																											this.last_##BTN##_KEY_time = time;																		}																										}
	X(x < 0, BACKWARD,	x--);
	X(x > 0, FORWARD,	x++);
	X(y < 0, LEFT,		y--);
	X(y > 0, RIGHT,		y++);
	#undef X

	if (!dodge_detected) return false;

	// this check has to be after checking keys:
	// the first key press of the double tap is allowed to be before dodging delay,
	// only the second has to be after, otherwise +dodge gives an advantage because typical repress time is 0.1 s
	// or higher which means players using +dodge would be able to do it more often
	if ((time - this.last_dodging_time) < PHYS_DODGING_DELAY)
		return false;

	makevectors(this.angles);

	bool can_dodge = (is_close_to_ground(this, PHYS_DODGING_HEIGHT_THRESHOLD) && (PHYS_DODGING_MAXSPEED == 0 || vdist(this.velocity, <, PHYS_DODGING_MAXSPEED)));
	bool can_wall_dodge = (PHYS_DODGING_WALL && is_close_to_wall(this, PHYS_DODGING_DISTANCE_THRESHOLD));
	bool can_air_dodge = (PHYS_DODGING_AIR && (PHYS_DODGING_AIR_MAXSPEED == 0 || vdist(this.velocity, <, PHYS_DODGING_AIR_MAXSPEED)));
	if (!can_dodge && !can_wall_dodge && !can_air_dodge) return false;

	this.last_dodging_time = time;

	this.dodging_action = 1;
	this.dodging_single_action = 1;

	this.dodging_force_total = determine_force(this);
	this.dodging_force_remaining = this.dodging_force_total;

	this.dodging_direction.x = tap_direction_x;
	this.dodging_direction.y = tap_direction_y;

	// normalize the dodging_direction vector.. (unlike UT99) XD
	float length = sqrt(this.dodging_direction.x ** 2 + this.dodging_direction.y ** 2);

	this.dodging_direction.x = this.dodging_direction.x / length;
	this.dodging_direction.y = this.dodging_direction.y / length;

	return true;
}

void PM_dodging(entity this)
{
	// can't use return value from PM_dodging_checkpressedkeys because they're called from different hooks
	if (!this.dodging_action) return;

	// when swimming or dead, no dodging allowed..
	if (this.waterlevel >= WATERLEVEL_SWIMMING || IS_DEAD(this))
	{
		this.dodging_action = 0;
		this.dodging_direction.x = 0;
		this.dodging_direction.y = 0;
		return;
	}

	// make sure v_up, v_right and v_forward are sane
	if(PHYS_DODGING_AIR)
		makevectors(this.v_angle);
	else
		makevectors(this.angles);

	// fraction of the force to apply each frame
	// if we have e.g. 0.5 sec ramptime and a frametime of 0.25, then the ramp code
	// will be called ramp_time/frametime times = 2 times. so, we need to
	// add 0.5 * the total speed each frame until the dodge action is done..
	float common_factor = PHYS_DODGING_FRAMETIME / PHYS_DODGING_RAMP_TIME;
	// NOTE: depending on cl_netfps the client may (and probably will) send more input frames during each server frame
	// but common_factor uses server frame rate so players with higher cl_netfps will ramp slightly faster

	float velocity_increase = min(common_factor * this.dodging_force_total, this.dodging_force_remaining);
	this.dodging_force_remaining -= velocity_increase;
	this.velocity += this.dodging_direction.x * velocity_increase * v_forward
	               + this.dodging_direction.y * velocity_increase * v_right;

	// the up part of the dodge is a single shot action
	if (this.dodging_single_action == 1)
	{
		UNSET_ONGROUND(this);

		this.velocity += PHYS_DODGING_UP_SPEED * v_up;

#ifdef SVQC
		if (autocvar_sv_dodging_sound)
			PlayerSound(this, playersound_jump, CH_PLAYER, VOL_BASE, VOICETYPE_PLAYERSOUND);

		animdecide_setaction(this, ANIMACTION_JUMP, true);
#endif

		this.dodging_single_action = 0;
	}

	if(this.dodging_force_remaining <= 0)
	{
		// reset state so next dodge can be done correctly
		this.dodging_action = 0;
		this.dodging_direction.x = 0;
		this.dodging_direction.y = 0;
	}
}

#ifdef CSQC
void PM_dodging_GetPressedKeys(entity this)
{
	PM_dodging_checkpressedkeys(this);

	int keys = this.pressedkeys;
	keys = BITSET(keys, KEY_FORWARD, 	PHYS_CS(this).movement.x > 0);
	keys = BITSET(keys, KEY_BACKWARD, 	PHYS_CS(this).movement.x < 0);
	keys = BITSET(keys, KEY_RIGHT, 		PHYS_CS(this).movement.y > 0);
	keys = BITSET(keys, KEY_LEFT, 		PHYS_CS(this).movement.y < 0);

	keys = BITSET(keys, KEY_JUMP, 		PHYS_INPUT_BUTTON_JUMP(this));
	keys = BITSET(keys, KEY_CROUCH, 	PHYS_INPUT_BUTTON_CROUCH(this));
	keys = BITSET(keys, KEY_ATCK, 		PHYS_INPUT_BUTTON_ATCK(this));
	keys = BITSET(keys, KEY_ATCK2, 		PHYS_INPUT_BUTTON_ATCK2(this));
	this.pressedkeys = keys;
}
#endif

MUTATOR_HOOKFUNCTION(dodging, PlayerPhysics)
{
	entity player = M_ARGV(0, entity);

#ifdef CSQC
	PM_dodging_GetPressedKeys(player);
#endif
	PM_dodging(player);
}

#ifdef SVQC

REPLICATE(cvar_cl_dodging_timeout, float, "cl_dodging_timeout");

MUTATOR_HOOKFUNCTION(dodging, GetPressedKeys)
{
	entity player = M_ARGV(0, entity);

	PM_dodging_checkpressedkeys(player);
}

#endif
