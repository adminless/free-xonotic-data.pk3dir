#include "vaporizer.qh"

REGISTER_NET_TEMP(TE_CSQC_VAPORBEAMPARTICLE)

#if defined(SVQC)
void SendCSQCVaporizerBeamParticle(entity player, int hit) {
	vector v;
	v = WarpZone_UnTransformOrigin(WarpZone_trace_transform, trace_endpos);
	WriteHeader(MSG_BROADCAST, TE_CSQC_VAPORBEAMPARTICLE);
	WriteVector(MSG_BROADCAST, w_shotorg);
	WriteVector(MSG_BROADCAST, v);
	WriteByte(MSG_BROADCAST, hit);
	WriteByte(MSG_BROADCAST, etof(player));
	WriteByte(MSG_BROADCAST, player.team);
}
#elif defined(CSQC)
bool autocvar_cl_vaporizerbeam_particle = false;
float autocvar_cl_vaporizerbeam_lifetime = 0.8;
float autocvar_cl_vaporizerbeam_colorboost = 0.7;

string Draw_VaporizerBeam_trace_callback_tex;
float Draw_VaporizerBeam_trace_callback_rnd;
vector Draw_VaporizerBeam_trace_callback_rgb;
float Draw_VaporizerBeam_trace_callback_a;
void Draw_VaporizerBeam_trace_callback(vector start, vector hit, vector end)
{
	float i;
	vector vorg;
	vorg = WarpZone_TransformOrigin(WarpZone_trace_transform, view_origin);
	for(i = 0; i < Draw_VaporizerBeam_trace_callback_a; ++i)
		Draw_CylindricLine(hit, start, 8, Draw_VaporizerBeam_trace_callback_tex, 0.25, Draw_VaporizerBeam_trace_callback_rnd, Draw_VaporizerBeam_trace_callback_rgb, min(1, Draw_VaporizerBeam_trace_callback_a - i), DRAWFLAG_NORMAL, vorg);
	Draw_VaporizerBeam_trace_callback_rnd += 0.25 * vlen(hit - start) / 8;
}

.vector vorg1, vorg2;
.float spawn_time;
void VaporizerBeam_Draw(entity this)
{
	//draw either the old v2.3 beam or the new beam
	particles_alphamin = particles_alphamax = particles_fade = 1;

	string tex = "particles/lgbeam";
	if(this.cnt)
		tex = "particles/gauntletbeam";
	vector rgb;
	//entity e = CSQCModel_server2csqc(this.sv_entnum - 1);
	//if (e == NULL)
	//{
		rgb = colormapPaletteColor(entcs_GetClientColors(this.sv_entnum - 1) & 0x0F, true);
		//rgb = '1 1 1';
	//}
	//else
	//	rgb = e.glowmod;
	rgb *= (1 + autocvar_cl_vaporizerbeam_colorboost);

	float fail = (this.nextthink - time);

	Draw_VaporizerBeam_trace_callback_tex = tex;
	Draw_VaporizerBeam_trace_callback_rnd = 0;
	Draw_VaporizerBeam_trace_callback_rgb = rgb;
	Draw_VaporizerBeam_trace_callback_a = bound(0, fail, 1);
	WarpZone_TraceBox_ThroughZone(this.vorg1, '0 0 0', '0 0 0', this.vorg2, MOVE_NOTHING, NULL, NULL, Draw_VaporizerBeam_trace_callback);
	Draw_VaporizerBeam_trace_callback_tex = string_null;

	/*if(!MUTATOR_CALLHOOK(Particles_VaporizerBeam, this.vorg1, this.vorg2))
	if(autocvar_cl_particles_oldvortexbeam && (STAT(ALLOW_OLDVORTEXBEAM) || isdemo()))
		WarpZone_TrailParticles_WithMultiplier(NULL, particleeffectnum(EFFECT_VORTEX_BEAM_OLD), this.vorg1, this.vorg2, 1, PARTICLES_USEALPHA | PARTICLES_USEFADE);
	else
		WarpZone_TrailParticles_WithMultiplier(NULL, particleeffectnum(EFFECT_VORTEX_BEAM), this.vorg1, this.vorg2, 1, PARTICLES_USEALPHA | PARTICLES_USEFADE);*/
}

