FROM registry.baidubce.com/paddlepaddle/paddle:latest-dev-cuda11.4.1-cudnn8-gcc82


RUN pip3 install --upgrade pip -i https://mirror.baidu.com/pypi/simple
RUN pip3 install paddlehub --upgrade -i https://mirror.baidu.com/pypi/simple
RUN pip3 install install paddlepaddle-gpu==2.4.2 -i https://mirror.baidu.com/pypi/simple
RUN pip3 install einops
RUN pip3 install Levenshtein
RUN pip3 install "paddleocr>=2.0.1"

RUN git clone https://github.com/TrinhThiBaoAnh/Reaction.git
WORKDIR /Reaction
RUN pip install -r requirements.txt
RUN pip install --no-cache-dir -e .

RUN mkdir -p /Reaction/output
ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_r50_vd_east_v2.0_train.tar /Reaction/output
ADD RUN tar xf /Reaction/output/det_r50_vd_east_v2.0_train.tar -C /Reaction/output

####  Adding Detection models ####
RUN mkdir -p /Reaction/output

#EAST	ResNet50_vd	88.71%	81.36%	84.88%	trained model
#ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_r50_vd_east_v2.0_train.tar /Reaction/output
#ADD RUN tar xf /Reaction/output/det_r50_vd_east_v2.0_train.tar -C /Reaction/output

#EAST	MobileNetV3	78.20%	79.10%	78.65%	trained model
ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_mv3_east_v2.0_train.tar /Reaction/output
ADD RUN tar xf /Reaction/output/det_mv3_east_v2.0_train.tar -C /Reaction/output

#DB	ResNet50_vd	86.41%	78.72%	82.38%	trained model
ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_r50_vd_db_v2.0_train.tar /Reaction/output
ADD RUN tar xf /Reaction/output/det_r50_vd_db_v2.0_train.tar -C /Reaction/output

#DB	MobileNetV3	77.29%	73.08%	75.12%	trained model
#ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_mv3_db_v2.0_train.tar /Reaction/output
#ADD RUN tar xf /Reaction/output/det_mv3_db_v2.0_train.tar -C /Reaction/output

#SAST	ResNet50_vd	91.39%	83.77%	87.42%	trained model
#ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/en/det_r50_vd_sast_icdar15_v2.0_train.tar /Reaction/output
#ADD RUN tar xf /Reaction/output/det_r50_vd_sast_icdar15_v2.0_train.tar -C /Reaction/output

#PSE	ResNet50_vd	85.81%	79.53%	82.55%	
#ADD https://paddleocr.bj.bcebos.com/dygraph_v2.1/en_det/det_r50_vd_pse_v2.0_train.tar /Reaction/output
#ADD RUN tar xf /Reaction/output/det_r50_vd_pse_v2.0_train.tar -C /Reaction/output

#PSE	MobileNetV3	82.20%	70.48%	75.89%	
ADD https://paddleocr.bj.bcebos.com/dygraph_v2.1/en_det/det_mv3_pse_v2.0_train.tar /Reaction/output
ADD RUN tar xf /Reaction/output/det_mv3_pse_v2.0_train.tar -C /Reaction/output

#DB++	ResNet50	90.89%	82.66%	86.58%	pretrained model/trained model

#ADD https://paddleocr.bj.bcebos.com/dygraph_v2.1/en_det/det_r50_db%2B%2B_icdar15_train.tar /Reaction/output
#ADD RUN tar xf /Reaction/output/det_r50_db%2B%2B_icdar15_train.tar -C /Reaction/output

####  Adding OCR models ####
RUN mkdir -p /Reaction/vietocr/weights
ADD https://drive.google.com/uc?id=1nTKlEog9YFK74kPyX0qLwCWi60_YHHk4 /Reaction/vietocr/weights
ADD https://drive.google.com/uc?id=13327Y1tz1ohsm5YZMyXVMPIOjoOA0OaA /Reaction/vietocr/weights

EXPOSE 8868

CMD ["/bin/bash","-c","hub install deploy/hubserving/ocr_system/ && hub serving start -m ocr_system"]
