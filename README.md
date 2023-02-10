# About

![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2d073f95-d8e2-4520-b9d4-c94ccbb61e6f/nathana-reboucas-7JvkLPbWGe8-unsplash.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T030358Z&X-Amz-Expires=86400&X-Amz-Signature=c1c908010ae085385fa3bbeeffcae7647f0c15c748f27c1dabb500c2f372ac3f&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22nathana-reboucas-7JvkLPbWGe8-unsplash.jpg%22&x-id=GetObject)
Alamofire를 공부해보고 싶어서 각종 자료와 유튜브에 있는 강의들을 찾아보았다.

그 중 정대리의 Alamofire를 이용한 Unsplash API 영상을 보았다.

강의는 총 3개의 영상으로 이루어져있는데,

### `강의의 결과물은 키워드로 사진을 검색해서 reponse를 단순히 콘솔에 출력하는 것이다.`

콘솔에만 출력하는것에 만족하지 않고 리팩토링을 시작해 해당 기능을 추가하였다.

# 사진검색 관련

-   키워드로 검색하여 실제 사진과 해당 사진의 작가, 게시 날짜, 좋아요 개수를 보여준다.
-   사용자가 직접 사진의 품질 (small, regular, full)을 선택할 수 있다.
-   사진을 일정시간 누르고있으면 사진이 살짝 작아지면서 뗐을 때 사진을 디바이스에 저장을 할 수 있다.
-   먼저 30장의 사진을 보여주고 뷰의 맨 밑에서 끌어올리면 추가로 30장의 사진을 더 불러온다.

# 유저검색 관련

-   사용자 이름을 검색하면 해당 이름을 사용하는 사용자들 목록을 보여준다.
-   유저의 프로필 사진, 이름, 총 사진 개수, 총 좋아요 개수를 보여준다.
-   유저의 cell을 클릭하면 해당 유저가 게시한 사진들을 보여준다.
    -   앞서 설정한 사진의 품질이 검색한 유저의 사진들에도 적용되며 사진 저장 또한 가능하다.

----------

# 🏞사진 검색

# 메인 화면
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/d9bc0912-b3c4-4977-b2fa-a0111bcd8ee2/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T030426Z&X-Amz-Expires=86400&X-Amz-Signature=5ddcbd6a4b7e68992cb69c01d1fe36e3df428df869507bed7ee6bf41719fe72c&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)


오른쪽 상단 설정 버튼을 눌러 사진의 품질을 설정할 수 있다.

# 사진 로드
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/a201204d-3325-4412-9245-4213161dffb9/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T030815Z&X-Amz-Expires=86400&X-Amz-Signature=0cfeebd12f03ed4bdc0e885e281ba5a2d99415d4659edf4eec02e9a7a08db081&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)


처음에 30장의 사진을 받아온다.

사진 뷰는 CollectionView로 구성되어 있으며, 각 cell에는 게시한 사람의 프로필 사진, 이름, 게시 날짜, 좋아요 개수가 표시된다.

# 사진 추가 로드
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/1d823148-279e-4d7e-b583-a52cb200d7c7/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T030836Z&X-Amz-Expires=86400&X-Amz-Signature=0449320926fb7936e11659141285fab582403771a1b7f049d646047fc2e24b11&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)
  


마지막 사진에서 뷰를 끌어 올리면 30장의 사진을 추가로 로드한다.

# 사진 다운로드
  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/58920a46-aa66-4b0e-8fed-8efa75396c84/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031006Z&X-Amz-Expires=86400&X-Amz-Signature=a64e13e3f930674be85dda77c7df3d94b48b066902b01f3db5f1c33eb96ae033&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)
  


사진을 일정 시간(0.5초) 누르고 있으면 사진이 작아지게 되는데 다시 손을 떼면 사진을 저장할 수 있는 Alert이 팝업된다. 사진을 저장하게 되면 디바이스에 저장이된다.

----------

# 🧑🏻‍💻사용자 검색
  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/9f7e76a2-de28-4a2e-949e-55d9935e4832/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031818Z&X-Amz-Expires=86400&X-Amz-Signature=e31dd0901dd78781dfe2c49242c850c338fb73cc75cb7ace3211dc80cc341699&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)

검색한 이름을 사용하고 있는 유저들의 목록을 UITableView로 보여준다.

각 cell에는 유저의 프로필 이미지, 이름, 총 사진 수, 총 좋아요 수가 나온다.

# 유저의 사진

  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/1f310123-dd12-400f-a832-b698048b701b/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031838Z&X-Amz-Expires=86400&X-Amz-Signature=abad1be0c97de03914a3e2e7ab9bb02e235d172fc1449176edb849b275094720&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)

유저의 cell을 클릭하면 해당하는 유저의 사진들을 보여준다.

마찬가지로 사진을 추가로 로드할 수 있다.

# 유저 사진 다운로드

  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/4d27700f-0a8b-4239-87c6-a601ac057ee3/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031853Z&X-Amz-Expires=86400&X-Amz-Signature=dc2886795422e2972aaf9a144d7e29f003abde682ea3448a251cfd75cadc976e&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)

유저의 사진도 다운 받을 수 있다.

----------

# 사진 품질 비교
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/05c7ba95-6c81-45c9-9429-c88d1836d66f/Untitled.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031910Z&X-Amz-Expires=86400&X-Amz-Signature=5e0358e2bc8f4963ff577f573dc52357c61f079c32b16744cbb49bba874a86ad&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.gif%22&x-id=GetObject)

  

![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/ab84f5e3-2d22-4f4d-9ff5-4e74e0cacd32/1019124446362819.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T031931Z&X-Amz-Expires=86400&X-Amz-Signature=b4f11d67d12cecf0ba6c7e2574d50151944c86ee9cd75d6bcd8ec13a5f20210d&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%221019124446362819.jpg%22&x-id=GetObject)
차례대로 small, regular, full

