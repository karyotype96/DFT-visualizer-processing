import de.looksgood.ani.*;
import processing.sound.*;

//some useful constants
final int REAL = 0;
final int IMAG = 1;

// frequency stuff
final int C_freq  = 262;
final int G_freq  = 392;
final int hC_freq = 523;
final int u_freq  = 6006;

//oscillators that match with the frequencies
SinOsc C_osc, G_osc, hC_osc, u_osc;

//states of the animation

int current_state;

//information about the drawn graph
float graph_top, graph_bottom;
float graph_left, graph_right;
float graph_xinterval, graph_yinterval;
float graph_mult;

float components_left, components_right;
float wanted_left, wanted_right;
float unwanted_left, unwanted_right;

float[] C_signal, G_signal, hC_signal, u_signal, wanted_signal, unwanted_signal;

void draw_graph(){
  
}

void draw_functions(){
  
}

void setup(){
  size(1000, 800);
}

void draw(){
  background(0);
}