NET_HANDLE(TE_CSQC_VAPORBEAMPARTICLE, bool isNew)
{
	Net_Accept(vortex_beam);
	setthink(this, SUB_Remove);
	this.nextthink = time + bound(0, autocvar_cl_vaporizerbeam_lifetime, 10);
	this.draw = VaporizerBeam_Draw;
	if (isNew) IL_PUSH(g_drawables, this);
	this.drawmask = MASK_NORMAL;

	this.vorg1 = ReadVector();
	this.vorg2 = ReadVector();
	this.cnt = ReadByte();
	int myowner = ReadByte();
	this.owner = playerslots[myowner - 1];
	this.sv_entnum = myowner;
	this.team = ReadByte() - 1;

	pointparticles(EFFECT_VORTEX_MUZZLEFLASH, this.vorg1, normalize(this.vorg2 - this.vorg1) * 1000, 1);

	if(autocvar_cl_vaporizerbeam_particle)
	{
		WarpZone_TrailParticles(NULL, particleeffectnum(((this.cnt) ? EFFECT_VAPORIZER_HIT(this.team) : EFFECT_VAPORIZER(this.team))), this.vorg1, this.vorg2);
		this.draw = func_null;
		this.drawmask = MASK_NORMAL;
		delete(this);
	}

	return true;
}
#endif

#ifdef SVQC

void W_RocketMinsta_Explosion(entity actor, .entity weaponentity, vector loc)
{
	if(accuracy_canbegooddamage(actor))
		accuracy_add(actor, WEP_DEVASTATOR, autocvar_g_rm_damage, 0);
	entity dmgent = spawn();
	dmgent.owner = dmgent.realowner = actor;
	setorigin(dmgent, loc);
	RadiusDamage (dmgent, actor, autocvar_g_rm_damage, autocvar_g_rm_edgedamage, autocvar_g_rm_radius, NULL, NULL, autocvar_g_rm_force, WEP_DEVASTATOR.m_id | HITTYPE_SPLASH, weaponentity, NULL);
	delete(dmgent);
}

void W_Vaporizer_Attack(Weapon thiswep, entity actor, .entity weaponentity)
{
	bool flying = IsFlying(actor); // do this BEFORE to make the trace values from FireRailgunBullet last
	float vaporizer_damage = ((WEP_CVAR_PRI(vaporizer, damage) > 0) ? WEP_CVAR_PRI(vaporizer, damage) : 10000);

	W_SetupShot(actor, weaponentity, true, 0, SND_Null, CH_WEAPON_A, vaporizer_damage, thiswep.m_id);
	// handle sound separately so we can change the volume
	// added bonus: no longer plays the strength sound (strength gives no bonus to instakill anyway)
	sound (actor, CH_WEAPON_A, SND_MINSTANEXFIRE, VOL_BASE * 0.8, ATTEN_NORM);

	yoda = 0;
	damage_goodhits = 0;
	FireRailgunBullet(actor, weaponentity, w_shotorg, w_shotorg + w_shotdir * max_shot_distance, vaporizer_damage, WEP_CVAR_PRI(vaporizer, force), 0, 0, 0, 0, thiswep.m_id);

	// do this now, as goodhits is disabled below
	SendCSQCVaporizerBeamParticle(actor, damage_goodhits);

	if(yoda && flying)
		Send_Notification(NOTIF_ONE, actor, MSG_ANNCE, ANNCE_ACHIEVEMENT_YODA);
	if(damage_goodhits && actor.vaporizer_lasthit)
	{
		Send_Notification(NOTIF_ONE, actor, MSG_ANNCE, ANNCE_ACHIEVEMENT_IMPRESSIVE);
		damage_goodhits = 0; // only every second time
	}

	actor.vaporizer_lasthit = damage_goodhits;

	if(autocvar_g_rm)
	if(!(trace_dphitq3surfaceflags & (Q3SURFACEFLAG_SKY | Q3SURFACEFLAG_NOIMPACT)))
		W_RocketMinsta_Explosion(actor, weaponentity, trace_endpos);

	W_DecreaseAmmo(thiswep, actor, ((autocvar_g_instagib) ? 1 : WEP_CVAR_PRI(vaporizer, ammo)), weaponentity);
}

void W_RocketMinsta_Laser_Explode (entity this, entity directhitentity)
{
	if(directhitentity.takedamage == DAMAGE_AIM)
		if(IS_PLAYER(directhitentity))
			if(DIFF_TEAM(this.realowner, directhitentity))
				if(!IS_DEAD(directhitentity))
					if(IsFlying(directhitentity))
						Send_Notification(NOTIF_ONE, this.realowner, MSG_ANNCE, ANNCE_ACHIEVEMENT_ELECTROBITCH);

	this.event_damage = func_null;
	this.takedamage = DAMAGE_NO;
	RadiusDamage (this, this.realowner, this.rm_damage, this.rm_edmg, autocvar_g_rm_laser_radius, NULL, NULL, this.rm_force, this.projectiledeathtype, this.weaponentity_fld, directhitentity);
	delete(this);
}

