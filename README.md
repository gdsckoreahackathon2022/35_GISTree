### 35_GISTREE
 김철희, 이준명, 신동민
 
# Trash Flash
 지구를 위해 쓰레기도 돈 내고 버려야 하는 요즘 시대! 
 
###  올바른 재활용을 위해 지스트리가 나섰다!
 1. 주변에 가까운 쓰레기통의 위치와 분류
   - **Google map**을 통해 거리가 가까운 쓰레기통의 위치를 알려주고 그후 길찾기 기능으로 바로 연결해준다.
   - 일반, 재활용, 음식물, 베터리, 의류 쓰레기통을 각각 분류하여 자신에게 필요한 쓰레기통 위치를 쉽게 찾을수 있다.
  
 2. 쓰레기 **이미지 분석**을 통한 재활용 가능여부 판단 
  - tensorflow를 활용한 딥러닝 기술을 기반으로 만들어진 이미지 분석으로 쓰레기의 종류와 재활용 가능여부 판단한다.
  - 그후 이에 따른 쓰레기통을 바로 추천해준다.

![KakaoTalk_20220205_085233248](https://user-images.githubusercontent.com/88830582/152621825-4bd203c1-3e70-4a2a-a75a-55e415099481.png)
 
- Frontend, Backend : Flutter
- ML, DL : Tensorflow, Python

# 다운로드
[구글 드라이브] : https://drive.google.com/file/d/1fMD6nw4U-GEry0FqPXA4Kdgc5GRDUxJM/view?usp=sharing

# ML, DL

1. tensorflow
- xception pretrained model by imagenet + 1 dense layers (adam by lr 0.001, categorical crossentropy, reducelronplateau mul 0.2, earlystopping)
- 20k garbage image for kaggle data sets
  1. https://www.kaggle.com/asdasdasasdas/garbage-classification (License:OOA)
  2. https://www.kaggle.com/mostafaabla/garbage-classification (License:OD, OOA)
  3. https://www.kaggle.com/casually/garbage-classification (License: ?)
- 9 classes(battery, biological, clothes, glass, metal, paper, plastic, trash, vinyl)
- 15895 train set, 3971 validation set
- 35 epoches, 82.1% validation accuracy

![image](https://user-images.githubusercontent.com/88830582/152622000-3865a26e-6c19-4bf1-88b1-f5c3ddd5e019.png)

2. Tflite
- tensorflow model을 안드로이드에서 사용하기 위해 tflite model형식으로 변환
- 약 5~10%의 정확도 손실이 있으나 model의 용량을 줄일 수 있다.


# Design
1. Figma link
 - https://www.figma.com/file/IHAzxyMOTAWKCcmP7Oj4Cv/GDSC-%EC%93%B0%EB%A0%88%EA%B8%B0%ED%86%B5-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8?node-id=0%3A1
<img width="400" alt="Group 110" src="https://user-images.githubusercontent.com/77375383/152611866-86f67007-413f-450c-9ad7-a95c34133191.png">

### Key changes
Google map on app(FE)#1
- Google project api + vers

Marking on google map(FE) #3
- Google_maps_flutter

Changing TFlite to TensorFlow(BE) #7
- Closed cause of the computer issue

Increasing number of marker(FE) #5
- Setting List of the marker

Location to myplace on google map by flutter location(FE) #12
- Flutter Location +OnLocationChanged.listen function

Adding markers by user #16
- Linking data + getting marker dataset     


---------------------------------------------------------------------------------------------------
감격의 순간...
![KakaoTalk_20220205_105802512](https://user-images.githubusercontent.com/77375383/152624549-f6c5ace2-2136-4af9-99d9-2aef4de8ceaf.png)
