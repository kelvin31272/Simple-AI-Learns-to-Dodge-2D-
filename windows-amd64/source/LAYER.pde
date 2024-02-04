class Layer {
  int nin, nout;
  float[][] weights;
  float[] biases;
  float[] inputs;   //raw inputs from the last layer's nodes
  float[] activations; //the output of each node after being sent through the activation function


  public Layer(int nin, int nout) {
    this.nin = nin;
    this.nout = nout;
    this.weights = new float[nin][nout];
    this.biases = new float[nout];
    this.activations = new float[nout];
    this.inputs = new float[nin];
    this.GenerateWeightsBiases();
  }

  //This code ensures that when we create the networks, their brains are all random
  void GenerateWeightsBiases() {
    for (int inout = 0; inout < nout; inout++) {
      this.biases[inout] = random(-1, 1);
      for (int inin = 0; inin < nin; inin++) {
        this.weights[inin][inout] = random(-1, 1);
      }
    }
  }

  //This code calculates the output of this layer based on a set of inputs
  public float[] calculateOutputs(float[] inputs) {
    for (int inout = 0; inout < nout; inout++) {
      float weightedInput = biases[inout];
      for (int inin = 0; inin < nin; inin++) {
        this.inputs[inin] = inputs[inin];
        weightedInput += inputs[inin] * weights[inin][inout];
      }
      activations[inout] = ActivationFunction(weightedInput);
    }
    return activations;
  }
  
  //squash the output between -1 and 1
  float ActivationFunction(float weightedInput) {
    return (float)Math.tanh(weightedInput);
  }

  
  void MutateWeightsBiases(float mutationRate) {
    for (int inout = 0; inout < nout; inout++) {
      for (int inin = 0; inin < nin; inin++) {
        weights[inin][inout] += random(-mutationRate, mutationRate);
      }
      biases[inout] += random(-mutationRate, mutationRate);
    }
  }
}
