<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- css -->
<link rel="stylesheet" type="text/css" href="/resources/css/shop/ShopSearchList.css">
<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<title>가게 찾기 리스트</title>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/menubar.jsp"/>

	<main>
		<div class="header-background-area">
	       	<img src="/resources/images/searchShop-bg.png" alt="뒷배경이미지">
	   	</div>
		<div id="main-title">가게검색</div>
		
		<div class=frame>

			<div class="sub-title first">
				<p>식당명, 음식 종류를 검색하세요</p>
			</div>
						
			<div class="searchBar">
				<input type="text" id="searchBox" name="searchKeyword" placeholder="검색하고자 하는 식당명, 음식 종류를 입력해주세요">
				<button id="btn-search"><img src="/resources/images/search.png"></button>
			</div>
			
			<!-- 테마 메인!!!!!!!!! -->
			<div class="sub-title second">
				<p>에디터 추천</p>
			</div>
			
			<div class="searchTheme">
				<div class="theme one">
					<span>이주의 리뷰왕</span>
					<input type=hidden name="theme1" value="1">
					<img class="theme1" src="/resources/images/theme/shoptheme1.jpeg" alt="theme1">
				</div>
				<div class="theme two">
					<span>천안 맛집 추천</span>
					<input type=hidden name="theme2" value="2">
					<img class="theme1" src="/resources/images/theme/shoptheme2.jpeg" alt="theme2">
				</div>
				<div class="theme three">
					<span>이달의 신규가게</span>
					<input type=hidden name="theme3" value="3">
					<img class="theme1" src="/resources/images/theme/shoptheme3.jpeg" alt="theme3">
				</div>
				<div class="theme four">
					<span>파스타 맛집 추천</span>
					<input type=hidden name="theme4" value="4">
					<img class="theme1" src="/resources/images/theme/shoptheme4.jpeg" alt="theme4">
				</div>
				<div class="theme five">
					<span>중식 맛집 추천</span>
					<input type=hidden name="theme5" value="5">
					<img class="theme1" src="/resources/images/theme/shoptheme5.jpeg" alt="theme5">
				</div>
				<div class="theme six">
					<span>명동 맛집 추천</span>
					<input type=hidden name="theme6" value="6">
					<img class="theme1" src="/resources/images/theme/shoptheme6.jpeg" alt="theme6">
				</div>
				<div class="theme seven">
					<span>햄버거 맛집 추천</span>
					<input type=hidden name="theme7" value="7">
					<img class="theme1" src="/resources/images/theme/shoptheme7.jpeg" alt="theme7">
				</div>
				<div class="theme eight">
					<span>제주 맛집 추천</span>
					<input type=hidden name="theme8" value="8">
					<img class="theme1" src="/resources/images/theme/shoptheme8.jpeg" alt="theme8">
				</div>
				<div class="theme nine">
					<span>백반 맛집 추천</span>
					<input type=hidden name="theme9" value="9">
					<img class="theme1" src="/resources/images/theme/shoptheme9.jpeg" alt="theme9">
				</div>
				<div class="theme ten">
					<span>도심 속<br>작은 유럽</span>
					<input type=hidden name="theme10" value="10">
					<img class="theme1" src="/resources/images/theme/shoptheme10.jpeg" alt="theme10">
				</div>
				<div class="theme eleven">
					<span>분식이 땡길 때</span>
					<input type=hidden name="theme11" value="11">
					<img class="theme1" src="/resources/images/theme/shoptheme11.jpeg" alt="theme11">
				</div>
				<div class="theme twelve">
					<span>초밥 맛집 추천</span>
					<input type=hidden name="theme12" value="12">
					<img class="theme1" src="/resources/images/theme/shoptheme12.jpeg" alt="theme12">
				</div>
			</div> 
			
			
			<!-- 검색결과 가게 리스트 -->
			<!-- AJAX -->
 			<div class="sub-title second">
				<p>'${ searchKeyword }' 검색결과</p>
			</div>
			
			<div class="searchResult">
				<div class="shopShortInfo">
					<div class="shopShortInfo left">
						<!-- <img src="/resources/images/shopMainImg/realPasta.jpeg" alt="shopMain"> -->
					</div>
					<div class="shopShortInfo right">
						<input type="hidden" name="shopNo" value="${ shop.shopNo }">
						<input type="hidden" name="shopNo" value="41">
						<span id=shop-title><b><a href="shopDetail.dz?shopNo=41">진짜 파스타</a></b></span>&nbsp;&nbsp;
						<span id=shop-type>양식</span><br><br>
						<span>홍대 놀이터</span><br>
						<span>12:00 - 22:00</span><br>
						<span>매주 일요일</span>&nbsp;&nbsp;
						<span>휴무</span><br>
						<span>홍대 진짜 파스타</span> <!-- 글자수 줄이기 -->
					</div>
				</div>
			</div>
			
			<div class="searchResult navi">
			
			</div>
		</div> 
	</main>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>


	<script>
		$(function() {
			$("#btn-search").on("click", function() {
				var searchKeyword = $("#searchBox").val();
				if(searchKeyword == "") {
					alert("검색어를 입력해주세요.");
					return false;
				}else {
					$.ajax({
						url: "",
						type: "get",
						data: "",
						dataType: "json",
						success: function(data) {
							
								
						},
						error: function() {
							consloe.log("서버에 연결할 수 없습니다.");
							return false;
						}
					});
				}
			});
			
			 $(".theme1").on("click", function(e) {
				console.log(e.target);
				console.log($(e.target).prev().val());
				var themeNo = $(e.target).prev().val();
 				$.ajax({
					url: "searchTheme.dz",
					type: "get",
					data: { "themeNo" : themeNo },
					dataType: "json",
					success: function(data) {
						console.log(data.sList);
					},
					error: function() {
						console.log("서버에 연결할 수 없습니다.");
						return false;
					}
				});
			}); s
		});
	</script>
</body>
</html>