package com.fyp_55293157.exercise_tracker;

import android.content.Context;
import org.tensorflow.contrib.android.TensorFlowInferenceInterface;

public class PhyActClassifier{
    private static final String MODEL_FILE_PATH = "model.pb";
    private static final String INPUT_NODE = "lstm_1_input";
    private static final String[] OUTPUT_NODES = {"output/Softmax"};
    private static final String OUTPUT_NODE = "output/Softmax";
    private static final long[] INPUT_SIZE = {1, 100, 9};
    private static final int OUTPUT_SIZE = 7;

    private TensorFlowInferenceInterface inferenceInterface;

    //load the tensorflow library
    static{
        System.loadLibrary("tensorflow_inference");
    }

    //load model
    public PhyActClassifier(Context context){
        inferenceInterface = new TensorFlowInferenceInterface(context.getAssets(), MODEL_FILE_PATH);
    }

    //return probabilites of 7 activities
    public float[] predictProbabilities(float[] data){
        float[] result = new float[OUTPUT_SIZE];
        inferenceInterface.feed(INPUT_NODE, data, INPUT_SIZE);
        inferenceInterface.run(OUTPUT_NODES);
        inferenceInterface.fetch(OUTPUT_NODE, result);
        return result;
    }

}