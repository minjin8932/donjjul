<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- css -->
<link rel="stylesheet" type="text/css" href="/resources/css/map/MapDetail.css">
<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- 지도 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1683794343a4e97ff3195b44b6488d0c&libraries=services"></script>
<title>지도 상세 페이지</title>
</head>
<body>
    <jsp:include page="/WEB-INF/views/map/MapDetailmenubar.jsp"></jsp:include> 

	<main>
		<input type="hidden" id="center-value" value="${center }">
		<div class=frame>
			<div class=map-left>
				<div class="searchBar">
					<!-- <form action="#"> -->
						<input type="text" id="searchBox" name="searchKeyword" placeholder="지역명, 가게명 검색">
						<button id="btn-search"><img src="/resources/images/undo.png"></button>
					<!-- </form> -->
				</div>
				<hr>
				<div class="content-list">
					<c:if test="${empty mList}">
						<span>등록된 가게가 없습니다.</span>
					</c:if>
					<c:if test="${!empty mList}">
						<c:forEach items="${ mList }" var="shop">
							<div class="content-shop">
								<div class="content-shop left">
									<img src="/resources/images/logoG-mark.png" alt="대표이미지" class="img-thumbnail none"/>
									<!-- <img src="/resources/images/shopMainImg/" alt="대표이미지" class="img-thumbnail"/> -->
								</div>
								<div class="content-shop right">
									<div class="content-shop right top">
										<span id="shop-title"><b>${ shop.shopName }</b>&nbsp;&nbsp;</span>
										<span>${ shop.shopType }</span><br>
										<span>${ shop.shopAddr }</span><br>
										<c:if test="${!empty shop.shopContent }">
											<span id="shop-content">${ shop.shopContent }</span><br>
										</c:if>
										<c:if test="${!empty shop.shopContent }">
											<span id="shop-content"></span><br>
										</c:if>
										<br>
									</div>
									<div class="content-shop right bottom">
										<button type="button" class="btn btn-primary btn-sm" onclick="shopDetail(${shop.shopNo })">예약하기</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:if>
				</div>
				<div class="content-list-navi">
					<c:if test="${empty mList}">
					</c:if>
					<c:if test="${!empty mList}">
						<hr>
					</c:if>
					<c:url var="before" value="mapSearchShop.dz">
						<c:param name="page" value="${ pi.currentPage - 1 }"></c:param>
						<c:if test="${ !empty location }">
							<c:param name="location" value="${ location }"></c:param>
						</c:if>
					</c:url>
					<c:if test="${ pi.currentPage > 1 }">
						<a href="${ before }"><img src="/resources/images/navi-left.png" alt="이전"/>&nbsp;&nbsp;</a>
					</c:if>
					<c:forEach var="p" begin="${ pi.startPage }" end="${ pi.endPage }">
						<c:url var="pagination" value="mapSearchShop.dz">
							<c:param name="page" value="${ p }"></c:param>
							<c:if test="${ !empty location }">
								<c:param name="location" value="${ location }"></c:param>
							</c:if>
						</c:url>
						<c:if test="${ p eq pi.currentPage }">
							<span id="currentPage">${ p }</span>
						</c:if>
						<c:if test="${ p ne pi.currentPage }">
							<a href="${ pagination }"><span id="otherPage">${ p }</span>&nbsp;&nbsp;</a>
						</c:if>
					</c:forEach>
					<c:url var="after" value="mapSearchShop.dz">
						<c:param name="page" value="${ pi.currentPage + 1 }"></c:param>
						<c:if test="${ !empty location }">
							<c:param name="location" value="${ location }"></c:param>
						</c:if>
					</c:url>
					<c:if test="${ pi.currentPage >= pi.maxPage }">
					</c:if>
					<c:if test="${ pi.currentPage < pi.maxPage }">
						<a href="${ after }"><img src="/resources/images/navi-right.png" alt="다음"/></a>
					</c:if>
				</div>
			</div>
			<div class=map-right>
				<div class="mapZoom">
					<div class="mapZoom in">
						<span onclick="zoomIn()"><img src="/resources/images/plus-white.png" alt="zoom-in"></span>
					</div>
					<div class="mapZoom out">
						<span onclick="zoomOut()"><img src="/resources/images/minus-white.png" alt="zoom-out"></span>
					</div>
				</div> 
				<div id="map"> 
				</div>
			</div>
		</div>
	</main>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	
	<!-- 맵 js -->
	<script>
		mapJs();
		
		function mapJs(markers) {
			var positions = [];
			
			if(markers != null) {
				for( var i = 0; i < markers.length; i++) {
					var shopMap = new Object();
					shopMap.shopNo = markers[i].shopNo;
					shopMap.shopName = markers[i].shopName;
					shopMap.shopShortAddr = markers[i].shopShortAddr;
					shopMap.shopAddr = markers[i].shopAddr;
					shopMap.startTime = markers[i].startTime;
					shopMap.endTime = markers[i].endTime;
					shopMap.businessDay = markers[i].businessDay;
					shopMap.shopTarget = markers[i].shopTarget;
					shopMap.shopProduct = markers[i].shopProduct;
					
					positions.push(shopMap);
				}
			}else {
				<c:forEach var="shop" items="${mapMarkers}" >
					var shopMap = new Object();
					
					shopMap.shopNo = "${shop.shopNo}";
					shopMap.shopName = "${shop.shopName}";
					shopMap.shopShortAddr = "${shop.shopShortAddr}";
					shopMap.shopAddr = "${shop.shopAddr}";
					shopMap.startTime = "${shop.startTime}";
					shopMap.endTime = "${shop.endTime}";
					shopMap.businessDay = "${shop.businessDay}";
					shopMap.shopTarget = "${shop.shopTarget}";
					shopMap.shopProduct = "${shop.shopProduct}";
					
					positions.push(shopMap);
				</c:forEach>
			}
		
			var selectedCenter = $("#center-value").val();
			/* var searchedCenter = "${searchedCenter}"; */
			
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		 		mapOption = { 
		        center: new kakao.maps.LatLng(37.56557, 126.97808), // 지도의 중심좌표
		        level: 7 // 지도의 확대 레벨
		    	};
			
			var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
			
			 // 마우스 휠로 지도 확대,축소 가능여부를 설정합니다
		    map.setZoomable(false); 
			
			// 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
			function zoomIn() {
			    map.setLevel(map.getLevel() - 1);
			}
			// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
			function zoomOut() {
			    map.setLevel(map.getLevel() + 1);
			}
			
			// 주소-좌표 변환 객체를 생성합니다
			var geocoder = new kakao.maps.services.Geocoder();
			
			// 지도조회 - 지역 선택시
			/* if( selectedCenter ) { */
		 		geocoder.addressSearch(selectedCenter, function(result, status) {
					
					// 정상적으로 검색이 완료됐으면 
				     if (status === kakao.maps.services.Status.OK) {
				
				    	var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
						map.setCenter(coords);
				     }
				});
	
			// 마커 클릭시 기존에 열려있는 인포 윈도우 닫고 새로운 인포 윈도우 띄우기 위해
			// 커스텀 오버레이 전역변수 선언
	 		var selectedMarker = null;
			var selectedOverlay = null;
	 		var clickedMarker = null;
	 		var clickedOverlay = null;
			
			// 주소로 좌표를 검색합니다
			positions.forEach(function(shop, index){ 
				
				geocoder.addressSearch(shop.shopAddr, function(result, status) {
					
				    // 정상적으로 검색이 완료됐으면 
				     if (status === kakao.maps.services.Status.OK) {
				
						var imageSrc = '/resources/images/map_marker_blue_v2.png', // 마커이미지의 주소입니다    
						    imageSize = new kakao.maps.Size(27, 35); // 마커이미지의 크기입니다
						    imageOption = {offset: new kakao.maps.Point(27, 35)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
						      
						// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
						var markerImage = new kakao.maps.MarkerImage(imageSrc,imageSize, imageOption),
						    markerPosition = new kakao.maps.LatLng(result[0].y,result[0].x); // 마커가 표시될 위치입니다
						    
						// 마커를 생성합니다
						var marker = new kakao.maps.Marker({
						    position: markerPosition, 
						    image: markerImage, // 마커이미지 설정 
						});
						
						// 마커가 지도 위에 표시되도록 설정합니다
						marker.setMap(map);
						
						/// 커스텀 오버레이에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
						var content = '<div class="customoverlay">' +
							 '  <div class="tail">' + 
						    '    <span class="title" onclick="showShortInfo('+markerPosition+')">' + shop.shopName + '</span>' +
						    '  </div>' +
						    '</div>';
						
						// 커스텀 오버레이를 생성합니다
						var titleOverlay = new kakao.maps.CustomOverlay({
						    position: markerPosition,
						    content: content,
						    yAnchor: 2
						});  
						
						
	 				 	// 마커에 마우스오버 이벤트를 등록합니다
						kakao.maps.event.addListener(marker, 'mouseover', function() {
							
							if(clickedMarker != null && clickedOverlay != null) {
								selectedOverlay.setMap(null);
								selectedMarker.setZIndex(1);
							}
						
							selectedMarker = marker;
							selectedOverlay = titleOverlay;
							 
							 // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
						    titleOverlay.setMap(map);
						    
						    selectedMarker.setZIndex(10);
						    selectedOverlay.setZIndex(10);
							 
						});
	 				 	
						// 클릭한 마커 존재할 경우 해당 마커 마우스오버 막기
						var mOverHandler = function(event) {
							titleOverlay.setMap(null);
							}
						}
	 				 	
						 // 마커에 클릭이벤트를 등록합니다
					    kakao.maps.event.addListener(marker, 'click', function() {
								
					    	// 선택된 마커
					    	clickedMarker = marker;
					    		
							var content = '<div class="wrap">' + 
					            '    <div class="info">' + 
					            '        <div class="title">' + shop.shopName + 
					            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
					            '        </div>' + 
					            '        <div class="body">' + 
					         /*    '            <div class="img">' +
					            '                <img src="https://cfile181.uf.daum.net/image/250649365602043421936D" width="73" height="70">' +
					            '           </div>' +  */
					            '            <div class="desc">' + 
					            '                <div class="ellipsis">제공대상 : '+shop.shopTarget+'</div>' + 
					            '                <div class="ellipsis product">제공품목 : '+shop.shopProduct+'</div>' + 
					            '                <div class="jibun ellipsis">영업시간 : '+shop.startTime+':00 - '+shop.endTime+':00</div>' + 
					            '            </div>' + 
					            '            <div class="btnShop">' + 
								'				 <button type="button" class="btn btn-primary btn-sm" onclick="shopDetail('+shop.shopNo+')">예약하기</button></div>' + 
					            '            </div>' + 
					            '        </div>' + 
					            '    </div>' +    
					            '</div>';
					        
							
							// 마커 위에 커스텀오버레이를 표시합니다
							// 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
							var overlay = new kakao.maps.CustomOverlay({
							    content: content,
							    map: map,
							    position: markerPosition,
							    zIndex: 10
							});	
							
							
							// 마커 클릭시 기존에 열려있는 인포 윈도우 닫고 새로운 인포 윈도우 띄우기
							if (clickedOverlay) {
							        clickedOverlay.setMap(null);
							    }
							 	overlay.setMap(map);
							    clickedOverlay = overlay;
							    
							    
							
							// 클릭한 마커 존재할 경우 해당 마커 마우스오버 막기
						    /* if(clickedMarker) {
						    	kakao.maps.event.removeListener(map, 'mouseover', mOverHandler);
					    	} */
					    	
					    });
						 
						
					  	// 마커에 마우스아웃 이벤트를 등록합니다
						kakao.maps.event.addListener(marker, 'mouseout', function() {
						    // 마커에 마우스아웃 이벤트가 발생하면 인포윈도우를 제거합니다
						    titleOverlay.setMap(null);
						    
						});
					  	
						
						function goDetail(shopNo) {
							location.href='shopDetail.dz';
							
						}
						
				     }
				});
			});
		}

		// 커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
		function closeOverlay() {
			    overlay.setMap(null);     
		}    
	
			$("#btn-search").on("click", function() {
				/* var result = true; */
				
				var searchKeyword = $("#searchBox").val();
				if(searchKeyword == "") {
					alert("검색하실 지역을 입력해주세요.");
					/* result = false; */
					return false;
				}else {
					$(".content-list").empty();
					$(".content-list-navi").empty();
	
						$.ajax({
							url: "mapSearchKey.dz",
							type: "get",
							data: { "searchKeyword": searchKeyword }, // ""따옴표 안의 값이 키 값, vo 클래스 변수명과 일치해야 한다.
							/* async: false, */
							dataType: "json", // 중요!! 안 적으면 데이터 안 가져옴
							success: function(data) {
								var contentList = $(".content-list");
								var contentListNavi = $(".content-list-navi");
								$("#center-value").val(data.center);
								if(data.mList.length > 0) { 
									$(".content-list").empty();
									$(".content-list-navi").empty();
									
									/* 검색 리스트 */
									for( var i in data.mList) {
										
										var contentShop = $("<div class='content-shop'>");
										var contentShopLeft = $("<div class='content-shop left'>");
										var contentShopRight = $("<div class='content-shop right'>");
										var contentShopRightTop = $("<div class='content-shop right top'>");
										var contentShopRightBottom = $("<div class='content-shop right bottom'>");
										
										contentShopLeft.append("<img src='/resources/images/logoG-mark.png' alt='대표이미지' class='img-thumbnail none'/>");
										contentShopRightTop.append("<span id='shop-title'><b>"+data.mList[i].shopName+"</b>&nbsp;&nbsp;</span>")
														   .append("<span>"+data.mList[i].shopType+"</span><br>")
														   .append("<span>"+data.mList[i].shopAddr+"</span><br>")
														   .append("<span>"+data.mList[i].shopContent+"</span><br>");
										contentShopRightBottom.append("<button type='button' class='btn btn-primary btn-sm' onclick='shopDetail("+data.mList[i].shopNo+")'>예약하기</button>");
										contentShop.append(contentShopLeft);
										contentShopRight.append(contentShopRightTop);
										contentShopRight.append(contentShopRightBottom);
										contentShop.append(contentShopRight);
										contentList.append(contentShop); 
							 	 	}
									
									
									/* 네비 */
									contentListNavi.append("<hr>");
									if(data.pi.currentPage > 1) {
										var prev = Number(data.pi.currentPage)-1;
										contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+prev+");'><img src='/resources/images/navi-left.png' alt='이전'/>&nbsp;&nbsp;</a>");
									}
									for(var i = data.pi.startPage; i <= data.pi.endPage; i++) {
										if(i == data.pi.currentPage) {
											contentListNavi.append("<span id='currentPage'>"+i+"</span>");	
										}else if(i != data.pi.currentPage) {
											contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+i+");'><span id='otherPage'>"+i+"</span>&nbsp;&nbsp;</a>");
										}
									}
									if(data.pi.currentPage < data.pi.maxPage) {
										var next = Number(data.pi.currentPage)+1;
										contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+next+");'><img src='/resources/images/navi-right.png' alt='다음'/></a>");
									}
									
									/* 맵 js */
									console.log(data.mapMarkers);
									mapJs(data.mapMarkers);
									
							}else {
								$(".content-list").empty();
								$(".content-list-navi").empty();
								contentList.append("<span>등록된 가게가 없습니다.</span>");
								/* result = false; */
							}  
						},
						error: function() {
							console.log("서버에 연결할 수 없습니다.");
						}
					});
	 				/* result = true; */
				}
			});
		
			
			function shopDetail(shopNo) {
				location.href='shopDetail.dz?shopNo='+shopNo;
			}
			
			function searchLogic1(searchKeyword, page) {
			
				$(".content-list").empty();
				$(".content-list-navi").empty();
	
					$.ajax({
						url: "mapSearchKey.dz",
						type: "get",
						data: { "searchKeyword": searchKeyword, "page" :  page}, // ""따옴표 안의 값이 키 값, vo 클래스 변수명과 일치해야 한다.
						/* async: false, */
						dataType: "json", // 중요!! 안 적으면 데이터 안 가져옴
						success: function(data) {
							var contentList = $(".content-list");
							var contentListNavi = $(".content-list-navi");
							$("#center-value").val(data.center);
							if(data.mList.length > 0) { 
								$(".content-list").empty();
								$(".content-list-navi").empty();
								
								/* 검색 리스트 */
								for( var i in data.mList) {
									
									var contentShop = $("<div class='content-shop'>");
									var contentShopLeft = $("<div class='content-shop left'>");
									var contentShopRight = $("<div class='content-shop right'>");
									var contentShopRightTop = $("<div class='content-shop right top'>");
									var contentShopRightBottom = $("<div class='content-shop right bottom'>");
									
									contentShopLeft.append("<img src='/resources/images/logoG-mark.png' alt='대표이미지' class='img-thumbnail none'/>");
									contentShopRightTop.append("<span id='shop-title'><b>"+data.mList[i].shopName+"</b>&nbsp;&nbsp;</span>")
													   .append("<span>"+data.mList[i].shopType+"</span><br>")
													   .append("<span>"+data.mList[i].shopAddr+"</span><br>")
													   .append("<span>"+data.mList[i].shopContent+"</span><br>");
									contentShopRightBottom.append("<input type='hidden' name='shopNo' value="+data.mList[i].shopNo+">")
														  .append("<button type='button' class='btn btn-primary btn-sm' onclick='shopDetail()'>예약하기</button>");
									contentShop.append(contentShopLeft);
									contentShopRight.append(contentShopRightTop);
									contentShopRight.append(contentShopRightBottom);
									contentShop.append(contentShopRight);
									contentList.append(contentShop); 
						 	 	}
									
								
								/* 네비 */
								contentListNavi.append("<hr>");
								if(data.pi.currentPage > 1) {
									var prev = Number(data.pi.currentPage)-1;
									contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+prev+");'><img src='/resources/images/navi-left.png' alt='이전'/>&nbsp;&nbsp;</a>");
								}
								for(var i = data.pi.startPage; i <= data.pi.endPage; i++) {
									if(i == data.pi.currentPage) {
										contentListNavi.append("<span id='currentPage'>"+i+"</span>");	
									}else if(i != data.pi.currentPage) {
										contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+i+");'><span id='otherPage'>"+i+"</span>&nbsp;&nbsp;</a>");
									}
								}
								if(data.pi.currentPage < data.pi.maxPage) {
									var next = Number(data.pi.currentPage)+1;
									contentListNavi.append("<a href='#' onclick='searchLogic1(\""+data.searchKeyword+"\", "+next+");'><img src='/resources/images/navi-right.png' alt='다음'/></a>");
								}

								var mapMarkers = data.mapMarkers;
									
								/* 맵 js */
								mapJs(mapMarkers);
								
						}else {
							$(".content-list").empty();
							$(".content-list-navi").empty();
							contentList.append("<span>등록된 가게가 없습니다.</span>");
						}  
					},
					error: function() {
						console.log("서버에 연결할 수 없습니다.");
					}
				});
			}
	</script>
	
	
</body>
</html>