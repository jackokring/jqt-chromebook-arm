#include "plugin.hpp"

// Width by parameter knobs (placing automatic) maximum of 8 lanes (rungs pack nicely at 7)
#define NAME Blank
#define LANES 2
//indirect macro evaluations
#define STR_FROM(x) #x
#define GLUE_HELPER(x, y) x##y
#define GLUE(x, y) GLUE_HELPER(x, y)
#define SHOW_NAME(name) STR_FROM(name)
// used in the modules.hpp file
#define ASSIGN_NAME(name) GLUE(model, name)

// By default. Might need change if you get a link error duplicate symbol
//#define IS_WATCHER

struct MODULE_NAME : Module {

	enum ParamIds {
	
		NUM_PARAMS
	};

	// names in constructor

	enum InputIds {
	
		NUM_INPUTS
	};

	const char *instring[NUM_INPUTS] = {

	};

	enum OutputIds {

		NUM_OUTPUTS
	};

	const char *outstring[NUM_OUTPUTS] = {

	};

	enum LightIds {
	
		NUM_LIGHTS
	};

	const char *lightstring[NUM_LIGHTS] = {

	};

	void iol() {
		for(int i = 0; i < NUM_INPUTS; i++) configInput(i, instring[i]);
		for(int i = 0; i < NUM_OUTPUTS; i++) configOutput(i, outstring[i]);
		if(NUM_LIGHTS) return;
		for(int i = 0; i < NUM_LIGHTS; i++) configLight(i, lightstring[i]);
	}

	MODULE_NAME() {
		config(NUM_PARAMS, NUM_INPUTS, NUM_OUTPUTS, NUM_LIGHTS);

		//configParam(P_PLFO, -10.f, 10.f, 0.f, "LFO -> Py");

		iol();
	}

	void process(const ProcessArgs& args) override {
		int maxPort = maxPoly(this, NUM_INPUTS, NUM_OUTPUTS);

		// PARAMETERS (AND IMPLICIT INS)
#pragma GCC ivdep
		for(int p = 0; p < maxPort; p++) {

		}
	}
};

//geometry edit
//for best auto layout (MAX 8 lanes) prime HP
#define HP (laneIdxHP[LANES])
#define RUNGS 7

// FROM plugin.hpp
//enum controlKind {
//	SNAP_KNOB = -2,
//	INPUT_PORT = -1,
//	MORM_KNOB = 0,
//	OUTPUT_PORT = 1,
//	GR_LED =2
//};

struct WIDGET_NAME : ModuleWidget {
	
	WIDGET_NAME(MODULE_NAME* module) {
		setModule(module);
		setPanel(APP->window->loadSvg(asset::plugin(pluginInstance, "res/" + std::to_string(HP) + ".svg")));

		//using MODULE_NAME::*;

		const int ctl[] = {
			// param index grid lanes minor index
			// use macros CTL(enum_value) or NO_CTL
			
		};

		const char *lbl[] = {
			// labels

		};

		const int kind[] = {
			// control kind
			// use enum controlKind values
			
		};

		populate(this, HP, LANES, RUNGS, ctl, lbl, kind, (char*)SHOW_NAME(NAME));
	}
};

#ifdef WATCHER
#ifdef IS_WATCHER
// MAKE SOME MODULE PROVIDE THIS
void callbackWatcher(const char* filename) {
	INFO(filename);
}
#endif
#endif

Model* ASSIGN_NAME(NAME) = createModel<MODULE_NAME, WIDGET_NAME>(SHOW_NAME(NAME));
