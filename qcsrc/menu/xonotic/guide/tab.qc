#ifndef DIALOG_MEDIA_GUIDE_H
#define DIALOG_MEDIA_GUIDE_H
#include "../datasource.qc"

#define TOPICS(X) \
    X(NEW(FreetextSource),  _("Guide"),     "gametype_tdm") \
    X(NEW(GametypeSource),  _("Gametypes"), "gametype_dm") \
    X(NEW(WeaponSource),    _("Weapons"),   "gametype_ka") \
    X(NEW(ItemSource),      _("Items"),     "gametype_kh") \
    X(NEW(BuffSource),      _("Buffs"),     "gametype_dom") \
    X(NEW(NadeSource),      _("Nades"),     "gametype_ft") \
    X(NEW(MonsterSource),   _("Monsters"),  "gametype_lms") \
    X(NEW(VehicleSource),   _("Vehicles"),  "gametype_rc") \
    X(NEW(TurretSource),    _("Turrets"),   "gametype_as") \
    X(NEW(MutatorSource),   _("Mutators"),  "gametype_nb") \
    X(NEW(MapSource),       _("Maps"),      "gametype_ctf") \
    if (cvar("developer")) X(NEW(DebugSource), _("Debug"), "gametype_ons") \
    /**/
CLASS(TopicSource, DataSource)
    METHOD(TopicSource, getEntry, entity(TopicSource this, int i, void(string, string) returns)) {
        int idx = 0;
        #define TOPIC(src, name, icon) if (idx++ == i) { if (returns) returns(name, icon); return DataSource_true; }
        TOPICS(TOPIC);
        #undef TOPIC
        if (returns) returns("undefined", "undefined");
        return DataSource_false;
    }
    METHOD(TopicSource, reload, int(TopicSource this, string filter)) {
        int n = 0;
        #define TOPIC(src, name, icon) n++;
        TOPICS(TOPIC);
        #undef TOPIC
        return n;
    }
ENDCLASS(TopicSource)

