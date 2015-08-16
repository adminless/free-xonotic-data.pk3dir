#ifndef DIALOG_MEDIA_GUIDE_H
#define DIALOG_MEDIA_GUIDE_H
#include "datasource.qc"

#define TOPICS(X) \
    X(NEW(GametypeSource),  _("Gametypes"), "gametype_dm") \
    X(NEW(MapSource),       _("Maps"),      "gametype_ctf") \
    if (cvar("developer")) X(NEW(DebugSource), _("Debug"), "gametype_ons") \
    /**/
CLASS(TopicSource, DataSource)
    .string icon, name;
    ATTRIB(TopicSource, entryIcon, .string, icon)
    ATTRIB(TopicSource, entryName, .string, name)
    METHOD(TopicSource, getEntry, entity(int))
    entity TopicSource_getEntry(int i) {
        static entity e;
        if (!e) e = new(entry);
        int idx = 0;
        .string en = name, ei = icon;
        #define TOPIC(src, name, icon) if (idx++ == i) { e.(en) = name; e.(ei) = icon; return e; }
        TOPICS(TOPIC)
        #undef TOPIC
        e.en = "undefined"; e.ei = "undefined";
        return e;
    }
    METHOD(TopicSource, reload, int(string))
    int TopicSource_reload(string filter) {
        int i = 0;
        #define TOPIC(src, name, icon) i++;
        TOPICS(TOPIC)
        #undef TOPIC
        return i;
    }
ENDCLASS(TopicSource)

CLASS(DebugSource, DataSource)
    .string name, icon;
    ATTRIB(DebugSource, entryName, .string, name)
    ATTRIB(DebugSource, entryIcon, .string, icon)
    string DebugSource_activeFilter = "";
    .entity chain;
    METHOD(DebugSource, getEntry, entity(int))
    entity DebugSource_getEntry(int i) {
        int idx = 0;
        entity e;
        for (e = findchainfloat(instanceOfObject, true); e; e = e.chain) {
            if (e.classname == "vtbl") continue;
            if (e.instanceOfItem) continue;
            if (strstrofs(sprintf("entity %i", e), DebugSource_activeFilter, 0) < 0) continue;
            if (idx++ == i) break;
        }
        static entity entry;
        if (!entry) entry = new(entry);
        entry.name = sprintf("entity %i", e);
        entry.icon = "";
        return entry;
    }
    METHOD(DebugSource, reload, int(string))
    int DebugSource_reload(string filter) {
        DebugSource_activeFilter = filter;
        int idx = 0;
        entity e;
        for (e = findchainfloat(instanceOfObject, true); e; e = e.chain) {
            if (e.classname == "vtbl") continue;
            if (e.instanceOfItem) continue;
            if (strstrofs(sprintf("entity %i", e), DebugSource_activeFilter, 0) < 0) continue;
            idx++;
        }
        return idx;
    }
ENDCLASS(DebugSource)

#include "../../common/mapinfo.qh"
CLASS(GametypeSource, DataSource)
    .string mdl, message;
    ATTRIB(GametypeSource, entryName, .string, message)
    ATTRIB(GametypeSource, entryIcon, .string, mdl)
    ATTRIB(GametypeSource, entryIconPrefix, string, "gametype_")
    METHOD(GametypeSource, getEntry, entity(int))
    entity GametypeSource_getEntry(int i) { return MAPINFO_TYPES[i]; }
    METHOD(GametypeSource, reload, int(string))
    int GametypeSource_reload(string filter) { return MAPINFO_TYPE_COUNT; }
ENDCLASS(GametypeSource)

CLASS(MapSource, DataSource)
    .string icon, name;
    ATTRIB(MapSource, entryIcon, .string, icon)
    ATTRIB(MapSource, entryName, .string, name)
    METHOD(MapSource, getEntry, entity(int))
    METHOD(MapSource, indexOf, int(string))
    METHOD(MapSource, reload, int(string))
ENDCLASS(MapSource)

#include "dialog_media_guide_topics.qc"
#include "dialog_media_guide_entries.qc"
#include "dialog_media_guide_description.qc"
#include "tab.qc"
CLASS(XonoticGuideTab, XonoticTab)
    ATTRIB(XonoticGuideTab, rows, float, 21)
    ATTRIB(XonoticGuideTab, columns, float, 6)
	ATTRIB(XonoticGuideTab, intendedWidth, float, 1)
    METHOD(XonoticGuideTab, fill, void(entity))
    METHOD(XonoticGuideTab, topicChangeNotify, void(entity, entity))
    METHOD(XonoticGuideTab, entryChangeNotify, void(entity, entity))

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
}

void XonoticGuideTab_entryChangeNotify(entity, entity this)
{
    entity desc = this.descriptionPane;
    desc.setDescription(desc, sprintf("item %.0f\n", this.entryList.selectedItem));
}

entity MapSource_getEntry(int i)
{
    if (!MapInfo_Get_ByID(i)) return NULL;
    static entity e;
    if (!e) e = new(entry);
    e.name = MapInfo_Map_titlestring;
    string path = strcat("/maps/", MapInfo_Map_bspname);
    string img = draw_PictureSize(path) ? path : "nopreview_map";
    e.icon = img;
    MapInfo_ClearTemps();
    return e;
}

int MapSource_indexOf(string s)
{
    MapInfo_FindName(s);
    return MapInfo_FindName_firstResult;
}

int MapSource_reload(string s)
{
    MapInfo_FilterGametype(MAPINFO_TYPE_ALL, 0, 0, 0, 0);
    if (s) MapInfo_FilterString(s);
    return MapInfo_count;
}

void MapSource_destroy(entity this) { MapInfo_Shutdown(); }

#endif
