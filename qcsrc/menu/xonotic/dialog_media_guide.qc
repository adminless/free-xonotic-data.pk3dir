#ifndef DIALOG_MEDIA_GUIDE_H
#define DIALOG_MEDIA_GUIDE_H
#include "datasource.qc"
CLASS(TopicSource, DataSource)
    .string mdl, message;
    ATTRIB(TopicSource, entryIcon, .string, mdl)
    ATTRIB(TopicSource, entryName, .string, message)
    METHOD(TopicSource, getEntry, entity(int))
    METHOD(TopicSource, reload, int(string))
    METHOD(TopicSource, destroy, void(entity))
ENDCLASS(TopicSource)

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

    ATTRIB(XonoticGuideTab, topicSource, entity, NEW(TopicSource))
    ATTRIB(XonoticGuideTab, mapSource, entity, NEW(MapSource))

    ATTRIB(XonoticGuideTab, topicList, entity, NEW(XonoticTopicList, this.topicSource, "gametype_", this))
    ATTRIB(XonoticGuideTab, entryList, entity, NEW(XonoticEntryList, this.mapSource))

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
    entity entries = this.entryList;
    entries.refilter(entries);
}

void XonoticGuideTab_topicSelectNotify(entity this) { this.setFocus(this, this.entryList); }

entity TopicSource_getEntry(int i) { return MAPINFO_TYPES[i]; }

int TopicSource_reload(string filter) { return MAPINFO_TYPE_COUNT; }

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
