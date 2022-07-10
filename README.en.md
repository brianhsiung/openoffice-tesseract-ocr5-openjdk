# openoffice-tesseract-ocr5-openjdk

#### 介绍
openoffice-tesseract-ocr5-openjdk:8-jre-bullseye

1. 下载
https://www.openoffice.org/zh-cn/download/

![image-20220710124307033](https://brianhsiung.oss-cn-hangzhou.aliyuncs.com/img/image-20220710124307033.png)

https://notesalexp.org/tesseract-ocr/packages5/en/debian/bullseye/amd64/

下载：tesseract-ocr libtesseract5 tesseract-ocr-osd tesseract-ocr-eng tesseract-ocr-chi-sim 

2. 构建

```shell
image_name='openoffice-tesseract-ocr5-openjdk:8-jre-bullseye'
docker build -t  $image_name .
docker tag $image_name ccr.ccs.tencentyun.com/brian/$image_name
docker push ccr.ccs.tencentyun.com/brian/$image_name
```