CLASS(DebugSource, DataSource)
    .entity nextdebug;
    entity find_debug() {
        entity head = NULL, tail = NULL;
        for (entity it = NULL; (it = nextent(it)); ) {
            if (!it.instanceOfObject) continue;
            if (it.instanceOfItem) continue;
            if (it.instanceOfAnimHost) continue;
            if (it.instanceOfDataSource) continue;
            if (it.classname == "Object") continue;
            if (it.classname == "vtbl") continue;
            if (!tail) {
                tail = head = it;
            } else {
                tail.nextdebug = it;
                tail = it;
            }
        }
        return head;
    }
    string DebugSource_activeFilter = "";
    METHOD(DebugSource, getEntry, entity(DebugSource this, int i, void(string, string) returns)) {
        int idx = 0;
        entity e;
        for (e = find_debug(); e; e = e.nextdebug) {
            if (strstrofs(sprintf("entity %i", e), DebugSource_activeFilter, 0) < 0) continue;
            if (idx++ == i) break;
        }
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(DebugSource, reload, int(DebugSource this, string filter)) {
        DebugSource_activeFilter = filter;
        int idx = 0;
        entity e;
        for (e = find_debug(); e; e = e.nextdebug) {
            if (strstrofs(sprintf("entity %i", e), DebugSource_activeFilter, 0) < 0) continue;
            idx++;
        }
        return idx;
    }
ENDCLASS(DebugSource)

#define REGISTRY_SOURCE(id, arr) \
CLASS(id, DataSource) \
    METHOD(id, getEntry, entity(id this, int i, void(string, string) returns)) { \
        entity e = arr[i]; \
        if (returns) e.display(e, returns); \
        return e; \
    } \
    METHOD(id, reload, int(id this, string filter)) { return arr##_COUNT; } \
ENDCLASS(id)

#include "pages.qh"
REGISTRY_SOURCE(FreetextSource, GuidePages)

#include "../../../common/mapinfo.qh"
REGISTRY_SOURCE(GametypeSource, Gametypes)

#include "../../../common/items/all.qh"
REGISTRY_SOURCE(ItemSource, Items)

#include "../../../common/buffs/all.qh"
REGISTRY_SOURCE(BuffSource, Buffs)

#include "../../../common/nades/all.qh"
REGISTRY_SOURCE(NadeSource, Nades)

#include "../../../common/weapons/all.qh"
REGISTRY_SOURCE(WeaponSource, Weapons)

#include "../../../common/monsters/all.qh"
REGISTRY_SOURCE(MonsterSource, Monsters)

#include "../../../common/vehicles/all.qh"
REGISTRY_SOURCE(VehicleSource, Vehicles)

#include "../../../common/turrets/all.qh"
REGISTRY_SOURCE(TurretSource, Turrets)

#include "../../../common/mutators/base.qh"
REGISTRY_SOURCE(MutatorSource, MUTATORS)

CLASS(MapSource, DataSource)
    METHOD(MapSource, getEntry, entity(MapSource this, int i, void(string, string) returns)) {
        if (!MapInfo_Get_ByID(i)) return DataSource_false;
        string path = strcat("/maps/", MapInfo_Map_bspname);
        string img = draw_PictureSize(path) ? path : "nopreview_map";
        if (returns) returns(MapInfo_Map_titlestring, img);
        MapInfo_ClearTemps();
        return DataSource_true;
    }
    METHOD(MapSource, indexOf, int(MapSource this, string s)) {
        MapInfo_FindName(s);
        return MapInfo_FindName_firstResult;
    }
    METHOD(MapSource, reload, int(MapSource this, string s)) {
        MapInfo_FilterGametype(MAPINFO_TYPE_ALL, 0, 0, 0, 0);
        if (s) MapInfo_FilterString(s);
        return MapInfo_count;
    }
    METHOD(MapSource, destroy, void(MapSource this)) { MapInfo_Shutdown(); }
ENDCLASS(MapSource)

#include "topics.qc"
#include "entries.qc"
#include "description.qc"
#include "../tab.qc"
CLASS(XonoticGuideTab, XonoticTab)
    ATTRIB(XonoticGuideTab, rows, float, 21)
    ATTRIB(XonoticGuideTab, columns, float, 6)
	ATTRIB(XonoticGuideTab, intendedWidth, float, 1)
    METHOD(XonoticGuideTab, fill, void(entity));
    METHOD(XonoticGuideTab, topicChangeNotify, void(entity, entity));
    METHOD(XonoticGuideTab, entryChangeNotify, void(entity, entity));

    ATTRIB(XonoticGuideTab, topicList, entity, NEW(XonoticTopicList, NEW(TopicSource)))
    ATTRIB(XonoticGuideTab, entryList, entity, NEW(XonoticEntryList, NULL))
    ATTRIB(XonoticGuideTab, descriptionPane, entity, NEW(XonoticGuideDescription))

    INIT(XonoticGuideTab) {
        this.configureDialog(this);
    }
ENDCLASS(XonoticGuideTab)
#endif

#ifdef IMPLEMENTATION

void XonoticGuideTab_fill(entity this)
{
    entity topics = this.topicList;
        topics.onChange = XonoticGuideTab_topicChangeNotify;
        topics.onChangeEntity = this;
    entity entries = this.entryList;
        entries.onChange = XonoticGuideTab_entryChangeNotify;
        entries.onChangeEntity = this;
    entity filter = entries.stringFilterBox = makeXonoticInputBox(false, string_null);
        filter.keyDown = MapList_StringFilterBox_keyDown;
        filter.onChange = MapList_StringFilterBox_Change;
        filter.onChangeEntity = entries;
    entries.controlledTextbox = filter;
    entity description = this.descriptionPane;

    int
    col = 0, width = 1.5;
    this.gotoRC(this, 0, col);
        this.TD(this, 1, width, makeXonoticHeaderLabel(_("Topic")));
    this.TR(this);
        this.TD(this, this.rows - 1, width, topics);

    col += width, width = 2;
    this.gotoRC(this, 0, col); this.setFirstColumn(this, this.currentColumn);
        this.TD(this, 1, width, makeXonoticHeaderLabel(_("Entry")));
    this.TR(this);
        this.TD(this, this.rows - 1 - 1, width, entries);
    this.gotoRC(this, this.rows - 1, col);
        this.TD(this, 1, 0.3, makeXonoticTextLabel(0, _("Filter:")));
        this.TD(this, 1, width - 0.3, filter);

    col += width, width = 2.5;
    this.gotoRC(this, 0, col); this.setFirstColumn(this, this.currentColumn);
        this.TD(this, 1, width, makeXonoticHeaderLabel(_("Description")));
    this.TR(this);
        this.TD(this, this.rows - 1, width, description);

    this.topicChangeNotify(topics, this);
}

void XonoticGuideTab_topicChangeNotify(entity, entity this)
{
    entity topics = this.topicList;
    entity entries = this.entryList;
    int i = topics.selectedItem;
    int idx = 0;
    entity found = NULL;
    #define TOPIC(src, name, icon) if (idx++ == i) { static entity e; if (!e) e = src; found = e; break; }
    do { TOPICS(TOPIC); } while (0);
    #undef TOPIC
    entries.source = found;
    entries.refilter(entries);
    entries.setSelected(entries, 0);
}

void XonoticGuideTab_entryChangeNotify(entity, entity this)
{
    entity desc = this.descriptionPane;
    entity entries = this.entryList;
    entity e = entries.source.getEntry(entries.source, entries.selectedItem, func_null);
    string s = e.describe(e);
    if (cvar("developer")) { s = sprintf("entity %i\n%s", e, s); }
    desc.setDescription(desc, s);
}

#endif
