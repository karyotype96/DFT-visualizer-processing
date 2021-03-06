import de.looksgood.ani.*;
import processing.sound.*;

//states of the animation
final int PRE_ANIM       = 0; //before the animation starts
final int DRAW_GRAPH     = 1; //draw the full grid
final int DRAW_WANTED    = 2; //draw the wanted function
final int PLAY_WANTED    = 3; //play the generated sound
final int STOP_WANTED    = 4; //stop playing it
final int DRAW_COMPS     = 5; //erase wanted function and draw components
final int PLAY_C         = 6; 
final int PLAY_G         = 7;
final int PLAY_HC        = 8;
final int STOP_COMPS     = 9; //stop all component sounds
final int DRAW_UNWANTED  = 10; //draw unwanted graph
final int PLAY_UNWANTED  = 11; //play it
final int STOP_UNWANTED  = 12; //stop playing it because it's annoying
final int DRAW_WRAPPED   = 13; //draw the function wrapped around the origin
final int DRAW_K_AMOUNTS = 14; //visualize quantities
final int DRAW_FOURIER   = 15; //show the fourier transform
final int REMOVE_FREQ    = 16; //show the wanted fourier transform
final int INV_FOURIER    = 17; //show the results of the inverse
final int REDRAW_WANTED  = 18;
final int PLAY_WANTED_2  = 19;
final int STOP_WANTED_2  = 20;

int current_state;

//information about the drawn graph
float graph_top, graph_bottom;
float graph_left, graph_right;
float graph_xinterval, graph_yinterval;
float graph_mult;

int spectrum = 1000;

int components_left, components_right;
int wanted_left, wanted_right;
int unwanted_left, unwanted_right;
float k;

float[] C_signal, G_signal, hC_signal, u_signal, wanted_signal, unwanted_signal, fourier_untransformed;
float[][] fourier_transformed_w, fourier_transformed_u, fourier_transformed_uw;
float[][] untransformed;

int untransformed_left, untransformed_right;
float freq_mult = 0;
float unwanted_freqs_mult;
int transformed_left, transformed_right;
float wrapped_mult;

void draw_graph(){
  stroke(255);
  strokeWeight(1);
  if (graph_mult != 0){
    for (float i = graph_left; i <= graph_right; i += graph_xinterval){
      line(i, graph_top, i, graph_top + (graph_bottom - graph_top) * graph_mult);
    }
  
    for (float i = graph_top; i <= graph_bottom; i += graph_yinterval){
      line(graph_left, i, graph_left + (graph_right - graph_left) * graph_mult, i);
    }
  
    stroke(0, 0, 255);
    strokeWeight(3);
    line(graph_left, 0, graph_left + (graph_right - graph_left) * graph_mult, 0);
  }
}

void draw_functions(){
  strokeWeight(3);
  stroke(255);
  for (int i = untransformed_left+1; i < untransformed_right; i++){
    line(i-1, to_default_y(fourier_untransformed[i-1]), i, to_default_y(fourier_untransformed[i]));
  }
  
  stroke(255, 0, 0);
  for (int i = wanted_left+1; i < wanted_right; i++){
    line(i-1, to_default_y(wanted_signal[i-1]), i, to_default_y(wanted_signal[i]));
  }
  
  for (int i = unwanted_left+1; i < unwanted_right; i++){
    line(i-1, to_default_y(unwanted_signal[i-1]), i, to_default_y(unwanted_signal[i]));
  }
  
  stroke(255, 127, 0);
  for (int i = components_left+1; i < components_right; i++){
    line(i-1, to_default_y(C_signal[i-1]) + graph_yinterval * 2, i, to_default_y(C_signal[i]) + graph_yinterval * 2);
  }

  stroke(255, 255, 0);
  for (int i = components_left+1; i < components_right; i++){
    line(i-1, to_default_y(G_signal[i-1]), i, to_default_y(G_signal[i]));
  }
  
  stroke(0, 255, 255);
  for (int i = components_left+1; i < components_right; i++){
    line(i-1, to_default_y(hC_signal[i-1]) - graph_yinterval * 2, i, to_default_y(hC_signal[i]) - graph_yinterval * 2);
  }
}

