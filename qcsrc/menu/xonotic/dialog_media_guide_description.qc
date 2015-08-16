#ifndef DIALOG_MEDIA_GUIDE_DESCRIPTION_H
#define DIALOG_MEDIA_GUIDE_DESCRIPTION_H
#include "credits.qc"
CLASS(XonoticGuideDescription, XonoticCreditsList)
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