API 호출 시 실제로 지정한 사진의 품질을 받아올 수 있는걸 볼 수 있다.

----------

# 🌟 Learned

# 네트워크와 Life Cycle

네트워크를 다룰 때 화면 전환이 있다면 Life Cycle을 고려해야 한다는 점을 배웠다.

분명히 데이터를 받아 왔음에도 불구하고 화면에는 데이터가 표시되지 않았는데 그 이유는 뷰가 로드 되고 나서 데이터를 받는 행위가 끝났기 때문이다.

# 데이터 파싱

SwiftyJSON 라이브러리를 사용하여 손쉽게 파싱을 할 수 있었다.

정대리 영상에서는 아마 사진과 유저 이름정도만 받아왔는데, 리팩토링을 하면서 내가 원하는 데이터를 직접 파싱하니 조금 더 와닿았다.

가끔씩 파싱이 안되서 데이터 호출이 안되는 경우가 있었는데, 그럴 때는 API의 구조를 chart 형태로 살펴보면서 다시 파싱을 정상적으로 진행시켰다.

# Alamofire

바로 전 프로젝트가 URL Session을 이용한 프로젝트여서 그런지 Alamofire를 사용하면 어떤면에서 편리한지 더 쉽게 깨달았다.

특히 사진을 검색할건지, 유저를 검색할건지, 특정 유저의 사진을 검색할건지, 사진의 품질은 어떻게 할건지 등 여러 분기처리를 해야할 때 Interceptor와 Router를 이용해 가야할 방향만 바꿔주는 동작이 매우 편리했다.

Alamofire를 처음 이용한 프로젝트이기 때문에 아직 능숙하지는 않지만 Alamofire를 이용한 프로젝트를 더 진행해 공부를 할 계획이다.

----------

# 💡문제 해결

# 문제 - 데이터 호출과 뷰 호출

메인 화면에서 키워드 입력 후 검색 버튼 클릭 → 버튼이 눌리는 동시에 뷰 전환 & 데이터 호출

→ 항상 뷰 호출 속도가 더 빨라서 뷰의 UI가 구성이 된 후에 데이터 호출이 완료 됨 → 화면에 데이터가 표시되지 않음

# 아이디어

데이터를 호출하고 응답을 받기 전까지 뷰를 전환하지 않으면 된다고 생각했다.

데이터를 다 받기 전 뷰가 호출되는게 문제니 이 순서만 바꾸면 된다고 생각하여 왠지 DispatchQueue를 이용하면 될거같다고 생각했다.

# 해결

```swift
KRProgressHUD.show()

let getPhotoGroup = DispatchGroup()
getPhotoGroup.enter()
                    
DispatchQueue.global(qos: .userInteractive).async {
		self.fetchedPhotos = fetchedPhotos
		print("DISPATHGROUP START")
		getPhotoGroup.leave()
}
                    
getPhotoGroup.wait()

KRProgressHUD.showSuccess()
self.pushVC()

```

DispatchGroup을 사용해 해결했다.

group 안에 들어간 job들이 끝나기를 기다렸다가 모두 완료되면 pushVC()를 함으로써 뷰를 전환한다.

기다리는 시간동안 KRProgressHUD를 통해 indicator를 화면에 띄어줬다.

# 문제 - 고화질 사진 로드 시 버벅거림

사진 품질을 small이나 regular로 할때는 문제가 없었지만 full로 받아오면 스크롤 시 CollectionView가 굉장히 버벅거리며 프레임 드랍이 발생하였다.

# 아이디어

이미지를 url로 가져오는 부분을 기다리느라 cell을 그리는게 늦어지는것이 문제라고 생각했다.

비동기적으로 처리하면 어떨까 해서 관련 정보를 찾아보던 중 SDWebImage가 비동기적인 처리 & 이미지 캐싱 기능이 있다고 해서 사용해보기로 했다.

# 해결

```swift
// Kingfisher로 받아올 때 이미지 다운로드 속도가 느리고 스크롤시 버벅거림이 발생하였다.
// cell.photoCell.kf.setImage(with: fileURL, placeholder: UIImage(systemName: "text.below.photo"))

// SDWebImage 사용
cell.photoCell.sd_setImage(with: fileURL, placeholderImage: UIImage(systemName: LOADING_PHOTO.BELOW_PHOTO))

```

SDWebImage 라이브러리를 사용해서 이미지를 받아오는 것을 비동기적으로 처리하고 받아온 이미지를 캐싱하여 사용할 수 있다.

----------

# 💬느낀점

검색창에서 검색을 할 때 검색 키워드를 사진을 보여주는 뷰로 넘겨주어서 그 뷰에서 호출을 하는게 보편적인 방식이라는 피드백을 받았다.

사실 이 프로젝트를 개발을 할 때 키워드만 넘겨주어야 하나 아니면 먼저 데이터를 받아서 데이터를 넘겨주어야 하나 이 두가지 방식에 대해 고민을 해봤다.

키워드만 넘겨주는 것이 한눈에 봐도 더 편리해보였지만  **데이터를 미리 받아서 넘겨주는 방식은 어떨까?**  라는 생각이 들어서 해당 방법으로 진행했다.

프로젝트를 완료하고나니 데이터를 넘겨주는 방식으로 하니까 더 복잡해진 것 같다.

그래도 이번 기회에 Dispatch Group이라는 것도 써봐서 좋았다.

이번에 이러한 방법으로 시도를 해보았으니 다음 프로젝트에서는 편리하고 간소화된 방식이 있으면 그 방식을 채택해서 해봐야겠다.