void draw_wrappedgraph(float[] numbers, float k){
  pushMatrix();
  float interval = 100;
  float x1, y1;
  float x2, y2;
  translate(width/2, height/2);
  
  stroke(127);
  if (wrapped_mult != 0){
    for (int i = 0; i < width/2; i += interval){
      line(i, lerp(0, -height/2, wrapped_mult), i, lerp(0, height/2, wrapped_mult));
      line(-i, lerp(0, -height/2, wrapped_mult), -i, lerp(0, height/2, wrapped_mult));
    }
    for (int i = 0; i < height/2; i += interval){
      line(lerp(0, width/2, wrapped_mult), i, lerp(0, -width/2, wrapped_mult), i);
      line(lerp(0, width/2, wrapped_mult), -i, lerp(0, -width/2, wrapped_mult), -i);
    }
    
    stroke(0, 0, 255);
    line(0, lerp(0, -height/2, wrapped_mult), 0, lerp(0, height/2, wrapped_mult));
    line(lerp(0, width/2, wrapped_mult), 0, lerp(0, -width/2, wrapped_mult), 0);
  }
  stroke(255, 0, 0);
  for (int i = 0; i < lerp(0, numbers.length, wrapped_mult)-1; i++){
    x1 = numbers[i] * cos(TWO_PI * k * (i) / numbers.length) * interval;
    y1 = numbers[i] * -sin(TWO_PI * k * (i) / numbers.length) * interval;
    x2 = numbers[i+1] * cos(TWO_PI * k * (i+1) / numbers.length) * interval;
    y2 = numbers[i+1] * -sin(TWO_PI * k * (i+1) / numbers.length) * interval;
    line(x1, y1, x2, y2);
  }
  
  popMatrix();
}

void draw_freqs(float[][] frequencies){
  float interval = 10;
  float h;
  
  stroke(255, 0, 0);
  strokeWeight(1);
  pushMatrix();
  translate(0, height/5);
  if (freq_mult != 0){
    for (int i = 0; i < spectrum; i++){
      h = ((frequencies[i][REAL] / 2) + 1) * freq_mult;
      if (i >= 96 && i <= 110) h = lerp(1, h, unwanted_freqs_mult);
      rect(i * interval, 0, interval, h);
    }
    translate(0, -height/2.5);
    for (int i = 0; i < spectrum; i++){
      h = ((frequencies[i][IMAG] / 2) + 1) * freq_mult;
      if (i >= 96 && i <= 110) h = lerp(1, h, unwanted_freqs_mult);
      rect(i * interval, 0, interval, h);
    }
  }
  popMatrix();
}

void setup(){
  fullScreen();
  C_signal =        new float[width];
  G_signal =        new float[width];
  hC_signal =       new float[width];
  u_signal =        new float[width];
  wanted_signal =   new float[width];
  unwanted_signal = new float[width];
  
  current_state = PRE_ANIM;
  graph_yinterval = height / 8;
  graph_xinterval = width * 10;
  graph_top = -graph_yinterval * 4;
  graph_bottom = graph_yinterval * 4;
  graph_left = 0;
  graph_right = width;
  graph_mult = 0;
  unwanted_freqs_mult = 1;
  k = 1;
  
  components_left = 0;
  components_right = 0;
  wanted_left = 0;
  wanted_right = 0;
  unwanted_left = 0;
  unwanted_right = 0;
  untransformed_left = 0;
  untransformed_right = 0;
  wrapped_mult = 0;
  transformed_left = 0;
  transformed_right = spectrum;
  
  for (int i = 0; i < width; i++){
    C_signal[i] = C_component(to_graph_x(i));
    G_signal[i] = G_component(to_graph_x(i));
    hC_signal[i] = hC_component(to_graph_x(i));
    u_signal[i] = u_component(to_graph_x(i));
    wanted_signal[i] = wanted_function(to_graph_x(i));
    unwanted_signal[i] = unwanted_function(to_graph_x(i));
  }
  fourier_transformed_w = fourier_transform(wanted_signal);
  fourier_transformed_u = fourier_transform(unwanted_signal);
  
  fourier_transformed_uw = new float[spectrum][2];
  for (int i = 0; i < fourier_transformed_uw.length; i++){
    fourier_transformed_uw[i][REAL] = fourier_transformed_u[i][REAL];
    fourier_transformed_uw[i][IMAG] = fourier_transformed_u[i][IMAG];
  }
  
  for (int i = 96; i < 111; i++){
    fourier_transformed_uw[i][REAL] = 2;
    fourier_transformed_uw[i][IMAG] = 2;
  }
  
  fourier_untransformed = inv_fourier_transform(fourier_transformed_uw, width);
  
  C_osc = new SinOsc(this);
  C_osc.freq(C_freq);
  
  G_osc = new SinOsc(this);
  G_osc.freq(G_freq);
  
  hC_osc = new SinOsc(this);
  hC_osc.freq(hC_freq);
  
  u_osc = new SinOsc(this);
  u_osc.freq(u_freq);
  u_osc.amp(0.25);
  
  Ani.init(this);
}

