# aps-build

## Introduction

이 프로젝트는 Android APS 빌드에 어려움을 겪는 분들을 위한 자동 빌드 스크립트입니다.

##  Features

app, wear 모듈의 full-release.apk 를 생성합니다.

### Prerequisites

현재 Windows (x64) 용 빌드 스크립트만 준비된 상태입니다.
다른 architecture 대응이 필요하시면 issues 에 요청 바랍니다.

### Installation

aps-build.bat 파일을 다운받아서 바로 실행해주세요.
그 과정에서 app signing 에 필요한 keystore 가 존재하지 않으면 임의로 생성하게 됩니다.

keystore 생성 시 사용되는 비밀번호는 aps-key-pass.txt 파일을 참조하며
이 파일이 존재하지 않는 경우에는 역시 임의로 생성됩니다. (default: sugartree)

혹시 기존에 사용하시던 keystore 파일이 있는 경우

aps-build.bat 파일이 있는 폴더에 복사하고 android-aps.jks 로 파일명을 변경해주시면 됩니다.

빌드 과정이 지난 후 생성된 apk 파일은 apk-20231203 과 같은 형식의 output 폴더에 저장됩니다.

## License

This project is licensed under the MIT License.
