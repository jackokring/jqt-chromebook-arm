#include "plugin.hpp"

///////////////////////////////////////////////////////////////
// Eventual backporting to KRTPluginA and hence MIT licence
///////////////////////////////////////////////////////////////

Plugin* pluginInstance;

void init(Plugin* p) {
	pluginInstance = p;
	// redefine so that correct include happens
#undef MODEL	
#define MODEL(name) p->addModel(name)
#include "modules.hpp"
}

#define M_PI_F float(M_PI)
#define M_PI_POW_2 M_PI * M_PI
#define M_PI_POW_3 M_PI_POW_2 * M_PI
#define M_PI_POW_5 M_PI_POW_3 * M_PI_POW_2
#define M_PI_POW_7 M_PI_POW_5 * M_PI_POW_2
#define M_PI_POW_9 M_PI_POW_7 * M_PI_POW_2
#define M_PI_POW_11 M_PI_POW_9 * M_PI_POW_2

float tanpif(float f) {
    // These coefficients don't need to be tweaked for the audio range.
    // Include f multiplication by PI for 0->1 frequency normal %fs
    const float a = 3.333314036e-01 * M_PI_POW_3;
    const float b = 1.333923995e-01 * M_PI_POW_5;
    const float c = 5.33740603e-02 * M_PI_POW_7;
    const float d = 2.900525e-03 * M_PI_POW_9;
    const float e = 9.5168091e-03 * M_PI_POW_11;
    float f2 = f * f;
    return f * (M_PI_F + f2 * (a + f2 * (b + f2 * (c + f2 * (d + f2 * e)))));
}

int maxPoly(Module *m, const int numIn, const int numOut) {
	int poly = 1;
	for(int i = 0; i < numIn; i++) {
		int chan = m->inputs[i].getChannels();
		if(chan > poly) poly = chan;
	}
	// perhaps an optimization on #pragma GCC ivdep is possible
	// knowing the ranged 1 .. 16
	if(poly > PORT_MAX_CHANNELS) poly = PORT_MAX_CHANNELS;
	for(int o = 0; o < numOut; o++) {
		m->outputs[o].setChannels(poly);
	}
	return poly;
}

// leave filters or close coupling of copies

// placement macro (local)
#define locl(x,y) mm2px(Vec(((hp*HP_UNIT) / 2.f / lanes)*(1+2*(x-1)), (HEIGHT*Y_MARGIN)+(R_HEIGHT / 2.f / rungs)*(1+2*(y-1))))

