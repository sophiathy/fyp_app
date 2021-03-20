package com.fyp_55293157.exercise_tracker;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;

////////////////sensors////////////////
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.util.Log;

import org.tensorflow.lite.Interpreter;
import java.io.*;
import java.nio.MappedByteBuffer;
import android.content.res.AssetFileDescriptor;
import java.nio.channels.FileChannel;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Timer;

public class MainActivity extends FlutterActivity implements SensorEventListener{
    private static final String CHANNEL = "flutter.native/classifier";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);
            new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    // Note: this method is invoked on the main thread.
                    if (call.method.equals("classify"))
                        result.success(classifyActivity());
                    else
                        result.notImplemented();
                }
            );
    }

//////////////////////////////////////////////////////////////////////////////////////
    private static final int TIME_STAMP = 100;
    private static final String TAG = "MainActivity";

    // private static List<Float> ax, ay, az;
    // private static List<Float> gx, gy, gz;
    // private static List<Float> lx, ly, lz;
    // private static List<List<Float>> current;

    private float[][] currentData;
    private int count;             //a timestamp counter

    private SensorManager mSensorManager;
    private Sensor mAccelerometer, mGyroscope;
    //, mLinearAcceleration;

    // private float[] results;
    private String result;
    private Interpreter tflite;
    private static final String MODEL_FILE_PATH = "finalModel.tflite";
    private final int sensorsInputs = 6;
    private final int outputTypes = 4;  //TODO: change back to 5

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // results = new float[7];
        result = "Tracking...";
        currentData = new float[TIME_STAMP][sensorsInputs];
        count = 0;

        // current = new ArrayList<List<Float>>();
        // ax = new ArrayList<>(); ay = new ArrayList<>(); az = new ArrayList<>();
        // gx = new ArrayList<>(); gy = new ArrayList<>(); gz = new ArrayList<>();
        // lx = new ArrayList<>(); ly = new ArrayList<>(); lz = new ArrayList<>();

        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mGyroscope = mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);

        // mLinearAcceleration = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);

        mSensorManager.registerListener(this,mAccelerometer, SensorManager.SENSOR_DELAY_FASTEST);
        mSensorManager.registerListener(this,mGyroscope, SensorManager.SENSOR_DELAY_FASTEST);
        // mSensorManager.registerListener(this,mLinearAcceleration, SensorManager.SENSOR_DELAY_FASTEST);

        try{
            tflite = new Interpreter(loadModelFile());
        }catch(Exception e){
            Log.i(TAG, "Cannot get the file: " + e);
        }
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        Sensor sensor = event.sensor;
        // List<Float> tmp = new ArrayList<>();
        float[] sensors = new float[sensorsInputs];

        // if (sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
        //     ax.add(event.values[0]);
        //     ay.add(event.values[1]);
        //     az.add(event.values[2]);
        // }else if(sensor.getType() == Sensor.TYPE_GYROSCOPE) {
        //     gx.add(event.values[0]);
        //     gy.add(event.values[1]);
        //     gz.add(event.values[2]);
        // }

        if (sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            // tmp.add(event.values[0]);
            // tmp.add(event.values[1]);
            // tmp.add(event.values[2]);
            sensors[0] = event.values[0];
            sensors[1] = event.values[1];
            sensors[2] = event.values[2];
        }

        if(sensor.getType() == Sensor.TYPE_GYROSCOPE) {
            // tmp.add(event.values[0]);
            // tmp.add(event.values[1]);
            // tmp.add(event.values[2]);
            sensors[3] = event.values[0];
            sensors[4] = event.values[1];
            sensors[5] = event.values[2];
        }
        // } else {
        //     lx.add(event.values[0]);
        //     ly.add(event.values[1]);
        //     lz.add(event.values[2]);
        // }

        // current.add(tmp);

        //add to currentData if the time step counter is less than TIME_STAMP
        if(count < TIME_STAMP){
            for(int i = 0; i < sensorsInputs; i++)
                currentData[count][i] = sensors[i];

            count++;
        }
        // tmp.clear();
    }

    //convert the probabilities float list to string list
    private List<String> toStringList(float[][] prob){
        List<String> res = new ArrayList<String>();

        for(int i = 0; i < outputTypes; i++)
            res.add(Float.toString(roundFloat(prob[0][i], 3)));

        return res;
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy){}

    private MappedByteBuffer loadModelFile() throws Exception {
        AssetFileDescriptor fileDescriptor = this.getAssets().openFd(MODEL_FILE_PATH);
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    }

    private String classifyActivity() {
        // List<List<List<Float>>> data = new ArrayList<List<List<Float>>>();
        float[][][] sensorsData = new float[1][TIME_STAMP][sensorsInputs];
        float[][] probabilities = new float[1][outputTypes];

        // if (ax.size() >= TIME_STAMP && ay.size() >= TIME_STAMP && az.size() >= TIME_STAMP
        // && gx.size() >= TIME_STAMP && gy.size() >= TIME_STAMP && gz.size() >= TIME_STAMP){
        // && lx.size() >= TIME_STAMP && ly.size() >= TIME_STAMP && lz.size() >= TIME_STAMP){
        if(currentData.length >= TIME_STAMP){
            // data.add(current.subList(0, TIME_STAMP));

            //move currentData to sensorsData (fits the format of input)
            for(int i = 0; i < TIME_STAMP; i++){
                for(int j = 0; j < sensorsInputs; j++){
                    sensorsData[0][i][j] = currentData[i][j];
                }
            }
            // data.addAll(ax.subList(0,TIME_STAMP));
            // data.addAll(ay.subList(0,TIME_STAMP));
            // data.addAll(az.subList(0,TIME_STAMP));

            // data.addAll(gx.subList(0,TIME_STAMP));
            // data.addAll(gy.subList(0,TIME_STAMP));
            // data.addAll(gz.subList(0,TIME_STAMP));

            // data.addAll(lx.subList(0,TIME_STAMP));
            // data.addAll(ly.subList(0,TIME_STAMP));
            // data.addAll(lz.subList(0,TIME_STAMP));

            // Log.i(TAG, "data: " + Float.toString(data.get(0).get(0).get(0)));    //error: all are size 0
            // Log.i(TAG, "data: " + Arrays.toString(sensorsData));

            // tflite.run(toFloatArray(data), probabilities);

            //run the tflite model
            tflite.run(sensorsData, probabilities);

            // Log.i(TAG, "predictActivity: "+ Arrays.toString(probabilities));
            Log.i(TAG, "Probabilities: "+ toStringList(probabilities));

            int highestProbability = 0;     //default is 0

            //find the activity with the highest probability
            for(int i = 0; i < outputTypes; i++){
                if(probabilities[0][i] > probabilities[0][highestProbability])
                    highestProbability = i;
            }

            // if(highestProbability == 0)
            //     result = "Running";
            if(highestProbability == 0)
                result = "Standing";
            else if(highestProbability == 1)
                result = "Walking";
            else if(highestProbability == 2)
                result = "Walking Upstairs";
            else if(highestProbability == 3)
                result = "Walking Downstairs";

            Log.i(TAG, "Current Activity: "+ result);

            //reset the timestamp counter and the array
            count = 0;
            currentData = new float[TIME_STAMP][sensorsInputs];
            // data.clear();
            // current.clear();
            // ax.clear(); ay.clear(); az.clear();
            // gx.clear(); gy.clear(); gz.clear();
            // lx.clear(); ly.clear(); lz.clear();
        }
        return result;
    }

    //round the float value to n decimal places
    private float roundFloat(float val, int dp) {
        BigDecimal bigDec = new BigDecimal(Float.toString(val));
        bigDec = bigDec.setScale(dp, RoundingMode.HALF_UP);
        return bigDec.floatValue();
    }

    // private float[][][] toFloatArray(List<List<List<Float>>> data) {
    //     float[][][] arr  = new float[1][100][6];

    //     for(int i = 0; i < data.get(0).size(); i++) {
    //         for(int j = 0; j < data.get(0).get(i).size(); j++) {
    //             arr[0][i][j] = data.get(0).get(i).get(j);
    //         }
    //     }

    //     return arr;
    // }

    @Override
    protected void onResume() {
        super.onResume();
        mSensorManager.registerListener(this,mAccelerometer, SensorManager.SENSOR_DELAY_FASTEST);
        mSensorManager.registerListener(this,mGyroscope, SensorManager.SENSOR_DELAY_FASTEST);
        // mSensorManager.registerListener(this,mLinearAcceleration, SensorManager.SENSOR_DELAY_FASTEST);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mSensorManager.unregisterListener(this);
    }
}


