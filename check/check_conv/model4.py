import tensorflow as tf
import matplotlib.pyplot as plt
from tensorflow.keras.models import load_model # type: ignore
from tensorflow.keras.models import Model # type: ignore
from tensorflow.keras.layers import Input, Conv2D, DepthwiseConv2D, BatchNormalization, ReLU, GlobalAveragePooling2D, Dense # type: ignore
import os
import random 
import cv2
import numpy as np
from sklearn.model_selection import train_test_split
import pickle

#----------------------------------------------------------------------------------
def int2Hex(value, bits):
    if value < 0:
        value = (1 << bits) + value  # Compute two's complement
    binary = format(value, f'0{bits}b')
    hex_digits = format(int(binary, 2), '03X')
    return hex_digits
#----------------------------------------------------------------------------------

# Define dataset path
DATASET_PATH = "./obj"
IMG_SIZE = (64, 64)  # Adjust for FPGA efficiency

# Read images and labels
imagesN = []
labelsN = []
try:
    images = np.load('images64.npy')
    labels = np.load('labels64.npy')
except: 
    for file in os.listdir(DATASET_PATH):
        if file.endswith(".jpg"):  # Process image files
            img_path = os.path.join(DATASET_PATH, file)
            label_path = os.path.join(DATASET_PATH, file.replace(".jpg", ".txt"))
            # Read and preprocess image
            img = cv2.imread(img_path)
            img = cv2.resize(img, IMG_SIZE)  # Resize for MobileNetV2
            img = img / 255.0  # Normalize
            print(label_path)
            # Read label from text file
            if os.path.exists(label_path):
                with open(label_path, "r") as f:
                    label = f.read().strip()
                    print(label)
                    print(label[0])
                    labelsN.append(0 if label[0] == "1" else 1)
                    imagesN.append(img)
            print("Tong so DataSet: " + str(len(labelsN)))
# Convert to NumPy arrays
    images = np.array(imagesN)
    labels = np.array(labelsN)
    np.save('labels64.npy', labels)
    np.save('images64.npy', images)

# Split into train/test sets
X_train, X_test, y_train, y_test = train_test_split(images, labels, test_size=0.2, random_state=42)
print("Kich thuoc tap train: ",end="")
print(X_train.shape)
# Define a simple lightweight model
inputs = Input(shape=(64, 64,3))
# Initial Conv Layer
x = Conv2D(16, kernel_size=3, strides=1, padding='same', use_bias=False)(inputs)
x = ReLU()(x)
# Depthwise Convolution Block 1
x = DepthwiseConv2D(kernel_size=3, strides=1, padding='same', use_bias=False)(x)
x = ReLU()(x)
# Depthwise Convolution Block 2
x = DepthwiseConv2D(kernel_size=3, strides=1, padding='same', use_bias=False)(x)
x = ReLU()(x)
# Depthwise Convolution Block 3
x = DepthwiseConv2D(kernel_size=3, strides=1, padding='same', use_bias=False)(x)
x = ReLU()(x)
# Global Average Pooling and Output
x = GlobalAveragePooling2D()(x)
outputs = Dense(1, activation='sigmoid')(x)  # Binary output: Traffic Jam (1) or Not (0)
# Build model
model = Model(inputs, outputs)
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

model.summary()
model.load_weights("traffic_jam_weights_4.weights.h5")
#history = model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=25, batch_size=64)

#for plot trainning ===========================================

