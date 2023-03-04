#include "plugin.hpp"

// Width by parameter knobs (placing automatic)
#define LANES 2
#define SHOW_NAME "Blank"
// used in the modules.hpp file
#define ASSIGN_NAME modelBlank

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
//for best auto layout
#define HP ((int)(LANES*2.f))
#define RUNGS 7

struct WIDGET_NAME : ModuleWidget {
	
	WIDGET_NAME(MODULE_NAME* module) {
		setModule(module);
		setPanel(APP->window->loadSvg(asset::plugin(pluginInstance, "res/" + std::to_string(HP) + ".svg")));

		//using MODULE_NAME::*;

		const int ctl[] = {
			// param index
			// -1 is no control and no label
			
		};

		const char *lbl[] = {
			// labels

		};

		const int kind[] = {
			// control kind
			// -1 = sink, +1 = source
			
		};

		populate(this, HP, LANES, RUNGS, ctl, lbl, kind);
	}
};

Model* ASSIGN_NAME = createModel<MODULE_NAME, WIDGET_NAME>(SHOW_NAME);
