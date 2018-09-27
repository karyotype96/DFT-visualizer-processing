//now here's the meat and potatoes of the whole thing.
//the DFT is used to decompose a waveform into its
//individual frequencies, and it does that by transforming
//the waveform from a function of time into a function of
//frequency.
//note that there's both a real and imaginary component. both
//components contain all the frequencies found.
float[][] fourier_transform(float[] signal){
  float[][] transformed = new float[1000][2];
  
  for (int k = 0; k < transformed.length; k++){
    transformed[k][REAL] = 0;
    transformed[k][IMAG] = 0;
    for (int n = 0; n < signal.length; n++){
      transformed[k][REAL] += signal[n] * cos(TWO_PI * k * n / signal.length);
      transformed[k][IMAG] += -signal[n] * sin(TWO_PI * k * n / signal.length);
    }
  }
  return transformed;
}

//this function computes the inverse of the above, by
//transforming it from a function of frequency to a
//function of time.
float[] inv_fourier_transform(float[][] frequencies, int size){
  float[] retransformed = new float[size];
  for (int n = 0; n < retransformed.length; n++){
    retransformed[n] = 0;
    for (int k = 0; k < frequencies.length; k++){
      retransformed[n] += frequencies[k][REAL] * cos(TWO_PI * k * n / retransformed.length) - frequencies[k][IMAG] * sin(TWO_PI * k * n / retransformed.length);
    }
    retransformed[n] /= retransformed.length;
  }
  return retransformed;
}

//auxiliary waveforms
float C_component(float x){
  return sin(C_freq * TWO_PI * x);
}

float G_component(float x){
  return sin(G_freq * TWO_PI * x);
}

float hC_component(float x){
  return sin(hC_freq * TWO_PI * x);
}

float u_component(float x){
  return sin(u_freq * TWO_PI * x);
}

//waveform without unwanted part
float wanted_function(float x){
  return C_component(x) + G_component(x) + hC_component(x);
}

//waveform with unwanted part
float unwanted_function(float x){
  return C_component(x) + G_component(x) + hC_component(x) + u_component(x);
}

//note: these convert points on the drawn graph to what their actual values
//should be.
float to_graph_x(float x){
  return x / graph_xinterval;
}

float to_graph_y(float y){
  return y / graph_yinterval;
}

float to_default_x(float x){
  return x * graph_xinterval;
}

float to_default_y(float y){
  return y * graph_yinterval;
}
