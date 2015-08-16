#ifndef DIALOG_MEDIA_GUIDE_H
#define DIALOG_MEDIA_GUIDE_H
#include "datasource.qc"

#define TOPICS(X) \
    X(NEW(GametypeSource),  _("Gametypes"), "gametype_dm") \
    X(NEW(MapSource),       _("Maps"),      "gametype_ctf") \
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
#include "tab.qc"
CLASS(XonoticGuideTab, XonoticTab)
    ATTRIB(XonoticGuideTab, rows, float, 21)
    ATTRIB(XonoticGuideTab, columns, float, 6)
    METHOD(XonoticGuideTab, fill, void(entity))
    METHOD(XonoticGuideTab, topicChangeNotify, void(entity))
    METHOD(XonoticGuideTab, topicSelectNotify, void(entity))

    ATTRIB(XonoticGuideTab, topicList, entity, NEW(XonoticTopicList, NEW(TopicSource), this))
    ATTRIB(XonoticGuideTab, entryList, entity, NEW(XonoticEntryList, NULL))

    INIT(XonoticGuideTab) {
        this.configureDialog(this);
    }
ENDCLASS(XonoticGuideTab)
#endif

#ifdef IMPLEMENTATION

void XonoticGuideTab_fill(entity this)
{
    entity topics = this.topicList;
    entity entries = this.entryList;
    entity filter = entries.stringFilterBox = makeXonoticInputBox(false, string_null);
        filter.keyDown = MapList_StringFilterBox_keyDown;
        filter.onChange = MapList_StringFilterBox_Change;
        filter.onChangeEntity = entries;
    entries.controlledTextbox = filter;

    this.gotoRC(this, 0, 0);
        this.TD(this, 1, 3 / 2, makeXonoticHeaderLabel(_("Topic")));
    this.TR(this);
        this.TD(this, this.rows - 1, 3 / 2, topics);

    this.gotoRC(this, 0, 3 / 2);
        this.setFirstColumn(this, this.currentColumn);
        this.TD(this, 1, 2, makeXonoticHeaderLabel(_("Entry")));
    this.TR(this);
        this.TD(this, this.rows - 1 - 1, 2, entries);

    this.gotoRC(this, this.rows - 1, this.firstColumn);
        this.TD(this, 1, 0.3, makeXonoticTextLabel(0, _("Filter:")));
        this.TD(this, 1, 2 - 0.3, filter);

    this.topicChangeNotify(this);
}

void XonoticGuideTab_topicChangeNotify(entity this)
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

void XonoticGuideTab_topicSelectNotify(entity this) { this.setFocus(this, this.entryList); }

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