void draw(){
  background(0);
  pushMatrix();
  translate(0, height/2);
  scale(1, -1);
  draw_graph();
  draw_freqs(fourier_transformed_u);
  draw_functions();
  popMatrix();
  draw_wrappedgraph(unwanted_signal, k);
  
}

void mousePressed(){
  switch (current_state){
    case PRE_ANIM:
      Ani.to(this, 1.5, "graph_mult", 1);
      current_state++;
      break;
    case DRAW_GRAPH:
      Ani.to(this, 1.5, "wanted_right", width, Ani.LINEAR);
      current_state++;
      break;
    case DRAW_WANTED:
      C_osc.play();
      G_osc.play();
      hC_osc.play();
      current_state++;
      break;
    case PLAY_WANTED:
      C_osc.stop();
      G_osc.stop();
      hC_osc.stop();
      current_state++;
      break;
    case STOP_WANTED:
      Ani.to(this, 0.5, "wanted_left", width, Ani.LINEAR);
      Ani.to(this, 0.5, "components_right", width, Ani.LINEAR);
      current_state++;
      break;
    case DRAW_COMPS:
      C_osc.play();
      current_state++;
      break;
    case PLAY_C:
      C_osc.stop();
      G_osc.play();
      current_state++;
      break;
    case PLAY_G:
      G_osc.stop();
      hC_osc.play();
      current_state++;
      break;
    case PLAY_HC:
      hC_osc.stop();
      current_state++;
      break;
    case STOP_COMPS:
      Ani.to(this, 0.5, "components_left", width, Ani.LINEAR);
      Ani.to(this, 0.5, "unwanted_right", width, Ani.LINEAR);
      current_state++;
      break;
    case DRAW_UNWANTED:
      C_osc.play();
      G_osc.play();
      hC_osc.play();
      u_osc.play();
      current_state++;
      break;
    case PLAY_UNWANTED:
      C_osc.stop();
      G_osc.stop();
      hC_osc.stop();
      u_osc.stop();
      current_state++;
      break;
    case STOP_UNWANTED:
      Ani.to(this, 1.5, "graph_mult", 0, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "unwanted_left", width, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "wrapped_mult", 1, Ani.QUAD_IN_OUT);
      current_state++;
      break;
    case DRAW_WRAPPED:
      Ani freq2 = new Ani(this, 1.5, 3, "k", 5, Ani.QUAD_IN_OUT);
      Ani freq3 = new Ani(this, 1.5, 6, "k", 10, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "k", 3, Ani.QUAD_IN_OUT);
      freq2.start();
      freq3.start();
      current_state++;
      break;
    case DRAW_K_AMOUNTS:
      Ani n = new Ani(this, 1.5, 1.5, "freq_mult", 1, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "wrapped_mult", 0, Ani.QUAD_IN_OUT);
      n.start();
      current_state++;
      break;
    case DRAW_FOURIER:
      Ani.to(this, 1.5, "unwanted_freqs_mult", 0, Ani.QUAD_IN_OUT);
      current_state++;
      break;
    case REMOVE_FREQ:
      Ani.to(this, 1.5, "untransformed_right", width, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "freq_mult", 0, Ani.QUAD_IN_OUT);
      Ani.to(this, 1.5, "graph_mult", 1, Ani.QUAD_IN_OUT);
      current_state++;
      break;
    case INV_FOURIER:
      wanted_left = 0;
      wanted_right = 0;
      Ani.to(this, 1.5, "wanted_right", width, Ani.LINEAR);
      current_state++;
      break;
    case REDRAW_WANTED:
      C_osc.play();
      G_osc.play();
      hC_osc.play();
      current_state++;
      break;
    case PLAY_WANTED_2:
      C_osc.stop();
      G_osc.stop();
      hC_osc.stop();
      current_state++;
      break;
    case STOP_WANTED_2:
      exit();
  }
}