void W_RocketMinsta_Laser_Explode_use(entity this, entity actor, entity trigger)
{
	W_RocketMinsta_Laser_Explode(this, trigger); // we probably don't want trigger used here, but this matches closest to old behaviour
}

void W_RocketMinsta_Laser_Touch(entity this, entity toucher)
{
	PROJECTILE_TOUCH(this, toucher);
	//W_RocketMinsta_Laser_Explode ();
	RadiusDamage(this, this.realowner, this.rm_damage, this.rm_edmg, autocvar_g_rm_laser_radius, NULL, NULL, this.rm_force, this.projectiledeathtype, this.weaponentity_fld, toucher);
	delete(this);
}

void W_RocketMinsta_Attack2(entity actor, .entity weaponentity)
{
	makevectors(actor.v_angle);

	entity proj;
	float counter = 0;
	float total = autocvar_g_rm_laser_count;
	float spread = autocvar_g_rm_laser_spread;
	float rndspread = autocvar_g_rm_laser_spread_random;

	W_SetupShot_ProjectileSize (actor, weaponentity, '0 0 -3', '0 0 -3', false, 2, SND_CRYLINK_FIRE, CH_WEAPON_A, autocvar_g_rm_laser_damage, WEP_ELECTRO.m_id);

	Send_Effect(EFFECT_ELECTRO_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);

    while(counter < total)
	{
        proj = new(plasma_prim);
        proj.owner = proj.realowner = actor;
        proj.bot_dodge = true;
        proj.bot_dodgerating = autocvar_g_rm_laser_damage;
        proj.use = W_RocketMinsta_Laser_Explode_use;
        setthink(proj, adaptor_think2use_hittype_splash);
        proj.nextthink = time + autocvar_g_rm_laser_lifetime;
        PROJECTILE_MAKETRIGGER(proj);
        proj.projectiledeathtype = WEP_ELECTRO.m_id;
        proj.weaponentity_fld = weaponentity;
        setorigin(proj, w_shotorg);

		proj.rm_force = autocvar_g_rm_laser_force / total;
		proj.rm_damage = autocvar_g_rm_laser_damage / total;
		proj.rm_edmg = proj.rm_damage;

        //W_SetupProjectileVelocity(proj, autocvar_g_rm_laser_speed, spread * (rndspread ? random() : 1) * autocvar_g_rm_laser_speed);

        set_movetype(proj, MOVETYPE_BOUNCEMISSILE);
        //W_SETUPPROJECTILEVELOCITY(proj, g_balance_minstanex_laser);
		proj.velocity = (w_shotdir + (((counter + 0.5) / total) * 2 - 1) * v_right * (spread * (rndspread ? random() : 1))) * cvar("g_rm_laser_speed");
		proj.velocity_z = proj.velocity_z + cvar("g_rm_laser_zspread") * (random() - 0.5);
		proj.velocity = W_CalculateProjectileVelocity(actor, actor.velocity, proj.velocity, true);
        proj.angles = vectoangles(proj.velocity);
        settouch(proj, W_RocketMinsta_Laser_Touch);
        setsize(proj, '0 0 -3', '0 0 -3');
        proj.flags = FL_PROJECTILE;
        IL_PUSH(g_projectiles, proj);
        IL_PUSH(g_bot_dodge, proj);
        proj.missile_flags = MIF_SPLASH;

        CSQCProjectile(proj, true, PROJECTILE_ROCKETMINSTA_LASER, true);

        MUTATOR_CALLHOOK(EditProjectile, actor, proj);
        counter++;
    }
}

