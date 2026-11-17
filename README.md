# TrackON

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-569A31?style=flat-square&logo=amazons3&logoColor=white)
![Award](https://img.shields.io/badge/2024%20연암공과대학교%20AI%20해커톤%20대회-은상-C0C0C0?style=flat-square)

> 도로 노면과 차선 도색이 닳은 곳을 사진으로 신고하는 앱

## 배경

2024 연암공과대학교 AI 해커톤 대회 출품작으로, 은상을 받았습니다(시상 2025.02). 닳은 도로나 지워진 차선은 관리하는 쪽이 직접 돌아다니며 찾아야 하는데, 매일 그 길을 지나는 사람들이 바로 신고할 수 있으면 더 빨리 찾을 수 있겠다는 생각에서 시작했습니다.

심기찬([@strain7626](https://github.com/strain7626))과 2인 팀으로 참가했고, 저는 Flutter 앱과 회원 서버를 맡았습니다.

## 구조

<img src="https://github.com/user-attachments/assets/74dbb0fa-04b5-47c3-9074-a837362c5c60" width="480"/>
<img src="https://github.com/user-attachments/assets/9dc5ae09-e4ee-4298-b5e8-d9f80729ba90" width="480"/>
<img src="https://github.com/user-attachments/assets/275b57fa-5de0-4301-9bba-dbbc043132a9" width="480"/>

## 주요 기능

- 카메라로 사진을 여러 장 찍고 현재 위치(GPS)와 함께 신고
- 신고 사진은 AWS S3, 위치와 시각은 MySQL에 저장
- 마모 단계별로 모인 신고 데이터를 내려받는 API
- 회원가입 / 로그인

마모 단계를 자동으로 분류하는 이미지 모델(Teachable Machine)도 만들었지만, 서버가 추론을 버티지 못해서 시연에서는 뺐습니다.

## 설치

```bash
git clone https://github.com/JMandoo1014/TrackON.git
cd TrackON
flutter pub get
```

서버는 따로 실행해야 합니다.
- 회원 서버: [TrackON-userServer](https://github.com/JMandoo1014/TrackON-userServer)
- 신고 서버: [TrackOnServer](https://github.com/strain7626/TrackOnServer)

## 사용법

```bash
flutter run
```

해커톤 때 쓰던 서버는 지금 내려가 있습니다. 직접 실행하려면 위 두 서버를 띄우고, 코드에 들어가 있는 서버 주소(`lib/`)를 새 주소로 바꿔야 합니다.
