### 35_GISTREE
 김철희, 이준명, 신동민
 
Trash Flash
===========
 지구를 위해 쓰레기도 돈 내고 버려야 하는 요즘 시대! 
 
###  올바른 재활용을 위해 지스트리가 나섰다!

# 문제 인식
 - 전세계적으로 쓰레기 매립, 재활용 등 쓰레기 처리 문제로 골머리를 앓고 있음
 - 길거리 쓰레기통이 줄어나가는 추세
 - 이로 인해 길바닥에 돌아다니는 쓰레기가 늘어날 수 있음
 - 쓰레기통의 위치를 찾는 앱이 필요함

# 주요 기능 소개
 ## 주변에 가까운 쓰레기통의 위치와 분류
   1. 사용자 주변 쓰레기통 위치 **Google map** 제공
   2. 길찾기 기능으로 경로 연결
   3. 일반, 재활용, 음식물, 배터리, 의류에 해당하는 쓰레기통을 각각 분류하여 원하는 쓰레기통의 위치를 손쉽게 찾을 수 있다.
   4. 화면을 길게 누르면 사용자가 직접 쓰레기통의 위치를 추가할 수 있다.

<img src="https://user-images.githubusercontent.com/58902772/152628073-71b0ae87-e0f3-40cc-b9dd-7d2b2437517b.png" width="200" height="400"/> <img src="https://user-images.githubusercontent.com/58902772/152628076-90d2552b-4a17-47d5-95cc-78cc916dcf7e.png" width="200" height="400"/> <img src="https://user-images.githubusercontent.com/58902772/152628079-162126ff-f70b-44de-8bc2-c25ae9cc6807.png" width="200" height="400"/>

[현재 위치 및 쓰레기통 위치][쓰레기통 분류][쓰레기통 추가]

 ## 쓰레기 이미지 분석을 통한 쓰레기 분류 알고리즘
   1. 플러터의 텐서플로우 플러그인 tflite를 사용하여 사용자로부터 받은 이미지를 분석 및 쓰레기 종류 반환
   2. 곧 바로 해당 쓰레기에 해당하는 쓰레기통의 위치 구글맵으로 제공

<img src="https://user-images.githubusercontent.com/58902772/152628164-5b24260a-a6eb-4a40-b686-7a0bca1a7a88.png" width="200" height="400"/>
[쓰레기 분류]

# 기능 추가 및 확장성
  1. 쓰레기를 쓰레기통에 버릴 시 보상 지급  
    - 지역 사회의 상점과 계약을 맺고, 받은 보상으로 할인 쿠폰을 구매  
  2. 경쟁  
    - 이달에 쓰레기통 등록자 랭킹 현황  
  3. 기존에 공공데이터가 가진 문제점 극복  
    - 기존 쓰레기통 공공데이터는 정확한 위치 정보를 제공하지 못함  
    - Trash Fresh가 가진 쓰레기통의 정확한 위도, 경도 정보를 재가공하면 추가적인 효용을 만들어낼 수 있음  
  4. 쓰레기 처리 방법 제시  
    - 각 쓰레기에 대한 분리수거 및 처리 방법에 대해서 제공  
    - 쓰레기 처리에 대한 인식이 부족한 나라에서 해당 앱을 사용  
    - 재활용률 상승은 물론, 쓰레기 처리에 대한 자연스러운 시민 의식 상승 기대  
  6. 사람들이 많이 사용하는 지도앱에 똑같은 기능을 구현할 수 있을 것이라 생각함  

# 사용한 개발 도구
- Frontend : Flutter, Android Studio, VSCODE
- ML, DL : Tensorflow, Python

# 사용한 플러터 플러그인
- <a href='https://pub.dev/packages/google_maps_flutter'>GCP 구글맵 API</a>
- <a href='https://pub.dev/packages/location'>Location (현재 위치)</a>
- <a href='https://pub.dev/packages/tflite'>텐서플로우 라이트</a>

# APK 파일 다운로드
[구글 드라이브] https://drive.google.com/file/d/1fMD6nw4U-GEry0FqPXA4Kdgc5GRDUxJM/view?usp=sharing

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

![KakaoTalk_20220206_191633741](https://user-images.githubusercontent.com/77375383/152697208-03dabce6-8076-46d1-b9e5-772f0130014a.png)