////////////////activity recognition API////////////////
// import androidx.annotation.Nullable;
// import android.content.BroadcastReceiver;
// import android.app.PendingIntent;
// import android.content.Context;
// import android.content.Intent;
// import android.content.IntentFilter;
// import android.os.Bundle;

// import android.Manifest;
// import android.content.pm.PackageManager;
// import android.view.View;
// import androidx.core.app.ActivityCompat;

// import com.google.android.gms.location.ActivityRecognition;
// import com.google.android.gms.location.ActivityTransition;
// import com.google.android.gms.location.ActivityTransitionEvent;
// import com.google.android.gms.location.ActivityTransitionRequest;
// import com.google.android.gms.location.ActivityTransitionResult;
// import com.google.android.gms.location.DetectedActivity;
// import com.google.android.gms.tasks.OnFailureListener;
// import com.google.android.gms.tasks.OnSuccessListener;
// import com.google.android.gms.tasks.Task;

// import android.util.Log;
// import java.util.List;
// import java.util.ArrayList;
// import android.text.TextUtils;
// import java.text.SimpleDateFormat;
// import java.util.Date;
// import java.util.Locale;

// public class MainActivity extends FlutterActivity{
//     private static final String CHANNEL = "flutter.native/classifier";

//     //check whether the device is Android 10 (29+) or above
//     private boolean runningQ_above = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q;
//     private final String TRANSITIONS_RECEIVER = "transitions_receiver";
//     private static final String TAG = "MainActivity";

