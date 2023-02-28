#pragma once
#include <rack.hpp>

using namespace rack;

// Declare the Plugin, defined in plugin.cpp
extern Plugin* pluginInstance;

#define MODEL(name) extern Model *name
#include "modules.hpp"

extern float tanpif(float f);

////////////////////
// Knobs
////////////////////

struct KRoundBlackKnob : RoundBlackKnob {
	KRoundBlackKnob() {
		setSvg(Svg::load(asset::plugin(pluginInstance, "res/RoundBlackKnob.svg")));
		bg->setSvg(Svg::load(asset::plugin(pluginInstance, "res/RoundBlackKnob_bg.svg")));
	}
};

struct KRoundBlackSnapKnob : KRoundBlackKnob {
	KRoundBlackSnapKnob() {
		snap = true;
	}
};

////////////////////
// Ports
////////////////////

struct KPJ301MPort : PJ301MPort {
	KPJ301MPort() {
		setSvg(Svg::load(asset::plugin(pluginInstance, "res/PJ301M.svg")));
		shadow->opacity = 0.0f;
	}
};

////////////////////
// Misc
////////////////////

struct KScrewSilver : ScrewSilver {
	KScrewSilver() {
		setSvg(Svg::load(asset::plugin(pluginInstance, "res/ScrewSilver.svg")));
	}
};

#define LABEL 8.0f
#define SCALE_LBL (LABEL / 18.0f)

struct LabelWidget : LightWidget {//TransparentWidget {
	const char *what;
	int kind;
	const std::string fontPath = asset::system("res/fonts/DSEG7ClassicMini-Regular.ttf");

	LabelWidget(const char *p, const int k) {
		what = p;
		kind = k;
	}

	void drawLayer(const DrawArgs& args, int layer) override {
		if (layer == 1 /* || layer == 0 */) {
			drew(args);
		}
		Widget::drawLayer(args, layer);
	}

	void drew(const DrawArgs &args) {//foreground
		std::shared_ptr<Font> font;
		if (!(font = APP->window->loadFont(fontPath))) {
			return;
		}
		NVGcolor textColor;
		switch(kind) {
			case -1:
				textColor = SCHEME_GREEN;
				break;
			case 0: default:
				textColor = SCHEME_YELLOW;
				break;
			case 1:
				textColor = SCHEME_RED;
				break;
		}
		nvgFontFaceId(args.vg, font->handle);
		nvgFontSize(args.vg, LABEL);

		Vec textPos = Vec(4 * SCALE_LBL, 22 * SCALE_LBL);
		nvgFillColor(args.vg, textColor);
		nvgText(args.vg, textPos.x, textPos.y, what, NULL);
	}

	void fixCentre(Vec here, int many) {//locate control
		box.size = Vec((14.6f * many + 4) * SCALE_LBL, 26 * SCALE_LBL);
		box.pos = Vec(here.x - box.size.x / 2, here.y - box.size.y / 2);
	}
};

struct KLightWidget : ModuleLightWidget {
	void drawLayer(const DrawArgs& args, int layer) override {
		if(layer == 1) {
			if (this->color.a > 0.0) {
				nvgBeginPath(args.vg);
				nvgRect(args.vg, 0, 0, this->box.size.x, this->box.size.y);
				nvgFillColor(args.vg, this->color);
				nvgFill(args.vg);
			}
		}
		Widget::drawLayer(args, layer);
	}
};

struct KGRLightWidget : KLightWidget {
	KGRLightWidget() {
		bgColor = SCHEME_BLACK;
		borderColor = SCHEME_BLACK_TRANSPARENT;
		addBaseColor(SCHEME_GREEN);
        addBaseColor(SCHEME_RED);
		box.size = Vec(14, 14);
	}
};

extern int maxPoly(Module *m, const int numIn, const int numOut);

#define HP_UNIT 5.08
#define WIDTH (HP*HP_UNIT)
#define X_SPLIT (WIDTH / 2.f / LANES)

#define HEIGHT 128.5
#define Y_MARGIN 0.05f
#define R_HEIGHT (HEIGHT*(1-2*Y_MARGIN))
#define Y_SPLIT (R_HEIGHT / 2.f / RUNGS)

//placement macro
#define loc(x,y) mm2px(Vec(X_SPLIT*(1+2*(x-1)), (HEIGHT*Y_MARGIN)+Y_SPLIT*(1+2*(y-1))))

extern void populate(ModuleWidget *m, int hp, int lanes, int rungs, const int ctl[],
							const char *lbl[], const int kind[]);

////////////////////
// Synchronization
////////////////////
// atomic forward parallel list
// item made atomic to prevent non-NULL save before sheduled after
// any field in item used for sequencing must be atomic (i.e. bool done)
// to prevent list addition of OoO scheduled writes
// N.B. there is no LIFO order garauntee
// this structure is both the element and the pointer to list

// to be safe the reader shouldn't remove or add things but can traverse
// the list and mark feedback atomics in kind for the writer to remove and update
// in this way list containment represents read freedom until an atomic
// within kind is set to allow updates.

// a reader may clone or merge various kind structures and then use an atomic
// in kind to get updates, as this would be more efficient than the writer
// checking containment (although it could do this).

// allowing deletes of things (a type of write) needs some signalling.
// a read proxy likely needs a plist to track when reclimation can happen.
template<typename kind>
struct plist {
	std::atomic<plist<kind>*> next;
	std::atomic<kind*> item;
	void insertOne(plist<kind>* what);
	plist<kind>* removeAfter(plist<kind>* what);
	//plist<kind>* removeOneAfter();//BAD, needs unique reference plist<kind>*
	bool containedAfter(plist<kind>* what);
	// malloc from new and delete can lock on heap compaction
	// use the following to obtain and release unique reference list elements
	plist<kind>* supply(kind* what);
	kind* resolve(plist<kind>* what);
};

////////////////////
// Threading
////////////////////
#include <pthread.h>
#include <unistd.h>
// for craeting a thread with an exec process
// FORK inside the fn of THREAD
#define THREAD(name, fn) static pthread_t name; if(pthread_create(&name, NULL, fn, NULL)) WARN("thread create failed")
#define THREADXIT() pthread_exit(NULL)
extern void JOIN(pid_t pid);
extern pid_t FORK(char* fn, char** args);
extern int FORK_R(char *buff, int count);
extern int FORK_W(char *buff, int count);

////////////////////
// Menu Additions
////////////////////
// add MenuSelection enum values and then do in .cpp
enum MenuSelection {

	MAX_MENU
};
extern MenuSelection modeScript;
extern void resetMenu(MenuSelection *var);
extern void appendMenu(MenuSelection *var, Menu *menu, char* name);
extern void menuToJson(json_t* rootJ, MenuSelection *var);
extern void menuFromJson(json_t* rootJ, MenuSelection *var);
extern void menuRandomize(MenuSelection *var);
extern void appendSubMenu(MenuSelection *var, Menu *menu, char* name);

