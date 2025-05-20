import numpy as np
import cv2

def conv(data, weight):
    data = np.array(data)
    weight = np.array(weight)
    result = 0
    for i in range(9*3):
        result = result + data[i]*weight[i]
    return result
dataOutputToFile = []
def convImg(data):
    data = np.array(data)
    for i in range(64):
        for j in range(64):
            dataSet = []
            dataSet.append(data[i-1][j-1][0] if (i > 0 and j > 0) else 0)
            dataSet.append(data[i-1][j][0] if (i > 0) else 0)
            dataSet.append(data[i-1][j+1][0] if (j < 63) else 0)

            dataSet.append(data[i][j-1][0] if (j > 0) else 0)
            dataSet.append(data[i][j][0])
            dataSet.append(data[i][j+1][0] if (j < 63) else 0)

            dataSet.append(data[i+1][j-1][0] if (i < 63 and j > 0) else 0)
            dataSet.append(data[i+1][j][0] if (i < 63) else 0)
            dataSet.append(data[i+1][j+1][0] if (i < 63 and j < 63) else 0)

            dataSet.append(data[i-1][j-1][1] if (i > 0 and j > 0) else 0)
            dataSet.append(data[i-1][j][1] if (i > 0) else 0)
            dataSet.append(data[i-1][j+1][1] if (j < 63) else 0)

            dataSet.append(data[i][j-1][1] if (j > 0) else 0)
            dataSet.append(data[i][j][1])
            dataSet.append(data[i][j+1][1] if (j < 63) else 0)

            dataSet.append(data[i+1][j-1][1] if (i < 63 and j > 0) else 0)
            dataSet.append(data[i+1][j][1] if (i < 63) else 0)
            dataSet.append(data[i+1][j+1][1] if (i < 63 and j < 63) else 0)

            dataSet.append(data[i-1][j-1][2] if (i > 0 and j > 0) else 0)
            dataSet.append(data[i-1][j][2] if (i > 0) else 0)
            dataSet.append(data[i-1][j+1][2] if (j < 63) else 0)

            dataSet.append(data[i][j-1][2] if (j > 0) else 0)
            dataSet.append(data[i][j][2])
            dataSet.append(data[i][j+1][2] if (j < 63) else 0)

            dataSet.append(data[i+1][j-1][2] if (i < 63 and j > 0) else 0)
            dataSet.append(data[i+1][j][2] if (i < 63) else 0)
            dataSet.append(data[i+1][j+1][2] if (i < 63 and j < 63) else 0)
            dataSet = np.array(dataSet)
            dataSet = dataSet / 255
            weigh = []
            weigh.append(0.65405077)
            weigh.append(0.69987404)
            weigh.append(0.4878358)
            weigh.append(0.6011477)
            weigh.append(0.60555035)
            weigh.append(0.55344516)
            weigh.append(0.74110985)
            weigh.append(0.3748532)
            weigh.append(0.37070867)

            weigh.append(0.57734627)
            weigh.append(0.36462057)
            weigh.append(0.48534322)
            weigh.append(0.4103786)
            weigh.append(0.20865759)
            weigh.append(0.5101151)
            weigh.append(0.70207393)
            weigh.append(0.261061)
            weigh.append(0.4263476)

            weigh.append(0.4891929)
            weigh.append(0.26326942)
            weigh.append(0.5449106)
            weigh.append(0.4609151)
            weigh.append(0.21110745)
            weigh.append(0.46697062)
            weigh.append(0.6671197)
            weigh.append(0.3644622)
            weigh.append(0.31627488)
            temp = conv(dataSet, weigh)
            print('pixel tai i: ' + str(i) + ', j= ' + str(j) + ', la = ' + str(temp*64)) 


def int2Hex(value, bits):
    if value < 0:
        value = (1 << bits) + value  # Compute two's complement
    binary = format(value, f'0{bits}b')
    hex_digits = format(int(binary, 2), '03X')  # 'FD'
    return hex_digits

img = cv2.imread('test50.jpg')
# Resize to 64x64
resized_img = cv2.resize(img, (64, 64), interpolation=cv2.INTER_AREA)
cv2.imshow("After resize", resized_img)
cv2.waitKey(0)
cv2.destroyAllWindows()
# Optional: convert to list
pixel_matrix = resized_img.tolist()
print("Width: "+ str(len(pixel_matrix)) + "Hight: " + str(len(pixel_matrix[0])))
print(pixel_matrix)

convImg(pixel_matrix)

with open("picture.hex", "w") as f:
    for row in pixel_matrix:
        for pixel in row:
            r, g, b = pixel
            r = int2Hex(int(r/255*64), 10)
            f.write(r + '\n')
            g = int2Hex(int(g/255*64), 10)
            f.write(g + '\n')
            b = int2Hex(int(b/255*64), 10)
            f.write(b + '\n')

print('conplete write mem')
