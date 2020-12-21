import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import TimeseriesGenerator
from tensorflow.keras.models import Sequential, load_model
from tensorflow.keras.layers import LSTM, Dense, Flatten
from tensorflow.keras.regularizers import l2
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import ModelCheckpoint
from sklearn.preprocessing import LabelEncoder


path = 'DataSet/'

#return the list of files in dataset (array format)
csv_files = os.listdir(path)
# print(csv_files)

#print only the csv files
# for dir_path, dir_names, filenames in os.walk(path):
#     for name in filenames:
#         if ".csv" in name:
#             print(name)

#read csv files by using pandas (first csv file, row 1 used as col names)
# mem = pd.read_csv(path+csv_files[0], header=1)
# #print the first five lines of data
# print(mem.head())

# #first 100 rows of data (Walking)
# plt.subplot(2,2,1)
# plt.plot(np.arange(0, 100), mem.Ax[mem['Unnamed: 69']=="walking"][:100], label="X-axis")
# plt.plot(np.arange(0, 100), mem.Ay[mem['Unnamed: 69']=="walking"][:100], label="Y-axis")
# plt.plot(np.arange(0, 100), mem.Az[mem['Unnamed: 69']=="walking"][:100], label="Z-axis")
# #legend: describe the elements in the graph
# plt.legend()
# plt.title("Walking")


# #first 100 rows of data (Jogging)
# plt.subplot(2,2,2)
# plt.plot(np.arange(0, 100), mem.Ax[mem['Unnamed: 69']=="jogging"][:100], label="X-axis")
# plt.plot(np.arange(0, 100), mem.Ay[mem['Unnamed: 69']=="jogging"][:100], label="Y-axis")
# plt.plot(np.arange(0, 100), mem.Az[mem['Unnamed: 69']=="jogging"][:100], label="Z-axis")
# #legend: describe the elements in the graph
# plt.legend()
# plt.title("Jogging")


# #first 100 rows of data (Standing)
# plt.subplot(2,2,3)
# plt.plot(np.arange(0, 100), mem.Ax[mem['Unnamed: 69']=="standing"][:100], label="X-axis")
# plt.plot(np.arange(0, 100), mem.Ay[mem['Unnamed: 69']=="standing"][:100], label="Y-axis")
# plt.plot(np.arange(0, 100), mem.Az[mem['Unnamed: 69']=="standing"][:100], label="Z-axis")
# #legend: describe the elements in the graph
# plt.legend()
# plt.title("Standing")


# #first 100 rows of data (Biking)
# plt.subplot(2,2,4)
# plt.plot(np.arange(0, 100), mem.Ax[mem['Unnamed: 69']=="biking"][:100], label="X-axis")
# plt.plot(np.arange(0, 100), mem.Ay[mem['Unnamed: 69']=="biking"][:100], label="Y-axis")
# plt.plot(np.arange(0, 100), mem.Az[mem['Unnamed: 69']=="biking"][:100], label="Z-axis")
# #legend: describe the elements in the graph
# plt.legend()
# plt.title("Biking")
# plt.show()

#concatenate all csv files into one dataframe
mem = pd.DataFrame()
for dir_path, dir_names, filenames in os.walk(path):
    for name in filenames:
        if ".csv" in name:
            temp = pd.read_csv(path+name, header=1)
            mem = pd.concat([mem, temp], sort=False)

#extract the corresponding data from dataframe
leftPock = mem.iloc[:, np.r_[1:7, 54]]
rightPock = mem.iloc[:, np.r_[12:18, 54]]
wrist = mem.iloc[:, np.r_[23:29, 54]]
upperArm = mem.iloc[:, np.r_[34:40, 54]]
belt = mem.iloc[:, np.r_[45:51, 54]]
# labels = mem[mem.columns[54]]
# labels.columns = ['Activity']

#same column names with leftPock
belt.columns = upperArm.columns = wrist.columns = rightPock.columns = leftPock.columns

#concatenate splitted data into one dataframe again
train_data = pd.concat([leftPock, rightPock, wrist, upperArm, belt], sort=False)

#split: x = Accelerometer and Gyroscope data, y = Activity type
trainX = train_data[train_data.columns[:6]]
trainY = train_data[train_data.columns[6:7]]

#encode labels stored in trainY
encoder = LabelEncoder()
trainY = encoder.fit_transform(trainY)
trainY[:10]

#80% of data used for training, 20% testing
def data_split(x, y, train_size = 0.8):
    s = int(train_size * len(x))
    trainX = x[:s]
    testX = x[s:]
    trainY = y[:s]
    testY = y[s:]
    return trainX, testX, trainY, testY

trainX, testX, trainY, testY = data_split(trainX, trainY)

#convert data into time series seq
features = 9
window_size = 100

train = TimeseriesGenerator(trainX.to_numpy(), trainY, length=window_size, batch_size=1024)
test = TimeseriesGenerator(testX.to_numpy(), testY, length=window_size, batch_size=1024)

model = Sequential()
model.add(LSTM(32, return_sequences=True, input_shape=(window_size, features),
    kernel_regularizer=l2(0.000001), bias_regularizer=l2(0.000001), name='lstm_1'))

model.add(Flatten(name='flatten'))
model.add(Dense(64, activation='relu', kernel_regularizer=l2(0.000001), bias_regularizer=l2(0.000001), name='dense_1'))
model.add(Dense(len(np.unique(trainY)), activation='softmax', kernel_regularizer=l2(0.000001), bias_regularizer=l2(0.000001), name='output'))

model.compile(loss='sparse_categorial_crossentropy', optimizer=Adam(), metrics=['accuracy'])

callB = [ModelCheckpoint('model.h5', save_best_only = True, save_weights_only=False, verbose=1)]

#training
# train = np.asarray(train)
# test = np.asarray(test)
history = model.fit_generator(train, epochs=5, validation_data=test, callbacks=callB)