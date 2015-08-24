#ifndef DIALOG_MEDIA_GUIDE_H
#define DIALOG_MEDIA_GUIDE_H
#include "datasource.qc"

#define TOPICS(X) \
    X(NEW(GametypeSource),  _("Gametypes"), "gametype_dm") \
    X(NEW(WeaponSource),    _("Weapons"),   "gametype_ka") \
    X(NEW(ItemSource),      _("Items"),     "gametype_kh") \
    X(NEW(BuffSource),      _("Buffs"),     "gametype_dom") \
    X(NEW(NadeSource),      _("Nades"),     "gametype_ft") \
    X(NEW(MapSource),       _("Maps"),      "gametype_ctf") \
    if (cvar("developer")) X(NEW(DebugSource), _("Debug"), "gametype_ons") \
    /**/
CLASS(TopicSource, DataSource)
    METHOD(TopicSource, getEntry, entity(int i, void(string, string) returns)) {
        int idx = 0;
        #define TOPIC(src, name, icon) if (idx++ == i) { if (returns) returns(name, icon); return DataSource_true; }
        TOPICS(TOPIC);
        #undef TOPIC
        if (returns) returns("undefined", "undefined");
        return DataSource_false;
    }
    METHOD(TopicSource, reload, int(string filter)) {
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
    METHOD(DebugSource, getEntry, entity(int i, void(string, string) returns)) {
        int idx = 0;
        entity e;
        for (e = find_debug(); e; e = e.nextdebug) {
            if (strstrofs(sprintf("entity %i", e), DebugSource_activeFilter, 0) < 0) continue;
            if (idx++ == i) break;
        }
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(DebugSource, reload, int(string filter)) {
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

#include "../../common/mapinfo.qh"
CLASS(GametypeSource, DataSource)
    METHOD(GametypeSource, getEntry, entity(int i, void(string, string) returns)) {
        entity e = MAPINFO_TYPES[i];
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(GametypeSource, reload, int(string filter)) { return MAPINFO_TYPE_COUNT; }
ENDCLASS(GametypeSource)

#include "../../common/items/all.qh"
CLASS(ItemSource, DataSource)
    METHOD(ItemSource, getEntry, entity(int i, void(string, string) returns)) {
        entity e = ITEMS[i];
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(ItemSource, reload, int(string filter)) { return ITEM_COUNT; }
ENDCLASS(ItemSource)

#include "../../common/buffs.qh"
CLASS(BuffSource, DataSource)
    METHOD(BuffSource, getEntry, entity(int i, void(string, string) returns)) {
        entity e = BUFFS[i];
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(BuffSource, reload, int(string filter)) { return BUFFS_COUNT; }
ENDCLASS(BuffSource)

#include "../../common/nades.qh"
CLASS(NadeSource, DataSource)
    METHOD(NadeSource, getEntry, entity(int i, void(string, string) returns)) {
        entity e = NADES[i];
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(NadeSource, reload, int(string filter)) { return NADES_COUNT; }
ENDCLASS(NadeSource)

#include "../../common/weapons/all.qh"
CLASS(WeaponSource, DataSource)
    METHOD(WeaponSource, getEntry, entity(int i, void(string, string) returns)) {
        entity e = weapon_info[i];
        if (returns) e.display(e, returns);
        return e;
    }
    METHOD(WeaponSource, reload, int(string filter)) { return WEP_COUNT; }
ENDCLASS(WeaponSource)

CLASS(MapSource, DataSource)
    METHOD(MapSource, getEntry, entity(int i, void(string, string) returns)) {
        if (!MapInfo_Get_ByID(i)) return DataSource_false;
        string path = strcat("/maps/", MapInfo_Map_bspname);
        string img = draw_PictureSize(path) ? path : "nopreview_map";
        if (returns) returns(MapInfo_Map_titlestring, img);
        MapInfo_ClearTemps();
        return DataSource_true;
    }
    METHOD(MapSource, indexOf, int(string s)) {
        MapInfo_FindName(s);
        return MapInfo_FindName_firstResult;
    }
    METHOD(MapSource, reload, int(string s)) {
        MapInfo_FilterGametype(MAPINFO_TYPE_ALL, 0, 0, 0, 0);
        if (s) MapInfo_FilterString(s);
        return MapInfo_count;
    }
    METHOD(MapSource, destroy, void(entity this)) { MapInfo_Shutdown(); }
ENDCLASS(MapSource)

#include "dialog_media_guide_topics.qc"
#include "dialog_media_guide_entries.qc"
#include "dialog_media_guide_description.qc"
#include "tab.qc"
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
    entity e = entries.source.getEntry(entries.selectedItem, func_null);
    string s = e.describe(e);
    if (cvar("developer")) { s = sprintf("entity %i\n%s", e, s); }
    desc.setDescription(desc, s);
}

#endif
