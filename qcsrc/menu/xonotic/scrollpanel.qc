#include "scrollpanel.qh"

METHOD(XonoticScrollPanel, drawListBoxItem, void(XonoticScrollPanel this, int i, vector absSize, bool isSelected, bool isFocused))
{
	XonoticTab p = this.currentPanel;
	p.draw(p);
}

METHOD(XonoticScrollPanel, resizeNotify, void(XonoticScrollPanel this, vector relOrigin, vector relSize, vector absOrigin, vector absSize))
{
	SUPER(XonoticScrollPanel).resizeNotify(this, relOrigin, relSize, absOrigin, absSize);
	this.scrollToItem(this, 0);
	XonoticTab p = this.currentPanel;
	float m = p.firstChild.rows / this.viewportHeight;
	this.itemHeight = m;
	relSize.y *= m;
	absSize.y *= m;
	p.resizeNotify(p, relOrigin, relSize, absOrigin, absSize);
}

/*qc2rust::define::X*/
#define X(mouseFunc) /*qc2rust::macro_begin::X*/METHOD(XonoticScrollPanel,  /*qc2rust::param_begin::mouseFunc*/mouseFunc /*qc2rust::param_end::mouseFunc*/, bool(XonoticScrollPanel this, vector pos)) { 	SUPER(XonoticScrollPanel). /*qc2rust::param_begin::mouseFunc*/mouseFunc /*qc2rust::param_end::mouseFunc*/(this, pos); 	XonoticTab p = this.currentPanel; 	this.setFocus(this, p); 		vector o = -eY * this.scrollPos; 	vector s = eX * (1 - this.controlWidth) + eY * this.itemHeight; 	return p. /*qc2rust::param_begin::mouseFunc*/mouseFunc /*qc2rust::param_end::mouseFunc*/(p, globalToBox(pos, o, s)); } /*qc2rust::macro_end::X*/
X(mouseMove)
X(mousePress)
X(mouseDrag)
X(mouseRelease)
#undef X

/*qc2rust::define::X*/
#define X(keyFunc) /*qc2rust::macro_begin::X*/METHOD(XonoticScrollPanel,  /*qc2rust::param_begin::keyFunc*/keyFunc /*qc2rust::param_end::keyFunc*/, bool(XonoticScrollPanel this, int key, int ascii, bool shift)) { 	XonoticTab p = this.currentPanel; 	return p. /*qc2rust::param_begin::keyFunc*/keyFunc /*qc2rust::param_end::keyFunc*/(p, key, ascii, shift) || SUPER(XonoticScrollPanel). /*qc2rust::param_begin::keyFunc*/keyFunc /*qc2rust::param_end::keyFunc*/(this, key, ascii, shift); } /*qc2rust::macro_end::X*/
X(keyDown)
X(keyUp)
#undef X
