#include "plugin.hpp"

Plugin* pluginInstance;

void init(Plugin* p) {
	pluginInstance = p;

	// Add modules here
	// p->addModel(modelMyModule);

	// Any other plugin initialization may go here.
	// As an alternative, consider lazy-loading assets and lookup tables when your module is created to reduce startup times of Rack.
	p->addModel(modelO);
	p->addModel(modelM);
	p->addModel(modelI);
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
							const char *lbl[], const int kind[]) {
	LabelWidget *display;

	m->addChild(createWidget<KScrewSilver>(Vec(RACK_GRID_WIDTH, 0)));
	m->addChild(createWidget<KScrewSilver>(Vec(m->box.size.x - 2 * RACK_GRID_WIDTH, 0)));
	m->addChild(createWidget<KScrewSilver>(Vec(RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));
	m->addChild(createWidget<KScrewSilver>(Vec(m->box.size.x - 2 * RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));

	for(int x = 1; x <= lanes; x++) {
		for(int y = 1; y <= rungs; y++) {
			// automatic layout
			const int idx = (x - 1) + lanes * (y - 1);
			if(ctl[idx] == -1) continue;
			display = new LabelWidget(lbl[idx], kind[idx]);
			display->fixCentre(locl(x, y + 0.5f), strlen(lbl[idx]));//chars
			m->addChild(display);
			switch(kind[idx]) {
				case -2:
					// snap knob
					m->addParam(createParamCentered<KRoundBlackSnapKnob>(locl(x, y), m->module, ctl[idx]));
					break;
				case -1:
					m->addInput(createInputCentered<KPJ301MPort>(locl(x, y), m->module, ctl[idx]));
					break;
				case 0: default:
					m->addParam(createParamCentered<KRoundBlackKnob>(locl(x, y), m->module, ctl[idx]));
					break;
				case 1:
					m->addOutput(createOutputCentered<KPJ301MPort>(locl(x, y), m->module, ctl[idx]));
					break;
				case 2:
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

// modes add one external MenuSelection to .hpp
// extend enum of MenuSelection
// add names and which &MenuSelection
MenuSelection modeScript;
char *modeNames[MAX_MENU] = {

};
MenuSelection *modeMenu[MAX_MENU] = {

};

void resetMenu(MenuSelection *var) {
	for (int i = 0; i < MAX_MENU; i++) {
		if(var != modeMenu[i]) continue;
		*var = (MenuSelection)i;
	}
}

void appendMenu(MenuSelection *var, Menu *menu, char* name) {
	menu->addChild(new MenuEntry);
	menu->addChild(createMenuLabel(name));

	struct ModeItem : MenuItem {
		MenuSelection *var;
		MenuSelection mode;
		void onAction(const event::Action& e) override {
			*var = mode;
		}
	};

	for (int i = 0; i < MAX_MENU; i++) {
		if(var != modeMenu[i]) continue;
		ModeItem* modeItem = createMenuItem<ModeItem>(modeNames[i]);
		modeItem->var = var;
		modeItem->mode = (MenuSelection)i;
		modeItem->rightText = CHECKMARK(*var == (MenuSelection)i);
		menu->addChild(modeItem);
	}
}