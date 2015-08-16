#ifndef DIALOG_MEDIA_GUIDE_TOPICS_H
#define DIALOG_MEDIA_GUIDE_TOPICS_H
#include "listbox.qc"
CLASS(XonoticTopicList, XonoticListBox)
    ATTRIB(XonoticTopicList, columnIconOrigin, float, 0)
    ATTRIB(XonoticTopicList, columnIconSize, float, 0)
    ATTRIB(XonoticTopicList, columnNameOrigin, float, 0)
    ATTRIB(XonoticTopicList, columnNameSize, float, 0)
    ATTRIB(XonoticTopicList, realFontSize, vector, '0 0 0')
    ATTRIB(XonoticTopicList, realUpperMargin, float, 0)
    ATTRIB(XonoticTopicList, rowsPerItem, float, 3)

    METHOD(XonoticTopicList, clickListBoxItem, void(entity, float, vector))
    METHOD(XonoticTopicList, drawListBoxItem, void(entity, int, vector, bool, bool))
    METHOD(XonoticTopicList, keyDown, bool(entity, float, float, float))
    METHOD(XonoticTopicList, resizeNotify, void(entity, vector, vector, vector, vector))
    METHOD(XonoticTopicList, setSelected, void(entity, int))

    INIT(XonoticTopicList) {
        this.configureXonoticListBox(this);
    }

    .string stringfield_null;
    ATTRIB(XonoticTopicList, entries, entity(int), func_null)
    ATTRIB(XonoticTopicList, entryIconPrefix, string, "")
    ATTRIB(XonoticTopicList, entryIcon, .string, stringfield_null)
    ATTRIB(XonoticTopicList, entryName, .string, stringfield_null)
    ATTRIB(XonoticTopicList, listener, entity, NULL)

    CONSTRUCTOR(XonoticTopicList, entity(int) _entries, int _indexOf(string), int _reload(string), .string _entryIcon, .string _entryName, void _destroy(entity), entity _listener) {
    	CONSTRUCT(XonoticTopicList);
    	this.entries = _entries;
    	this.nItems = _reload("");
    	this.entryIcon = _entryIcon;
    	this.entryName = _entryName;
    	this.listener = _listener;
    }
ENDCLASS(XonoticTopicList)
#endif

#ifdef IMPLEMENTATION

void XonoticTopicList_clickListBoxItem(entity this, float i, vector where)
{
    m_play_click_sound(MENU_SOUND_SELECT);
}

void XonoticTopicList_drawListBoxItem(entity this, int i, vector absSize, bool isSelected, bool isFocused)
{
    if (isSelected) {
        draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_SELECTED, SKINALPHA_LISTBOX_SELECTED);
    } else if (isFocused) {
        this.focusedItemAlpha = getFadedAlpha(this.focusedItemAlpha, SKINALPHA_LISTBOX_FOCUSED, SKINFADEALPHA_LISTBOX_FOCUSED);
        draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_FOCUSED, this.focusedItemAlpha);
    }
    entity entry = this.entries(i);
    string icon = strcat(this.entryIconPrefix, entry.(this.entryIcon));
    string name = entry.(this.entryName);
    draw_Picture(this.columnIconOrigin * eX, icon, this.columnIconSize * eX + eY, '1 1 1', SKINALPHA_LISTBOX_SELECTED);
    vector save_fontscale = draw_fontscale;
    float f = draw_CondensedFontFactor(name, false, this.realFontSize, 1);
    draw_fontscale.x *= f;
    vector fs = this.realFontSize;
    fs.x *= f;
    draw_Text(this.realUpperMargin * eY + this.columnNameOrigin * eX, name, fs, '1 1 1', SKINALPHA_TEXT, 0);
    draw_fontscale = save_fontscale;
}

bool XonoticTopicList_keyDown(entity this, float scan, float ascii, float shift)
{
    if (scan == K_ENTER || scan == K_KP_ENTER) {
        m_play_click_sound(MENU_SOUND_EXECUTE);
        entity l = this.listener;
        if (l) {
        	void(entity) func = l.topicSelectNotify;
        	if (func) {
        		func(l);
        	}
        }
        return true;
    }
    return super.keyDown(this, scan, ascii, shift);
}

void XonoticTopicList_resizeNotify(entity this, vector relOrigin, vector relSize, vector absOrigin, vector absSize)
{
    this.itemAbsSize = '0 0 0';
    super.resizeNotify(this, relOrigin, relSize, absOrigin, absSize);

    this.realFontSize_y = this.fontSize / (this.itemAbsSize_y = (absSize.y * this.itemHeight));
    this.realFontSize_x = this.fontSize / (this.itemAbsSize_x = (absSize.x * (1 - this.controlWidth)));
    this.realUpperMargin = 0.5 * (1 - this.realFontSize.y);
    this.columnIconOrigin = 0;
    this.columnIconSize = this.itemAbsSize.y / this.itemAbsSize.x;
    this.columnNameOrigin = this.columnIconOrigin + this.columnIconSize + (0.5 * this.realFontSize.x);
    this.columnNameSize = 1 - this.columnIconSize - (1.5 * this.realFontSize.x);
}

void XonoticTopicList_setSelected(entity this, int i)
{
    super.setSelected(this, i);
    entity l = this.listener;
	if (l) {
		void(entity) func = l.topicChangeNotify;
		if (func) {
			func(l);
		}
	}
}
#endif
