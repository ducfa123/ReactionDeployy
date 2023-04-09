from paddleocr import PaddleOCR
import cv2
import matplotlib.pyplot as plt
from PIL import Image
from align import align
from vietocr.tool.predictor import Predictor
from vietocr.tool.config import Cfg
import unidecode


def remove_accent(text):
    return unidecode.unidecode(text)


def check_is_reaction(reaction_text_lst, img_text):
    for txt in reaction_text_lst:
        s = remove_accent(txt.lower())
        if s in img_text:
            return True
    return False


async def infer(img_path):
    print(img_path)
    # load model ocr
    config = Cfg.load_config_from_name('vgg_transformer')
    config['weights'] = './vietocr/weights/vgg_transformer.pth'
    # config['weights'] = 'https://drive.google.com/uc?id=13327Y1tz1ohsm5YZMyXVMPIOjoOA0OaA'
    config['cnn']['pretrained'] = False
    config['device'] = 'cuda:0'
    config['predictor']['beamsearch'] = False
    detector = Predictor(config)    

    # Also switch the language by modifying the lang parameter
    # The model file will be downloaded automatically when executed for the first time
    det = PaddleOCR(lang="latin")
    result = det.ocr(img_path, rec=False)

    # Visualization
    mat = cv2.imread(img_path)
    image_name = img_path.split("/")[-2]
    # f = open("./output_ocr/{0}".format(image_name),"w+")


    boxes = [line for line in result]
    for box in boxes:
        box[0][1] = box[0][1]*0.98
        box[2][1] = box[2][1]*1.02
    txts = [line[1][0] for line in result]
    print(txts)
    scores = [line[1][1] for line in result]
    count = 0
    res = ""
    for box in boxes:
        count = count + 1
        crop_img = align(mat, box)
        convert_img = cv2.cvtColor(crop_img, cv2.COLOR_BGR2RGB)
        im_pil = Image.fromarray(convert_img)
        s = detector.predict(im_pil)
        res = s + ' ' + res
        cv2.imwrite("image/res{0}.jpg".format(count), crop_img)
    res = remove_accent(res)
    print(res)
    reaction_text_lst = open("./quan_diem_xau_doc_text.txt", "r", encoding="utf8").readlines()
    processed_lst = [remove_accent(txt.upper().replace("\n", ""))
                     for txt in reaction_text_lst]
    if check_is_reaction(processed_lst, res):
        print("Phản động")
        return {
            "response": True
            }
    else:
        print("Bình thường")
        return {
            "response": False   #
            }