// control populator
void populate(ModuleWidget *m, int hp, int lanes, int rungs, const int ctl[],
							const char *lbl[], const int kind[], char* named) {
	LabelWidget *display;

	m->addChild(createWidget<KScrewSilver>(Vec(RACK_GRID_WIDTH, 0)));
	m->addChild(createWidget<KScrewSilver>(Vec(m->box.size.x - 2 * RACK_GRID_WIDTH, 0)));
	m->addChild(createWidget<KScrewSilver>(Vec(RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));
	m->addChild(createWidget<KScrewSilver>(Vec(m->box.size.x - 2 * RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));
	
	// Textual Name Display
	display = new LabelWidget(named,GR_LED);
	display->fixCentre(locl(lanes / 2 + 0.5f, 0.5f), strlen(named));//chars
	m->addChild(display);

	for(int x = 1; x <= lanes; x++) {
		for(int y = 1; y <= rungs; y++) {
			// automatic layout
			const int idx = (x - 1) + lanes * (y - 1);
			if(ctl[idx] == -1) continue;
			display = new LabelWidget(lbl[idx], kind[idx]);
			display->fixCentre(locl(x, y + 0.5f), strlen(lbl[idx]));//chars
			m->addChild(display);
			switch(kind[idx]) {
				case SNAP_KNOB:
					// snap knob
					m->addParam(createParamCentered<KRoundBlackSnapKnob>(locl(x, y), m->module, ctl[idx]));
					break;
				case INPUT_PORT:
					m->addInput(createInputCentered<KPJ301MPort>(locl(x, y), m->module, ctl[idx]));
					break;
				case NORM_KNOB: default:
					m->addParam(createParamCentered<KRoundBlackKnob>(locl(x, y), m->module, ctl[idx]));
					break;
				case OUTPUT_PORT:
					m->addOutput(createOutputCentered<KPJ301MPort>(locl(x, y), m->module, ctl[idx]));
					break;
				case GR_LED:
					// light
					m->addChild(createLightCentered<KGRLightWidget>(locl(x, y), m->module, ctl[idx]));
					break;
			}
		}
	}
}

// atomic parallel list primitives
template<typename kind>
void plist<kind>::insertOne(plist<kind>* what) {
	while(!containedAfter(what)) {
		plist<kind>* here = this.next.load();
		what->next.store(here);
		this.next.store(what);
	}
}

template<typename kind>
plist<kind>* plist<kind>::removeAfter(plist<kind>* what) {
	plist<kind>* here = NULL;
	while(containedAfter(what)) {
		here = &this;
		plist<kind>* last = NULL;
		while(last = here, here = here->next.load()) {
			if(here == what) {
				last->next.store(here->next.load());
				break;
			}
		}
	}
	if(here) here->next.store(NULL);// maybe null to remove
	return here;
}

template<typename kind>
bool plist<kind>::containedAfter(plist<kind>* what) {
	plist<kind>* here = &this;
	while(here = here->next.load()) {
		if(here == what) return true; 
	}
	return false;
}

template<typename kind>
plist<kind>* plist<kind>::supply(kind* what) {
	plist<kind>* here = new plist<kind>;
	here->next.store(NULL);
	here->item.store(what); 
	return here;
}

template<typename kind>
kind* plist<kind>::resolve(plist<kind>* what) {
	kind* here = what->item.load();
	delete what;
	return here;
}

//pipe streams
enum PIPE_FD {
	READ_FD = 0,
	WRITE_FD = 1,
	MAX_FD = 2
};
int parentToChild[MAX_FD];
int childToParent[MAX_FD];

// simple file descriptor macros for fread/fwrite etc.
#define EXEC_W parentToChild[WRITE_FD]
#define EXEC_R childToParent[READ_FD]

// process fork
pid_t FORK(char* fn, char** args) {
	pid_t pid = fork();
    if (pid == -1) {
        WARN("fork failed");
    } else if (pid == 0) {
		INFO("child opening");
		// do fn(), maybe parse args
		// hook in streams, combine stderr to stdout
		pipe(parentToChild);
		pipe(childToParent);
		dup2(parentToChild[READ_FD], STDIN_FILENO);
		dup2(childToParent[WRITE_FD], STDOUT_FILENO);
		dup2(childToParent[WRITE_FD], STDERR_FILENO);
		// fd duplication, so close down handle count
		close(parentToChild[READ_FD]);
		close(childToParent[WRITE_FD]);
		execvp(fn, args);
		WARN("child exited with error");
		_exit(EXIT_SUCCESS);
    } else {
        //int status;
        //(void)waitpid(pid, &status, 0);
    }
    return pid;
}

#include <sys/wait.h>
// process join
void JOIN(pid_t pid) {
	close(EXEC_W);// close stream input
	char x;
	while(read(EXEC_R, &x, 1));// EOF?
	close(EXEC_R);
	waitpid(pid, NULL, 0);
}

int FORK_R(char *buff, int count) {
	return read(EXEC_R, buff, count);
}

int FORK_W(char *buff, int count) {
	return write(EXEC_W, buff, count);
}

// modes add one enum MenuSelection to plugin.hpp
// add names and which &MenuSelection
std::atomic<MenuSelection> modeScript[MAX_MENU];//good enough

// fill MenuSelectiion *modeMenu[]
#define MENU_SET(sel) (&modeScript[sel])

#undef ENTRY
#define ENTRY(name, parent) (char*) #name
char *modeNames[MAX_MENU] = {
#include "menus.txt"
};

#undef ENTRY
#define ENTRY(name, parent) MENU_SET(MENU_ ## parent)
std::atomic<MenuSelection> *modeMenu[MAX_MENU] = {
#include "menus.txt"
};
#undef ENTRY
//safe to use
#define ENTRY(name, parent) MENU_ ## name

std::atomic<bool> modeTriggers[MAX_MENU];

void resetMenu(MenuSelection var) {//resets group
	if(MENU_SET(var) == MENU_SEL(var)) {//bool self reference (not parent group)
		if(*MENU_SET(var) != MAX_MENU) {
			*MENU_SET(var) = MAX_MENU;//false
		}
		return;//pop
	}
	for (int i = 0; i < MAX_MENU; i++) {
		if(MENU_SET(var) != MENU_SEL(i)) continue;
		*MENU_SET(var) = (MenuSelection)i;
		break;// bool resets as true
		// ACTUALLY: when extending states a .json load will reset new MAX_MENU (false)
		// as olderer MAX_MENU might have been taken by extra menus.
	}
}

void refreshMenus() {
	for (int i = 0; i < MAX_MENU; i++) {
		if(MENU_BOOL(i)) modeTriggers[i] = true;
	}
}

void primeMenus() {
	for (int i = 0; i < MAX_MENU; i++) {
		resetMenu((MenuSelection)i);
	}
	// then activate
	refreshMenus();
}

// A re-trigger undo/redo action
struct MenuAction : history::Action {

	MenuSelection var;
	MenuSelection old;
	MenuSelection lastest;

	MenuAction(MenuSelection var, MenuSelection old, MenuSelection lastest) {
		this.var = var;
		this.old = old;
		this.latest = latest;
	}

	void undo() override {
		matic(var, old);
	}

	void redo() override {
		matic(var, latest);
	}
};

void appendMenu(MenuSelection var, Menu *menu) {

	struct ModeItem : MenuItem {
		std::atomic<MenuSelection> *var;
		MenuSelection mode;
		void onAction(const event::Action& e) override {
			if(*var != mode) {
				MenuSelection old = *var;
				*var = mode;
				modeTriggers[mode] = true;
				APP->history->push(new MenuAction(var, old, mode));
			}
		}
	};

	struct BoolItem : MenuItem {
		std::atomic<MenuSelection> *var;
		MenuSelection mode;
		void onAction(const event::Action& e) override {
			MenuSelection old = *var;
			*var = MENU_BOOL(*var) ? MAX_MENU : mode;//bool flip
			modeTriggers[mode] = true;
			APP->history->push(new MenuAction(var, old, mode));
		}
	};

	// special to have a bool tick by MENU_SET(self) in modeMenu[self]
	if(MENU_SET(var) == MENU_SEL(var)) {//bool self reference (not parent group)
		BoolItem* boolItem = createMenuItem<BoolItem>(modeNames[var]);
		boolItem->var = MENU_SET(var);
		boolItem->mode = var;
		boolItem->rightText = CHECKMARK(MENU_BOOL(var));
		menu->addChild(boolItem);
		return; //pop
	}

	for (int i = 0; i < MAX_MENU; i++) {
		if(MENU_SET(var) != MENU_SEL(i)) continue;
		ModeItem* modeItem = createMenuItem<ModeItem>(modeNames[i]);
		modeItem->var = MENU_SET(var);
		modeItem->mode = (MenuSelection)i;
		modeItem->rightText = CHECKMARK(*MENU_SET(var) == (MenuSelection)i);
		menu->addChild(modeItem);
	}
}

void appendMenuLabel(MenuSelection var, Menu *menu) {
	menu->addChild(createMenuLabel(modeNames[var]));
}

void appendMenuSpacer(Menu *menu) {
	menu->addChild(new MenuSeparator);
}

void findOrResetMenu(MenuSelection var) {
	bool found = false;
	if(MENU_SET(var) == MENU_SEL(var)) {//bool self reference (not parent group)
		if(*MENU_SET(var) == var || *MENU_SET(var) == MAX_MENU) {
			found = true;
		}
	} else {
		for (int i = 0; i < MAX_MENU; i++) {
			if(MENU_SET(var) != MENU_SEL(i)) continue;
			if(*MENU_SET(var) == (MenuSelection)i) {
				found = true;
				break;
			}
		}
	}
	if(!found) {
		WARN("menu configuration error");
		resetMenu(var);//reset
	}
}

void menuToJson(json_t* rootJ, MenuSelection var) {
	char *named = modeNames[var];
	json_object_set_new(rootJ, named, json_integer(*MENU_SET(var)));
}

void menuFromJson(json_t* rootJ, MenuSelection var) {
	char *named = modeNames[var];
	json_t* modeJ = json_object_get(rootJ, named);
	if (modeJ) {
		MenuSelection i = (MenuSelection)json_integer_value(modeJ);
		if(*MENU_SET(var) != i) {
			*MENU_SET(var) = (MenuSelection)i;
			findOrResetMenu(var);
			// bad input from file?
		}
	} else resetMenu(var);
}

void menuToJson(json_t* rootJ, char* name) {
	json_t* menu = json_object();
	for (int i = 0; i < MAX_MENU; i++) {
		menuToJson(menu, (MenuSelection)i);
	}
	json_object_set_new(rootJ, name, menu);
}

void menuFromJson(json_t* rootJ, char* name) {
	json_t* menu = json_object_get(rootJ, name);
	if (menu) {
		for (int i = 0; i < MAX_MENU; i++) {
			menuFromJson(menu, (MenuSelection)i);
		}
	}
	// handles re-triggers
	refreshMenus();
}

// remembers undo
void menuRandomize(MenuSelection var) {
	if(MENU_SET(var) == MENU_SEL(var)) {//bool self reference (not parent group)
		MenuSelection i = random::u32() & 1 ? MAX_MENU : var;
		if(*MENU_SET(var) != i) {
			MenuSelection old = var;
			*MENU_SET(var) = i;
			modeTriggers[i] = true;
			APP->history->push(new MenuAction(var, old, i));
		}
		return;
	}
	int count = 0;
	for (int i = 0; i < MAX_MENU; i++) {
		if(MENU_SET(var) != MENU_SEL(i)) continue;
		count++;
	}
	if(count > 0) {
		int mode = random::u32() % count;
		for (int i = 0; i < MAX_MENU; i++) {
			if(MENU_SET(var) != MENU_SEL(i)) continue;
			if(mode-- == 0) {
				if(*MENU_SET(var) != i) {
					MenuSelection old = var;
					*MENU_SET(var) = (MenuSelection)i;
					modeTriggers[i] = true;
					APP->history->push(new MenuAction(var, old, (MenuSelection)i));
				}
				break;
			}
		}
	}
}

void appendSubMenu(MenuSelection var, Menu *menu, void (*extra)(Menu *menu)) {
	struct NestItem : MenuItem {
		MenuSelection lvar;
		void (*lextra)(Menu *menu);
		Menu *createChildMenu() override {
			Menu *subMenu = new Menu;
			appendMenu(lvar, subMenu);
			if(lextra) lextra(subMenu);
			return subMenu;
		}
	};

	NestItem *ni = createMenuItem<NestItem>(modeNames[var], RIGHT_ARROW);
	ni->lvar = var;
	ni->lextra = extra;
	menu->addChild(ni);
}

void matic(MenuSelection var, MenuSelection forceApply) {
	// set false default for bool as tick implies running?
	if(MENU_SET(var) == MENU_SEL(var)) {//bool self reference (not parent group)
		if(forceApply != MAX_MENU || forceApply != var) {
			WARN("bad application of bool automatic menu");
			return;
		}
		*MENU_SET(var) = MENU_BOOL(var) ? MAX_MENU : var;//bool flip
	} else {
		if(MENU_SET(var) != MENU_SEL(forceApply)) {
			WARN("bad application of multi-option automatic menu");
			return;
		}
		*MENU_SET(var) = forceApply;
	}
	//always if even same
	modeTriggers[forceApply] = true;
}

#ifdef WATCHER
#include "../efsw/include/efsw/efsw.hpp"
// Inherits from the abstract listener class, and implements the the file action handler
class UpdateListener : public efsw::FileWatchListener {
  public:
    void handleFileAction( efsw::WatchID watchid, const std::string& dir,
                           const std::string& filename, efsw::Action action,
                           std::string oldFilename ) override {
        callbackWatcher(filename);
        switch ( action ) {
            case efsw::Actions::Add:
                
                break;
            case efsw::Actions::Delete:
                
                break;
            case efsw::Actions::Modified:
                
                break;
            case efsw::Actions::Moved:
                
                break;
            default:
                break;
        }
    }
};

void addPluginFileWatcher() {
	// Create the file system watcher instance
	// efsw::FileWatcher allow a first boolean parameter that indicates if it should start with the
	// generic file watcher instead of the platform specific backend
	efsw::FileWatcher* fileWatcher = new efsw::FileWatcher();

	// Create the instance of your efsw::FileWatcherListener implementation
	UpdateListener* listener = new UpdateListener();

	// Add a folder to watch, and get the efsw::WatchID
	// It will watch the /tmp folder recursively ( the third parameter indicates that is recursive )
	// Reporting the files and directories changes to the instance of the listener
	/* efsw::WatchID */ fileWatcher->addWatch(asset::plugin(pluginInstance, ""), listener, true);

	// Start watching asynchronously the directories
	fileWatcher->watch();
}

#endif
