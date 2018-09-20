#include "fallingplatform.qh"

#ifdef SVQC
void fallingplatform_think(entity this);
void fallingplatform_endmove(entity this)
{
	// we just hit the bottom, now we must decide if we fall completely
	setthink(this, fallingplatform_think);
	this.nextthink = time;
}

void fallingplatform_think(entity this)
{
	this.nextthink = time;

	if(this.active != ACTIVE_ACTIVE || this.state != STATE_ACTIVE)
		return;

	int total_found = 0, other_found = 0, found = 0;
	IL_EACH(g_fallingplatforms, it.target == this.targetname || this.targetname == it.target || it == this,
	{
		entity plat = it;
		IL_EACH(g_damagedbycontents, it.iscreature && it.groundentity == plat,
		{
			if((IS_PLAYER(it) && !(plat.spawnflags & FALLINGPLATFORM_NOPLAYERS)) || (!IS_PLAYER(it) && !(plat.spawnflags & ONLY_PLAYERS)))
			{
				++total_found;
				if(plat != this)
					++other_found;
				else
					++found;
			}
		});

		if(plat == this && (plat.spawnflags & FALLINGPLATFORM_STOP_WHENFULL) && found >= plat.count)
			return; // stop early if we have too many passengers
	});

	if(!total_found)
	{
		vector newpos = this.pos1;
		if(this.finaldest == newpos)
			return; // already processing the correct move!
		SUB_CalcMove(this, newpos, TSPEED_LINEAR, this.speed, fallingplatform_think);
		setthink(this, fallingplatform_think); // but keep regular think state!
		this.nextthink = time;
		return;
	}

	if(other_found == found)
		return; // in the event of equal passengers in a pulley setup, stop moving TODO: this should keep doing the movement frame!

	vector newpos = this.pos3;
	if((this.spawnflags & FALLINGPLATFORM_RISE) || other_found > found)
		newpos = this.pos2;

	if(this.move_controller && this.finaldest == newpos)
		return; // already processing the correct move!
	SUB_CalcMove(this, newpos, TSPEED_LINEAR, this.speed, fallingplatform_endmove);
	setthink(this, fallingplatform_think); // but keep regular think state!
	this.nextthink = time;
}

void fallingplatform_reset(entity this)
{
	setorigin(this, this.pos1);
	this.state = STATE_ALIVE;
	this.active = ACTIVE_ACTIVE;
	setthink(this, fallingplatform_think);
	this.nextthink = time + 1; // delay just a bit so it doesn't start lowering immediately
}

spawnfunc(func_fallingplatform)
{
	if(this.spawnflags & CRUSH)
	{
		this.dmg = DMG_INSTAKILL;
	}

	// damage when blocked
	setblocked(this, generic_plat_blocked);
	if(this.dmg && (this.message == ""))
		this.message = "was squished";
    if(this.dmg && (this.message2 == ""))
		this.message2 = "was squished by";
	if(this.dmg && (!this.dmgtime))
		this.dmgtime = 0.25;
	this.dmgtime2 = time;

    // TODO: sound

	this.mangle = this.angles;
	this.angles = '0 0 0';

	if(!InitMovingBrushTrigger(this))
		return;
	this.effects |= EF_LOWPRECISION;
	setsize(this, this.mins, this.maxs);

	if(!this.speed) this.speed = 100;
	if(!this.lip) this.lip = 64;
	if(!this.height) this.height = this.size.z - this.lip;
	if(!this.count) this.count = 2;
	this.active = ACTIVE_ACTIVE; // TODO: allow starting off (should be generic)
	this.state = STATE_ACTIVE;

	this.pos1 = this.origin;
	this.pos2 = this.origin;
	this.pos2_z = this.origin.z - this.height;
	this.pos3 = this.origin;
	this.pos3_z = this.origin.z + this.height; // get a rough upward position too

	this.reset = fallingplatform_reset;
	this.reset(this);

	IL_PUSH(g_fallingplatforms, this);
}
#endif
