#ifndef DIALOG_MEDIA_GUIDE_ENTRIES_H
#define DIALOG_MEDIA_GUIDE_ENTRIES_H
#include "datasource.qc"
#include "listbox.qc"
CLASS(XonoticEntryList, XonoticListBox)
    ATTRIB(XonoticEntryList, alphaBG, float, 0)
    ATTRIB(XonoticEntryList, columnNameOrigin, float, 0)
    ATTRIB(XonoticEntryList, columnNameSize, float, 0)
    ATTRIB(XonoticEntryList, columnPreviewOrigin, float, 0)
    ATTRIB(XonoticEntryList, columnPreviewSize, float, 0)
    ATTRIB(XonoticEntryList, itemAbsSize, vector, '0 0 0')
    ATTRIB(XonoticEntryList, origin, vector, '0 0 0')
    ATTRIB(XonoticEntryList, realFontSize, vector, '0 0 0')
    ATTRIB(XonoticEntryList, realUpperMargin1, float, 0)
    ATTRIB(XonoticEntryList, realUpperMargin2, float, 0)
    ATTRIB(XonoticEntryList, rowsPerItem, float, 4)
    ATTRIB(XonoticEntryList, stringFilterBox, entity, NULL)
    ATTRIB(XonoticEntryList, stringFilter, string, string_null)
    ATTRIB(XonoticEntryList, typeToSearchString, string, string_null)
    ATTRIB(XonoticEntryList, typeToSearchTime, float, 0)

    METHOD(XonoticEntryList, drawListBoxItem, void(entity, int, vector, bool, bool))
    METHOD(XonoticEntryList, keyDown, float(entity, float, float, float))
    METHOD(XonoticEntryList, refilter, void(entity))
    METHOD(XonoticEntryList, resizeNotify, void(entity, vector, vector, vector, vector))

    ATTRIB(XonoticEntryList, source, DataSource, NULL)

    CONSTRUCTOR(XonoticEntryList, DataSource _source) {
        CONSTRUCT(XonoticEntryList);
        this.source = _source;
        this.configureXonoticListBox(this);
        this.refilter(this);
    }

ENDCLASS(XonoticEntryList)
#endif

#ifdef IMPLEMENTATION

void XonoticEntryList_drawListBoxItem(entity this, int i, vector absSize, bool isSelected, bool isFocused)
{
    entity e = this.source.getEntry(i);
    if (!e) return;

    if (isSelected) {
        draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_SELECTED, SKINALPHA_LISTBOX_SELECTED);
    } else if (isFocused) {
        this.focusedItemAlpha = getFadedAlpha(this.focusedItemAlpha, SKINALPHA_LISTBOX_FOCUSED, SKINFADEALPHA_LISTBOX_FOCUSED);
        draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_FOCUSED, this.focusedItemAlpha);
    }
    string s = draw_TextShortenToWidth(strdecolorize(e.(this.source.entryName)), this.columnNameSize, 0, this.realFontSize);
    draw_Picture(this.columnPreviewOrigin * eX, e.(this.source.entryIcon), this.columnPreviewSize * eX + eY, '1 1 1', SKINALPHA_LISTBOX_SELECTED);
    draw_Text(this.realUpperMargin1 * eY + (this.columnNameOrigin + 0.00 * (this.columnNameSize - draw_TextWidth(s, 0, this.realFontSize))) * eX, s, this.realFontSize, '1 1 1', SKINALPHA_TEXT, 0);
}

float XonoticEntryList_keyDown(entity this, float scan, float ascii, float shift)
{
    if (this.nItems <= 0) {
        return super.keyDown(this, scan, ascii, shift);
    } else if (scan == K_BACKSPACE) {
        if (time < this.typeToSearchTime) {
            string save = substring(this.typeToSearchString, 0, strlen(this.typeToSearchString) - 1);
            if (this.typeToSearchString) strunzone(this.typeToSearchString);
            this.typeToSearchString = strzone(save);
            this.typeToSearchTime = time + 0.5;
            if (strlen(this.typeToSearchString)) {
                int idx = this.source.indexOf(this.typeToSearchString);
                if (idx >= 0) this.setSelected(this, idx);
            }
        }
    } else if (ascii >= 32 && ascii != 127) {
        string ch = chr(ascii);
        string save = (time > this.typeToSearchTime) ? ch : strcat(this.typeToSearchString, ch);
        if (this.typeToSearchString) strunzone(this.typeToSearchString);
        this.typeToSearchString = strzone(save);
        this.typeToSearchTime = time + 0.5;
        int idx = this.source.indexOf(this.typeToSearchString);
        if (idx >= 0) this.setSelected(this, idx);
    } else if (shift & S_CTRL && scan == 'f') {
        this.parent.setFocus(this.parent, this.stringFilterBox);
    } else if (shift & S_CTRL && scan == 'u') {
        this.stringFilterBox.setText(this.stringFilterBox, "");
        if (this.stringFilter) strunzone(this.stringFilter);
        this.stringFilter = string_null;
        this.refilter(this);
    }
    return super.keyDown(this, scan, ascii, shift);
}

void XonoticEntryList_refilter(entity this)
{
    this.nItems = this.source.reload(this.stringFilter);
    for (int i = 0, n = this.nItems; i < n; ++i) {
        draw_PreloadPicture(this.source.getEntry(i).(this.source.entryIcon));
    }
}

void XonoticEntryList_resizeNotify(entity this, vector relOrigin, vector relSize, vector absOrigin, vector absSize)
{
    this.itemAbsSize = '0 0 0';
    super.resizeNotify(this, relOrigin, relSize, absOrigin, absSize);

    this.realFontSize_y = this.fontSize / (this.itemAbsSize_y = (absSize.y * this.itemHeight));
    this.realFontSize_x = this.fontSize / (this.itemAbsSize_x = (absSize.x * (1 - this.controlWidth)));
    this.realUpperMargin1 = 0.5 * (1 - 2.5 * this.realFontSize.y);
    this.realUpperMargin2 = this.realUpperMargin1 + 1.5 * this.realFontSize.y;

    this.columnPreviewOrigin = 0;
    this.columnPreviewSize = this.itemAbsSize.y / this.itemAbsSize.x * 4 / 3;
    this.columnNameOrigin = this.columnPreviewOrigin + this.columnPreviewSize + this.realFontSize.x;
    this.columnNameSize = 1 - this.columnPreviewSize - 2 * this.realFontSize.x;
}
#endif