void W_RocketMinsta_Attack3 (entity actor, .entity weaponentity)
{
	makevectors(actor.v_angle);

	entity proj;
	float counter = 0;
	float total = 1;

	W_SetupShot_ProjectileSize (actor, weaponentity, '0 0 -3', '0 0 -3', false, 2, SND_ELECTRO_FIRE2, CH_WEAPON_A, autocvar_g_rm_laser_damage, WEP_ELECTRO.m_id);

	Send_Effect(EFFECT_ELECTRO_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);

    while(counter < total)
	{
        proj = new(plasma_prim);
        proj.owner = proj.realowner = actor;
        proj.bot_dodge = true;
        proj.bot_dodgerating = autocvar_g_rm_laser_damage;
        proj.use = W_RocketMinsta_Laser_Explode_use;
        setthink(proj, adaptor_think2use_hittype_splash);
        proj.nextthink = time + autocvar_g_rm_laser_lifetime;
        PROJECTILE_MAKETRIGGER(proj);
        proj.projectiledeathtype = WEP_ELECTRO.m_id;
        proj.weaponentity_fld = weaponentity;
        setorigin(proj, w_shotorg);

		proj.rm_force = autocvar_g_rm_laser_force / total;
		proj.rm_damage = autocvar_g_rm_laser_damage / total;
		proj.rm_edmg = proj.rm_damage;

        //W_SetupProjectileVelocity(proj, autocvar_g_rm_laser_speed, spread * (rndspread ? random() : 1) * autocvar_g_rm_laser_speed);

        set_movetype(proj, MOVETYPE_BOUNCEMISSILE);
		proj.velocity = w_shotdir * autocvar_g_rm_laser_speed;
		proj.velocity = W_CalculateProjectileVelocity(actor, actor.velocity, proj.velocity, true);
        proj.angles = vectoangles(proj.velocity);
        settouch(proj, W_RocketMinsta_Laser_Touch);
        setsize(proj, '0 0 -3', '0 0 -3');
        proj.flags = FL_PROJECTILE;
        IL_PUSH(g_projectiles, proj);
        IL_PUSH(g_bot_dodge, proj);
        proj.missile_flags = MIF_SPLASH;

        CSQCProjectile(proj, true, PROJECTILE_ROCKETMINSTA_LASER, true);

        MUTATOR_CALLHOOK(EditProjectile, actor, proj);
        counter++;
    }
}