//     private boolean tracking = false;
//     private List<ActivityTransition> activityRecog;
//     private List<String> detectedActivity;

//     private PendingIntent mTransitionsPendingIntent;
//     private TransitionsReceiver mTransitionsReceiver;

//     @Override
//     public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
//         super.configureFlutterEngine(flutterEngine);
//         new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//             .setMethodCallHandler((call, result) -> {
//                 // Note: this method is invoked on the main thread.
//                 if (call.method.equals("getResults"))
//                     result.success(getResults());
//                 else
//                     result.notImplemented();
//             }
//         );
//     }

//     //Initialize elements
//     @Override
//     protected void onCreate(Bundle savedInstanceState) {
//         super.onCreate(savedInstanceState);
//         activityRecog = new ArrayList<>();
//         detectedActivity = new ArrayList<>();

//         //add activity type for tracking
//         //STILL
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.STILL)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_ENTER)
//             .build());
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.STILL)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_EXIT)
//             .build());

//         //WALKING
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.WALKING)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_ENTER)
//             .build());
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.WALKING)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_EXIT)
//             .build());

//         //RUNNING
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.RUNNING)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_ENTER)
//             .build());
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.RUNNING)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_EXIT)
//             .build());

//         //ON_BICYCLE
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.ON_BICYCLE)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_ENTER)
//             .build());
//         activityRecog.add(new ActivityTransition.Builder()
//             .setActivityType(DetectedActivity.ON_BICYCLE)
//             .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_EXIT)
//             .build());

//         Intent intent = new Intent(TRANSITIONS_RECEIVER);
//         mTransitionsPendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, intent, 0);

//         //create a BroadcastReceiver that listens to PendingIntent
//         mTransitionsReceiver = new TransitionsReceiver();
//     }

//     //register a listener
//     @Override
//     protected void onStart(){
//         super.onStart();
//         registerReceiver(mTransitionsReceiver, new IntentFilter(TRANSITIONS_RECEIVER));
//     }

//     //pause the listener if the user left the app
//     @Override
//     protected void onPause() {
//         if(tracking)
//             disableTracking();

//         super.onPause();
//     }

//     //unregister listener if the user close the app
//     @Override
//     protected void onStop() {
//         unregisterReceiver(mTransitionsReceiver);
//         super.onStop();
//     }

//     private static String activity_toString(int act) {
//         switch(act){
//             case DetectedActivity.STILL:
//                 return "STILL";
//             case DetectedActivity.WALKING:
//                 return "WALKING";
//             case DetectedActivity.RUNNING:
//                 return "RUNNING";
//             case DetectedActivity.ON_BICYCLE:
//                 return "BIKING";
//             default:
//                 return "UNKNOWN";
//         }
//     }

