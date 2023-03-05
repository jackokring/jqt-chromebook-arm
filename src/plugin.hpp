#pragma once
#include <rack.hpp>
using namespace rack;

// Include the file watcher
#define WATCHER

///////////////////////////////////////////////////////////////
// Eventual backporting to KRTPluginA and hence MIT licence
///////////////////////////////////////////////////////////////

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
			case 2:
				textColor = SCHEME_BLUE;
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

const int laneIdxHP[] = {
	1,	// blank panel 0 lane
	3,	// 1 lane needs 3
	5,	// 2 lane needs 5
	7,	// 3 lane needs 7
	11,	// 4 lane needs 11
	11,	// 5 lane needs 11
	13,	// 6 lane needs 13
	17,	// 7 lane needs 17
	17	// 8 lane needs 17
	// maximum of 8 lanes
};

//placement macro
#define loc(x,y) mm2px(Vec(X_SPLIT*(1+2*(x-1)), (HEIGHT*Y_MARGIN)+Y_SPLIT*(1+2*(y-1))))

enum controlKind {
	SNAP_KNOB = -2,
	INPUT_PORT = -1,
	MORM_KNOB = 0,
	OUTPUT_PORT = 1,
	GR_LED =2
};

#define CTL(name) MODULE_NAME::name
#define NO_CTL -1 

extern void populate(ModuleWidget *m, int hp, int lanes, int rungs, const int ctl[],
							const char *lbl[], const int kind[], char* named);

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
// add MenuSelection enum values and then do in plugin.cpp
#define ENTRY(name, parent) MENU_ ## name

enum MenuSelection {
#include "menus.txt"
	MAX_MENU
};

extern std::atomic<bool> modeTriggers[MAX_MENU];
extern std::atomic<MenuSelection> *modeMenu[MAX_MENU];

// POINTER TO SELECTED STATE
#define MENU_SEL(sel) (modeMenu[sel])

// THE MAIN MENU STATE BOOLEAN TEST FOR ACTIVE
#define MENU_BOOL(sel) (*MENU_SEL(sel) == sel)

// MASTER MenuSelection PRODUCER OF MANGLED ENUM NAMES
#define MENU(name) ENTRY(name, NULL)

// yes, clear bool and test (if true make false), std::atomic!
#define SLOOPIE(boo) boo.load() && (boo = false, true)

////////////////////
// Menu API
////////////////////

// GUI CONTROL STRUCTURE (FOLLOW BY BLOCK {} OR STATEMENT;)
// check and do perhaps the action when triggered on
#define on(name) if(SLOOPIE(modeTriggers[MENU(name)]) && MENU_BOOL(MENU(name)))

// detect false bool trigger (must follow it by an `on` to clear trigger) 
#define onf(nmae) if(modeTriggers[MENU(name)) && *MENU_SEL(MENU(name)) == MAX_MENU) 

// GUI CONTROL STRUCTURE (FOLLOWED BY ; AS A COMPLETE STATEMENT)
// prevent `on` trigger until re-triggered
// it is not necessary to `off` after an `on`, as `on` clears the trigger
#define off(name) if(MENU_BOOL(MENU(name))) modeTriggers[MENU(name)] = false

// activate the enable trigger on all menus (triggers)
extern void refreshMenus();

// initialize (reset) and activate all menus  (triggers)
extern void primeMenus();

// append a complete menu by parent
extern void appendMenu(MenuSelection var, Menu *menu);

// add label from this parent
extern void appendMenuLabel(MenuSelection var, Menu *menu); 

// fully abstract the API
extern void appendMenuSpacer(Menu *menu);

// save menus
extern void menuToJson(json_t* rootJ, char* name);

// load menus (triggers)
extern void menuFromJson(json_t* rootJ, char* name);

// randomize menu value by parent (triggers)
extern void menuRandomize(MenuSelection var);

// add parent and make sub menu of child options (optional callback to sub-append more)
extern void appendSubMenu(MenuSelection var, Menu *menu, void (*extra)(Menu *menu) = NULL);

//totally code controlled dispatch (triggers)
extern void matic(MenuSelection var, MenuSelection forceApply = MAX_MENU);
#define hauto(name, set) matic(MENU(name), MENU(set))

////////////////////
// Plugin Watch API
////////////////////

#ifdef WATCHER
// call to use
extern void addPluginFileWatcher();

// MAKE SOME MODULE PROVIDE THIS
extern void callbackWatcher(const std::string& filename);
#endif