# Vẽ Loss
#plt.figure(figsize=(10, 5))
#plt.subplot(1, 2, 1)
#plt.plot(history.history['loss'], label='Train Loss')
#plt.plot(history.history['val_loss'], label='Validation Loss')
#plt.xlabel('Epochs')
#plt.ylabel('Loss')
#plt.title('Loss Function Over Epochs')
#plt.legend()
#
# Vẽ Accuracy
#plt.subplot(1, 2, 2)
#plt.plot(history.history['accuracy'], label='Train Accuracy')
#plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
#plt.xlabel('Epochs')
#plt.ylabel('Accuracy')
#plt.title('Accuracy Over Epochs')
#plt.legend()
#
#plt.tight_layout()
#plt.show()
#==================Print weight================================
print("=================================================================")
conv_layer = model.layers[1]  #first layer
weights = conv_layer.get_weights()[0]  # shape: (3, 3, 3, 16) get weight
listWeight = []
weightFilter = []
weightChenal = []
for f in range(16):  # 16 filters
    print(f"Filter {f}:")
    weightFilter = []
    for c in range(3):  # 3 input channels (RGB)
        weightChenal = []
        print(weights[:, :, c, f])
        kernel = np.round(weights[:, :, c, f]*512)  # shape (3, 3) #2^9
        print(f"  Channel {c} kernel:")
        print(kernel)
        print(int2Hex(int(kernel[0][0]), 10))
        weightChenal.append(int2Hex(int(kernel[0][0]), 10))
        print(int2Hex(int(kernel[0][1]), 10))
        weightChenal.append(int2Hex(int(kernel[0][1]), 10))
        print(int2Hex(int(kernel[0][2]), 10))
        weightChenal.append(int2Hex(int(kernel[0][2]), 10))
        print(int2Hex(int(kernel[1][0]), 10))
        weightChenal.append(int2Hex(int(kernel[1][0]), 10))
        print(int2Hex(int(kernel[1][1]), 10))
        weightChenal.append(int2Hex(int(kernel[1][1]), 10))
        print(int2Hex(int(kernel[1][2]), 10))
        weightChenal.append(int2Hex(int(kernel[1][2]), 10))
        print(int2Hex(int(kernel[2][0]), 10))
        weightChenal.append(int2Hex(int(kernel[2][0]), 10))
        print(int2Hex(int(kernel[2][1]), 10))
        weightChenal.append(int2Hex(int(kernel[2][1]), 10))
        print(int2Hex(int(kernel[2][2]), 10))
        weightChenal.append(int2Hex(int(kernel[2][2]), 10))
        weightFilter.append(weightChenal)
    listWeight.append(weightFilter)
print("output weight")
print(listWeight)
print(listWeight[0])
print(listWeight[0][0])
for filter in range(16):
    for chanel in range(3):
        name = "weight"+str(filter)+"_"+str(chanel)+".hex"
        with open(name, "w") as f:
            for value in range(9):
                print("filter = {}", filter)
                print("chnel = {}", chanel)
                print("value = {}", value)
                f.write(listWeight[filter][chanel][value] + '\n')
            print("complete write weight for filter: " + str(filter) + " ,chanel: "+str(chanel))

print("=================================================================")
#==============================================================

def predict_image(image_path):
    try:
        img = cv2.imread(image_path)
        img = cv2.resize(img, (64, 64))
        img = img / 255.0
        img = np.expand_dims(img, axis=0)

        prediction = model.predict(img)
        print("value" + str(prediction[0]))
        print("Low Traffic" if prediction[0] <= 0.5 else "High Traffic")
        return 1 if prediction[0] >= 0.5 else 0, prediction[0]
    except:
        print("cannot open file")
        return -1
    


#model.save_weights("traffic_jam_weights_4.weights.h5")

'''
pathTest = "./testDataSet/"
run = 1
fig, axes = plt.subplots(2, 5, figsize=(5, 5))  # 1 row, 2 columns
axes = axes.flatten()
i = 0
for file in os.listdir('./testMain'):
    if file.endswith(".jpg"):  # Process image files
        img_path = os.path.join('./testMain', file)
        label_path = os.path.join('./testMain', file.replace(".jpg", ".txt"))
        # Read and preprocess image
        img = cv2.imread(img_path)
        imgSh = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        axes[i].imshow(imgSh)
        img = cv2.resize(img, IMG_SIZE)  # Resize for MobileNetV2
        img = img / 255.0  # Normalize
        # Read label from text file
        result, value = predict_image(img_path)
        realLable = 0
        with open(label_path, 'r') as f:
            realLables = f.read().strip()
            if(realLables == '1'):
                realLable = 1
            else:
                realLable = 0
        title = "real lable: " + "traffic high\n" if realLable == '1' else "traffic low\n" + " prediction: traffic high\n" if result == 1 else " prediction: traffic low\n" + "value= " +str(value)
        axes[i].set_title(title, fontsize=10)  # Set title below each image
        axes[i].axis("off")  # Hide axis labels
        i += 1
        if i == 10:
            plt.tight_layout()
            plt.show()
            i = 0
            fig, axes = plt.subplots(2, 5, figsize=(5, 5))  # 1 row, 2 columns
            axes = axes.flatten()
plt.tight_layout()
plt.show()
'''    