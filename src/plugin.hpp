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

#define MODEL(name) extern Model * model ## name
#include "modules.hpp"
#undef MODEL

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

enum controlKind {
	SNAP_KNOB = -2,
	INPUT_PORT = -1,
	NORM_KNOB = 0,
	OUTPUT_PORT = 1,
	GR_LED = 2
};

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
		// scheme to chop blue on dark modes
		// keeps things normalized and highlights feedback
		// and the "LOGO"
		switch(kind) {
			case INPUT_PORT:
				textColor = SCHEME_GREEN;
				break;
			case NORM_KNOB: case SNAP_KNOB:
				textColor = SCHEME_YELLOW;
				break;
			case OUTPUT_PORT:
				textColor = SCHEME_RED;
				break;
			case GR_LED: default:
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
// drain until found prompt
extern bool FORK_DRAIN(const char *prompt);

////////////////////
// Menu Additions
////////////////////
// add MenuSelection enum values and then do in plugin.cpp
#define ENTRY(name, parent) MENU_ ## name

enum MenuSelection {
#include "menus.txt"
	MAX_MENU
};

extern const char *modeNames[MAX_MENU];

struct OnMenu {

	// triggers
	std::atomic<bool> modeTriggers[MAX_MENU];
	
	// menu state
	std::atomic<MenuSelection> modeScript[MAX_MENU];//good enough
	
	// place for linking 
#undef ENTRY
#define ENTRY(name, parent) &modeScript[MENU_ ## parent]
	std::atomic<MenuSelection> *modeMenu[MAX_MENU] = {
#include "menus.txt"
	};
#undef ENTRY

// PRIVATE MACROS

// POINTER TO SELECTED STATE
#define MENU_SEL(sel) (modeMenu[sel])

// fill MenuSelectiion *modeMenu[]
#define MENU_SET(sel) (&modeScript[sel])

// THE MAIN MENU STATE BOOLEAN TEST FOR ACTIVE
#define MENU_BOOL(sel) (*MENU_SEL(sel) == sel)

// set up to play naming macros
#define ENTRY(name, parent) MENU_ ## name

// MASTER MenuSelection PRODUCER OF MANGLED ENUM NAMES
#define MENU(name) ENTRY(name, NULL)

////////////////////
// Menu API
////////////////////

// GUI CONTROL STRUCTURE (FOLLOW BY BLOCK {} OR STATEMENT;)
// check and do perhaps the action when triggered on
#define on(menu, name) if((menu).onMenu(MENU(name)))

// detect false bool trigger (must follow it by an `on` to clear trigger) 
// 'off' before 'on' as `on' else test is when not triggered
#define off(menu, name) if((menu).offMenu(MENU(name)))

// totally RPC automatic like?
#define hauto(menu, name, set) (menu).matic(MENU(name), MENU(set))

	// activate the enable trigger on all menus (triggers)
	void refreshMenus();

	// initialize (reset) and activate all menus  (triggers)
	void primeMenus();

	// append a complete menu by parent
	void appendMenu(MenuSelection var, Menu *menu);

	// add label from this parent
	void appendMenuLabel(MenuSelection var, Menu *menu); 

	// fully abstract the API
	void appendMenuSpacer(Menu *menu);

	// save menus
	void menuToJson(json_t* rootJ, char* name);

	// load menus (triggers)
	void menuFromJson(json_t* rootJ, char* name);

	// randomize menu value by parent (triggers)
	void menuRandomize(MenuSelection var);

	// add parent and make sub menu of child options (optional callback to sub-append more)
	void appendSubMenu(MenuSelection var, Menu *menu, void (*extra)(Menu *menu) = NULL);

	//totally code controlled dispatch (triggers)
	void matic(MenuSelection var, MenuSelection forceApply = MAX_MENU);
	
	//check
	bool isOn(MenuSelection var);//is triggered and on (inc bool) state with reset trigger
	bool isOff(MenuSelection var);//is triggered and bool off state keeping trigger on if was on

	// NO NAMESPCE AUTO INJECT PRIVATE
	private:
	void resetMenu(MenuSelection var);
	void findOrResetMenu(MenuSelection var);
	void menuToJson(json_t* rootJ, MenuSelection var);
	void menuFromJson(json_t* rootJ, MenuSelection var);
	// A re-trigger undo/redo action
	struct MenuAction : history::Action {

		MenuSelection var;
		MenuSelection old;
		MenuSelection latest;
		OnMenu *om;

		MenuAction(OnMenu *om, MenuSelection var, MenuSelection old, MenuSelection latest) {
			this->var = var;
			this->old = old;
			this->latest = latest;
			this->om = om;
			if(&(om->modeScript[var]) == om->modeMenu[var]) {//bool self reference (not parent group)
				if(om->modeScript[var] == var) {
					this->name = "set " + std::string(modeNames[var]);
					return;
				}
				if(om->modeScript[var] == MAX_MENU) {
					this->name = "clear " + std::string(modeNames[var]);
					return;
				}
			}
			this->name = "set " + std::string(modeNames[var]) + " to " + std::string(modeNames[latest]);
		}

		void undo() override {
			om->matic(var, old);
		}

		void redo() override {
			om->matic(var, latest);
		}
	};
//#undef MENU_SEL
//#undef MENU_SET
//#undef MENU_BOOL
};
////////////////////
// Plugin Watch API
////////////////////

#ifdef WATCHER
// MAKE SOME MODULE PROVIDE THIS
extern void callbackWatcher(const char* filename);
#endif

extern bool isWindows();
