
class Network {
  Layer[] layers;
  int[] layerSizes;

  float loss;

  public Network(int[] layerSizes) {
    this.layers = new Layer[layerSizes.length-1];
    for (int i = 0; i < this.layers.length; i++) {
      this.layers[i] = new Layer(layerSizes[i], layerSizes[i+1]);
    }
    this.layerSizes = layerSizes;
    this.loss = 1000;
  }

  float[] CalculateOutputs(float[] inputsNormalised) {
    for (Layer layer : layers) {
      inputsNormalised = layer.calculateOutputs(inputsNormalised);
    }
    return inputsNormalised;
  }

  float[] Predict(float[] inputsNormalised) {
    return CalculateOutputs(inputsNormalised);
  }

  void MutateAllWeightsBiases(float mutationRate) {
    for (Layer l : layers) {
      l.MutateWeightsBiases(mutationRate);
    }
  }
}