//     private static String transition_toString(int transType) {
//         switch(transType){
//             case ActivityTransition.ACTIVITY_TRANSITION_ENTER:
//                 return "ENTER";
//             case ActivityTransition.ACTIVITY_TRANSITION_EXIT:
//                 return "EXIT";
//             default:
//                 return "UNKNOWN";
//         }
//     }

//     private List<String> getResults(){
//         return detectedActivity;
//     }

//     @Override
//     protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
//         //start activity recognition if the permission was approved
//         if (activityRecogPermissionApproved() && !tracking)
//             enableTracking();

//         super.onActivityResult(requestCode, resultCode, data);
//     }

//     //request and update
//     private void enableTracking() {
//         //create request and listen for activity changes
//         ActivityTransitionRequest request = new ActivityTransitionRequest(activityRecog);

//         //register for Transitions Updates
//         Task<Void> task = ActivityRecognition.getClient(this).requestActivityTransitionUpdates(request, mTransitionsPendingIntent);

//         task.addOnSuccessListener(
//             new OnSuccessListener<Void>() {
//                 @Override
//                 public void onSuccess(Void result) {
//                     tracking = true;
//                     Log.i(TAG, "Transitions Api was successfully registered.");

//                 }
//             });

//         task.addOnFailureListener(
//             new OnFailureListener() {
//                 @Override
//                 public void onFailure(@NonNull Exception e) {
//                     Log.i(TAG, "Transitions Api could NOT be registered: " + e);

//                 }
//             });
//     }

//     //remove the listener when the user closes the app
//     private void disableTracking() {
//         //stop listening for activity changes
//         ActivityRecognition.getClient(this).removeActivityTransitionUpdates(mTransitionsPendingIntent)
//             .addOnSuccessListener(new OnSuccessListener<Void>() {
//                 @Override
//                 public void onSuccess(Void result) {
//                     tracking = false;
//                     Log.i(TAG, "Transitions successfully unregistered.");
//                 }
//             })
//             .addOnFailureListener(new OnFailureListener() {
//                 @Override
//                 public void onFailure(@NonNull Exception e) {
//                     Log.i(TAG, "Transitions could not be unregistered: " + e);
//                 }
//             });
//     }

//     private boolean activityRecogPermissionApproved() {
//         if(runningQ_above)
//             return PackageManager.PERMISSION_GRANTED == ActivityCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION);
//         else
//             return true;
//     }

//     public void onClickEnableOrDisableActivityRecognition(View view) {
//         //enable or disable activity tracking and ask for permissions if needed
//         if (activityRecogPermissionApproved()) {
//             if(tracking)
//                 disableTracking();
//             else
//                 enableTracking();
//         } else {
//             //request permission and start activity recognition tracking
//             Intent startIntent = new Intent(this, PermissionRationalActivity.class);
//             startActivityForResult(startIntent, 0);
//         }
//     }

//     public class TransitionsReceiver extends BroadcastReceiver{
//         @Override
//         public void onReceive(Context context, Intent intent) {
//             if (!TextUtils.equals(TRANSITIONS_RECEIVER, intent.getAction())) {
//                 Log.i(TAG, "Received an unsupported action in TransitionsReceiver: action = " + intent.getAction());
//                 return;
//             }

//             //extract activity transition information from listener
//             if (ActivityTransitionResult.hasResult(intent)) {
//                 ActivityTransitionResult result = ActivityTransitionResult.extractResult(intent);

//                 for (ActivityTransitionEvent event : result.getTransitionEvents()) {
//                     String info = "Activity: " + activity_toString(event.getActivityType()) +
//                             " (" + transition_toString(event.getTransitionType()) + ")" + "   " +
//                             new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());

//                     Log.i(TAG, info);

//                     if(detectedActivity.isEmpty()){
//                         detectedActivity.add(0, activity_toString(event.getActivityType()));
//                         detectedActivity.add(1, transition_toString(event.getTransitionType()));
//                         detectedActivity.add(2, new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date()));
//                     }else{
//                         detectedActivity.set(0, activity_toString(event.getActivityType()));
//                         detectedActivity.set(1, transition_toString(event.getTransitionType()));
//                         detectedActivity.set(2, new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date()));
//                     }
//                 }
//             }
//         }
//     }
// }
