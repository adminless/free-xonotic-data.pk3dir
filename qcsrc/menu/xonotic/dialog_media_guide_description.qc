#ifndef DIALOG_MEDIA_GUIDE_DESCRIPTION_H
#define DIALOG_MEDIA_GUIDE_DESCRIPTION_H
#include "credits.qc"
CLASS(XonoticGuideDescription, XonoticListBox)
	ATTRIB(XonoticGuideDescription, rowsPerItem, float, 1)
	ATTRIB(XonoticGuideDescription, selectionDoesntMatter, bool, true)

	METHOD(XonoticGuideDescription, resizeNotify, void(entity, vector, vector, vector, vector))
    void XonoticGuideDescription_resizeNotify(entity this, vector relOrigin, vector relSize, vector absOrigin, vector absSize)
    {
        super.resizeNotify(this, relOrigin, relSize, absOrigin, absSize);

        this.realFontSize_y = this.fontSize / (absSize.y * this.itemHeight);
        this.realFontSize_x = this.fontSize / (absSize.x * (1 - this.controlWidth));
        this.realUpperMargin = 0.5 * (1 - this.realFontSize.y);
    }

    INIT(XonoticGuideDescription) {
        this.configureXonoticListBox(this);
    }

    ATTRIB(XonoticGuideDescription, description, string, string_null)
    METHOD(XonoticGuideDescription, setDescription, void(entity, string))
    void XonoticGuideDescription_setDescription(entity this, string desc)
    {
        string current = this.description;
        if (current) strunzone(current);
        this.description = strzone(desc);
        int n = tokenizebyseparator(desc, "\n");
        this.nItems = n;
    }

    METHOD(XonoticGuideDescription, drawListBoxItem, void(entity, int, vector, bool, bool))
    void XonoticGuideDescription_drawListBoxItem(entity this, int i, vector absSize, bool isSelected, bool isFocused)
    {
        tokenizebyseparator(this.description, "\n");
        draw_Text(this.realUpperMargin * eY, argv(i), this.realFontSize, '1 1 1', 1, 0);
    }
ENDCLASS(XonoticGuideDescription)
#endif