METHOD(Vaporizer, wr_aim, void(entity thiswep, entity actor, .entity weaponentity))
{
    if(GetResource(actor, thiswep.ammo_type) > 0)
        PHYS_INPUT_BUTTON_ATCK(actor) = bot_aim(actor, weaponentity, 1000000, 0, 1, false);
    else
        PHYS_INPUT_BUTTON_ATCK2(actor) = bot_aim(actor, weaponentity, WEP_CVAR_SEC(vaporizer, speed), 0, WEP_CVAR_SEC(vaporizer, lifetime), false); // WEAPONTODO: replace with proper vaporizer cvars
}
METHOD(Vaporizer, wr_think, void(entity thiswep, entity actor, .entity weaponentity, int fire))
{
    float vaporizer_ammo = ((autocvar_g_instagib) ? 1 : WEP_CVAR_PRI(vaporizer, ammo));
    // if the laser uses load, we also consider its ammo for reloading
    if(WEP_CVAR(vaporizer, reload_ammo) && WEP_CVAR_SEC(vaporizer, ammo) && actor.(weaponentity).clip_load < min(vaporizer_ammo, WEP_CVAR_SEC(vaporizer, ammo))) { // forced reload
        thiswep.wr_reload(thiswep, actor, weaponentity);
    } else if(WEP_CVAR(vaporizer, reload_ammo) && actor.(weaponentity).clip_load < vaporizer_ammo) { // forced reload
        thiswep.wr_reload(thiswep, actor, weaponentity);
    }
    if((fire & 1) && (GetResource(actor, RES_CELLS) || !autocvar_g_rm) && !weaponLocked(actor))
    {
        if(weapon_prepareattack(thiswep, actor, weaponentity, false, WEP_CVAR_PRI(vaporizer, refire)))
        {
            W_Vaporizer_Attack(thiswep, actor, weaponentity);
            weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR_PRI(vaporizer, animtime), w_ready);
        }
    }
    if((fire & 2) || ((fire & 1) && !GetResource(actor, RES_CELLS) && autocvar_g_rm))
    {
        if((autocvar_g_rm && autocvar_g_rm_laser) || autocvar_g_rm_laser == 2)
        {
            bool rapid = autocvar_g_rm_laser_rapid;
            if(actor.(weaponentity).jump_interval <= time && !actor.(weaponentity).held_down)
            {
                if(rapid)
                    actor.(weaponentity).held_down = true;
                actor.(weaponentity).jump_interval = time + autocvar_g_rm_laser_refire;
                actor.(weaponentity).jump_interval2 = time + autocvar_g_rm_laser_rapid_delay;
                damage_goodhits = 0;
                W_RocketMinsta_Attack2(actor, weaponentity);
            }
            else if(rapid && actor.(weaponentity).jump_interval2 <= time && actor.(weaponentity).held_down)
            {
                actor.(weaponentity).jump_interval2 = time + autocvar_g_rm_laser_rapid_refire;
                damage_goodhits = 0;
                W_RocketMinsta_Attack3(actor, weaponentity);
                //weapon_thinkf(actor, WFRAME_FIRE2, autocvar_g_rm_laser_rapid_animtime, w_ready);
            }
        }
        else if (actor.(weaponentity).jump_interval <= time)
        {
            // handle refire manually, so that primary and secondary can be fired without conflictions (important for instagib)
            actor.(weaponentity).jump_interval = time + WEP_CVAR_SEC(vaporizer, refire) * W_WeaponRateFactor(actor);

            // decrease ammo for the laser?
            if(WEP_CVAR_SEC(vaporizer, ammo))
                W_DecreaseAmmo(thiswep, actor, WEP_CVAR_SEC(vaporizer, ammo), weaponentity);

            BLASTER_SECONDARY_ATTACK(vaporizer, actor, weaponentity);

            // now do normal refire
            weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR_SEC(vaporizer, animtime), w_ready);
        }
    }
    else
        actor.(weaponentity).held_down = false;
}
METHOD(Vaporizer, wr_setup, void(entity thiswep, entity actor, .entity weaponentity))
{
    actor.vaporizer_lasthit = 0;
}
METHOD(Vaporizer, wr_checkammo1, bool(entity thiswep, entity actor, .entity weaponentity))
{
    float vaporizer_ammo = ((autocvar_g_instagib) ? 1 : WEP_CVAR_PRI(vaporizer, ammo));
    float ammo_amount = GetResource(actor, thiswep.ammo_type) >= vaporizer_ammo;
    ammo_amount += actor.(weaponentity).(weapon_load[thiswep.m_id]) >= vaporizer_ammo;
    return ammo_amount;
}
METHOD(Vaporizer, wr_checkammo2, bool(entity thiswep, entity actor, .entity weaponentity))
{
    if(!WEP_CVAR_SEC(vaporizer, ammo))
        return true;
    float ammo_amount = GetResource(actor, thiswep.ammo_type) >= WEP_CVAR_SEC(vaporizer, ammo);
    ammo_amount += actor.(weaponentity).(weapon_load[thiswep.m_id]) >= WEP_CVAR_SEC(vaporizer, ammo);
    return ammo_amount;
}
METHOD(Vaporizer, wr_resetplayer, void(entity thiswep, entity actor))
{
    actor.vaporizer_lasthit = 0;
}
METHOD(Vaporizer, wr_reload, void(entity thiswep, entity actor, .entity weaponentity))
{
    float vaporizer_ammo = ((autocvar_g_instagib) ? 1 : WEP_CVAR_PRI(vaporizer, ammo));
    float used_ammo;
    if(WEP_CVAR_SEC(vaporizer, ammo))
        used_ammo = min(vaporizer_ammo, WEP_CVAR_SEC(vaporizer, ammo));
    else
        used_ammo = vaporizer_ammo;

    W_Reload(actor, weaponentity, used_ammo, SND_RELOAD);
}
METHOD(Vaporizer, wr_suicidemessage, Notification(entity thiswep))
{
    return WEAPON_THINKING_WITH_PORTALS;
}
METHOD(Vaporizer, wr_killmessage, Notification(entity thiswep))
{
    return WEAPON_VAPORIZER_MURDER;
}

#endif
#ifdef CSQC

METHOD(Vaporizer, wr_impacteffect, void(entity thiswep, entity actor))
{
    vector org2 = w_org + w_backoff * 6;
    if(w_deathtype & HITTYPE_SECONDARY)
    {
        pointparticles(EFFECT_BLASTER_IMPACT, org2, w_backoff * 1000, 1);
        if(!w_issilent) { sound(actor, CH_SHOTS, SND_LASERIMPACT, VOL_BASE, ATTN_NORM); }
    }
    else
    {
        pointparticles(EFFECT_VORTEX_IMPACT, org2, '0 0 0', 1);
        if(!w_issilent) { sound(actor, CH_SHOTS, SND_NEXIMPACT, VOL_BASE, ATTN_NORM); }
    }
}
METHOD(Vaporizer, wr_init, void(entity thiswep))
{
    if(autocvar_cl_reticle && autocvar_cl_reticle_weapon)
    {
        precache_pic("gfx/reticle_nex");
    }
}
METHOD(Vaporizer, wr_zoom, bool(entity thiswep, entity actor))
{
    if(button_zoom || zoomscript_caught)
    {
        return true;
    }
    else
    {
        // no weapon specific image for this weapon
        return false;
    }
}

#endif
