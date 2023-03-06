from paddleocr import PaddleOCR
import cv2
from align import align
# Also switch the language by modifying the lang parameter
ocr = PaddleOCR(lang="latin") # The model file will be downloaded automatically when executed for the first time
img_path ='image/image.jpeg'
result = ocr.ocr(img_path,rec=False)
# Recognition and detection can be performed separately through parameter control
# result = ocr.ocr(img_path, det=False)  Only perform recognition
# result = ocr.ocr(img_path, rec=False)  Only perform detection
# Print detection frame and recognition result
for line in result:
    print(line)

# Visualization
mat = cv2.imread(img_path)

boxes = [line for line in result]
txts = [line[1][0] for line in result]
scores = [line[1][1] for line in result]
res = mat
for box in boxes: 
    box[0][1] = box[0][1]-5
    box[2][1]= box[2][1]+5
    box[0][0] = box[0][0]-5
    box[2][0]= box[2][0]+5
    top_left     = (int(box[0][0]), int(box[0][1]))
    bottom_right = (int(box[2][0]), int(box[2][1]))
    
    res= cv2.rectangle(res, top_left, bottom_right, (0, 255, 0), 1)
# mat=cv2.resize(mat,(1500,900))
cv2.imwrite("image/res.jpg", res)
i=0
for box in boxes:
    i = i +1
    me = align(mat,box)
    cv2.imwrite(f"image/res{i}.jpg", me)
    # cv2.waitKey(0)
