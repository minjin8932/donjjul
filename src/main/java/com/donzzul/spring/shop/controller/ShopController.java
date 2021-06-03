package com.donzzul.spring.shop.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.donzzul.spring.common.PageInfo;
import com.donzzul.spring.common.Pagination;
import com.donzzul.spring.dreamreview.domain.DreamReview;
import com.donzzul.spring.dreamreview.service.DreamReviewService;
import com.donzzul.spring.mzreview.domain.MzReview;
import com.donzzul.spring.mzreview.service.MzReviewService;
import com.donzzul.spring.pick.domain.Pick;
import com.donzzul.spring.pick.service.PickService;
import com.donzzul.spring.shop.domain.MainMenu;
import com.donzzul.spring.shop.domain.MenuPhoto;
import com.donzzul.spring.shop.domain.MapPagination;
import com.donzzul.spring.shop.domain.Shop;
import com.donzzul.spring.shop.service.ShopService;
import com.donzzul.spring.user.domain.User;
import com.google.gson.Gson;
import com.google.gson.JsonIOException;

@Controller
public class ShopController {

	@Autowired
	private ShopService sService;
	
	@Autowired
	private MzReviewService mService;
	
	@Autowired
	private DreamReviewService drService;
	
	@Autowired
	private PickService pService;
	
	//D 지도 - 지역별 화면단 출력 +++
	@RequestMapping(value="mapSearchList.dz", method=RequestMethod.GET)
	public String mapSearchList() {
		return "map/MapList";
	}
	
	//D 지도 - 지역별 가게 검색
	@RequestMapping(value="mapSearchShop.dz", method=RequestMethod.GET)
	public ModelAndView searchShopMap(ModelAndView mv, @RequestParam("location") String location, @RequestParam(value="page", required=false) Integer page) {
		String qLocation = "";	
		switch(location) {
			case "All" : 
				qLocation = "전체";
				break;
			case "Seoul" : 
				qLocation = "서울";
				break;
			case "Busan" : 
				qLocation = "부산";
				break;
			case "Gwangju" : 
				qLocation = "광주";
				break;
			case "Daegu" : 
				qLocation = "대구";
				break;
			case "Daejeon" : 
				qLocation = "대전";
				break;
			case "Sejong" : 
				qLocation = "세종";
				break;
			case "Ulsan" : 
				qLocation = "울산";
				break;
			case "Incheon" : 
				qLocation = "인천";
				break;
			case "Jeju" : 
				qLocation = "제주";
				break;
			case "Gangwon" : 
				qLocation = "강원";
				break;
			case "Gyeonggi" : 
				qLocation = "경기";
				break;
			case "SouthGyeongsang" : 
				qLocation = "경남";
				break;
			case "NorthGyeongsang" : 
				qLocation = "경북";
				break;
			case "SouthJeolla" : 
				qLocation = "전남";
				break;
			case "NorthJeolla" : 
				qLocation = "전북";
				break;
			case "SouthChungCheong" : 
				qLocation = "충남";
				break;
			case "NorthChungCheong" : 
				qLocation = "충북";
				break;
			default:
				qLocation = "서울";
				break;
		}
		System.out.println(qLocation);
		
		HashMap<String, String> selectedLocation = new HashMap<String, String>();
		selectedLocation.put("location", qLocation);
		System.out.println("로케이션 값" + selectedLocation); // 확인용
		
		// PageInfo 만들기 위해 필요한 데이터
		int currentPage = (page != null) ? page : 1; // 삼항연산자
		int listCount = sService.selectListCount(selectedLocation); // 전체 게시글 갯수
		PageInfo pi = MapPagination.getMapPageInfo(currentPage, listCount); // 페이징에 필요한 값을 구하기 위한 메소드

		ArrayList<Shop> mapList = sService.selectShopMap(pi, selectedLocation);
		ArrayList<Shop> mapMarkers = sService.selectShopMap(selectedLocation);
		
		mv.addObject("pi",	pi);
		mv.addObject("mList", mapList);
		mv.addObject("mapMarkers", mapMarkers);
		mv.addObject("location", location);
		mv.addObject("center", qLocation);
		mv.setViewName("map/MapDetail");
		
		System.out.println(location); // 확인용
		
		return mv;
	}
	
	//D 지도 - 지역별 가게 키워드 검색
	@RequestMapping(value="mapSearchKey.dz", method=RequestMethod.GET)
	public void searchShopMapKey(@RequestParam("searchKeyword") String searchKeyword, HttpServletResponse response, @RequestParam(value="page", required=false) Integer page) throws Exception {
		
		int currentPage = (page != null) ? page : 1; 
		int listCount = sService.selectKeyListCount(searchKeyword); 
		PageInfo pi = MapPagination.getMapPageInfo(currentPage, listCount); 
		
		ArrayList<Shop> mapList = sService.searchMapKeyword(pi, searchKeyword);
		ArrayList<Shop> mapMarkers = sService.searchMapKeyword(searchKeyword);
		
//		System.out.println("테스트 확인 :" + mapList);
//		System.out.println("로케이션 테스트 확인 :" + mapList.get(0).getShopAddr());

		response.setContentType("application/json"); // json 객체로 전달시 파라미터 값 다름("text/html;charset=utf-8")
		response.setCharacterEncoding("utf-8"); // 데이터 한글 변환 위해 필수 작성!!
		
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		hashMap.put("pi", pi);
		hashMap.put("mList", mapList);
		hashMap.put("mapMarkers", mapMarkers);
		hashMap.put("center", mapList.get(0).getShopAddr());
		hashMap.put("searchKeyword", searchKeyword);
		
		Gson gson = new Gson();
		gson.toJson(hashMap, response.getWriter());
	}
	
	//D 가게검색 - 화면 출력 +++
	@RequestMapping(value="searchShopView.dz", method=RequestMethod.GET)
	public String searchShopView() {
		return "shop/ShopSearchList";
	}
	
	//D 가게검색 - 테마
	@RequestMapping(value="searchTheme.dz", method=RequestMethod.GET)
	public ModelAndView searchTheme(ModelAndView mv, @RequestParam("themeNo") int themeNo, @RequestParam(value="page", required=false) Integer page) {
		// 파라미터 - 메뉴 클릭시 넘버
		System.out.println(themeNo); // 확인용
		
		String themeWord = "";	
		
		if(themeNo == 1) {
			ArrayList<Integer> sRank = drService.selectReviewRanking(); // 리뷰 랭킹 가져오기 
//			System.out.println("sRank 확인 : " + sRank.toString());
			
			ArrayList<Shop> rankList = sService.selectShopRank(sRank); // 가게번호 이용하여 가게 정보 가져오기 
//			System.out.println("rankList 확인 : " + rankList.toString());
			
			mv.addObject("rankList", rankList);
			mv.addObject("themeNo", themeNo);
			mv.setViewName("shop/ShopSearchResult");
		} else if(themeNo == 3) {
			ArrayList<Shop> newSList = sService.selectNewShop();
			System.out.println("신규가게 : " + newSList); // 확인용
			
			mv.addObject("newSList", newSList);
			mv.addObject("themeNo", themeNo);
			mv.setViewName("shop/ShopSearchResult");
		} else {
			if(themeNo == 2) {
				themeWord = "천안";
			}else if (themeNo == 4) {
				themeWord = "파스타";
			}else if (themeNo == 5) {
				themeWord = "중식";
			}else if (themeNo == 6) {
				themeWord = "명동";
			}else if (themeNo == 7) {
				themeWord = "버거";
			}else if (themeNo == 8) {
				themeWord = "제주";
			}else if (themeNo == 9) {
				themeWord = "카페";
			}else if (themeNo == 10) {
				themeWord = "피자";
			}else if (themeNo == 11) {
				themeWord = "떡볶이";
			}else if (themeNo == 12) {
				themeWord = "초밥";
			}
				System.out.println(themeWord); // 확인용
				
				HashMap<String, String> selectedtheme = new HashMap<String, String>();
				selectedtheme.put("themeWord", themeWord);
				
				int currentPage = (page != null) ? page : 1;
				int listCount = sService.selectShopThemeCount(selectedtheme); 
				PageInfo pi = Pagination.getPageInfo(currentPage, listCount); 
				ArrayList<Shop> themeList = sService.selectShopTheme(pi, selectedtheme);
				System.out.println("테마리스트 : " + themeList);
				
				mv.addObject("pi", pi);
				mv.addObject("themeNo", themeNo);
				mv.addObject("themeList", themeList);
				mv.setViewName("shop/ShopSearchResult");
		}
		
		return mv;
	}
	
	
	//D 가게검색 - 키워드 
	@RequestMapping(value="searchShop.dz", method=RequestMethod.GET)
	public ModelAndView searchShop(ModelAndView mv, @RequestParam("searchKeyword") String searchKeyword, @RequestParam(value="page", required=false)Integer page) {
		// 파라미터 - 유저 입력값
		
		HashMap<String, String> searchedKey = new HashMap<String, String>();
		searchedKey.put("searchKeyword", searchKeyword);
		
		int currentPage = (page != null) ? page : 1; 
		int listCount = sService.searchShopCount(searchedKey); 
		PageInfo pi = Pagination.getPageInfo(currentPage, listCount); 
		ArrayList<Shop> searchList = sService.searchShop(pi, searchedKey);
		
		mv.addObject("pi", pi);
		mv.addObject("sList", searchList);
		mv.addObject("searchKeyword", searchKeyword);
		mv.setViewName("shop/ShopSearchResult");
		
		return mv;
	}
	
	//D 가게 상세 페이지 출력
	@ResponseBody
	@RequestMapping(value="shopDetail.dz")
	public ModelAndView shopDetail(ModelAndView mv, @RequestParam("shopNo") int shopNo, HttpSession session, HttpServletResponse response,  @RequestParam HashMap<String, String> param) throws Exception, Exception {
		// 파라미터 - 가게 번호 (쿼리스트링), 세션 userNo
		
		User user = (User) session.getAttribute("loginUser");
		Pick pick = new Pick();
		if(user != null) {
			// 출력 페이지에서 찜 상태 변경
			HashMap<String, Integer> pickParam = new HashMap<String, Integer>();
			pickParam.put("userNo", user.getUserNo());
			pickParam.put("shopNo", shopNo);
			pick = pService.checkPick(pickParam);
		}
		
		
		// 가게 상세정보 가져오기
		Shop shop = sService.selectShopOne(shopNo);
		// 가게 메인메뉴 가져오기
		ArrayList<MainMenu> mainMenu = sService.selectMainMenu(shopNo);
		// 메뉴 사진 가져오기 
		ArrayList<MenuPhoto> mPhoto = sService.selectMenuPhoto(shopNo);
		
		mv.addObject("shop", shop);
		mv.addObject("mainMenu", mainMenu);
		mv.addObject("mPhoto", mPhoto);
		mv.addObject("pick", pick);
		mv.setViewName("shop/ShopDetail");
		
		return mv;
	}
	
	
	
	// 가게 전체 후기 더보기
	@ResponseBody
	@RequestMapping(value="moreAllReview.dz", method=RequestMethod.GET)
	public void moreAllReview(HttpServletResponse response, @RequestParam("startNum") int startNum, @RequestParam("endNum") int endNum, @RequestParam("shopNo") int shopNo ) throws Exception, IOException {
														// @RequestParam HashMap<String, String> param,
		// 전체 후기 갯수
		int dataCnt = drService.selectDMReviewCount(shopNo);
		System.out.println("전체후기 갯수"+dataCnt);
		
		System.out.println("1. 받음");
		HashMap<String, Object> searchParam = new HashMap<String, Object>(); // 파라미터 생성
		searchParam.put("startNum", startNum);
		searchParam.put("endNum", endNum);
		searchParam.put("shopNo", shopNo);
		
		//searchParam.put("dataCnt", dataCnt); // list 말고 따로 model로?
		
		System.out.println("2. 해쉬 담음");
		// startNum ~ endNum 범위에 해당하는 전체 review 조회
		ArrayList<DreamReview> rList = drService.selectDMReviewAll(searchParam);
		System.out.println("더보기 후기 - "+rList.toString());
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>(); // 컨트롤에 보낼 hash
		resultMap.put("rList", rList);
		resultMap.put("dataCnt", dataCnt);
		
		System.out.println("3. 후기 가져옴");
		response.setContentType("application/json"); // 
		response.setCharacterEncoding("utf-8"); // 데이터 한글 변환
		
		Gson gson = new Gson();
//		gson.toJson(rList, response.getWriter()); // 조회한 전체 리뷰 보내주기,,
		gson.toJson(resultMap, response.getWriter());
		
	}
	
	// 가게 감사 후기 더보기
	@ResponseBody
	@RequestMapping(value="moreDreamReview.dz", method=RequestMethod.GET)
	public void moreDreamReview(HttpServletResponse response, @RequestParam("startNum") int startNum, @RequestParam("endNum") int endNum, @RequestParam("shopNo") int shopNo ) throws Exception, IOException {
														// @RequestParam HashMap<String, String> param,
		// 감사 후기 갯수
		int dataCnt = drService.selectDreamReviewCount(shopNo);
		System.out.println("감사후기 갯수"+dataCnt);
		
		System.out.println("1. 받음");
		HashMap<String, Object> searchParam = new HashMap<String, Object>(); // 파라미터 생성
		searchParam.put("startNum", startNum);
		searchParam.put("endNum", endNum);
		searchParam.put("shopNo", shopNo);
		
		System.out.println("2. 해쉬 담음");
		// startNum ~ endNum 범위에 해당하는 감사 review 조회
		ArrayList<DreamReview> drList = drService.selectAllDreamReview(searchParam);
		System.out.println("더보기 감사 후기 - "+drList.toString());
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>(); // 컨트롤에 보낼 hash
		resultMap.put("drList", drList);
		resultMap.put("dataCnt", dataCnt);
		
		System.out.println("3. 후기 가져옴");
		response.setContentType("application/json"); // 
		response.setCharacterEncoding("utf-8"); // 데이터 한글 변환
		
		Gson gson = new Gson();
		gson.toJson(resultMap, response.getWriter()); // 조회한 감사리뷰 보내주기,,
		
	}
	
	// 가게 맛집 후기 더보기
		@ResponseBody
		@RequestMapping(value="moreMzReview.dz", method=RequestMethod.GET)
		public void moreMzReview(HttpServletResponse response, @RequestParam("startNum") int startNum, @RequestParam("endNum") int endNum, @RequestParam("shopNo") int shopNo ) throws Exception, IOException {
															// @RequestParam HashMap<String, String> param,
			// 맛집 후기 갯수
			int dataCnt = mService.selectMzReviewCount(shopNo);
			System.out.println("맛집후기 갯수"+dataCnt);
			
			System.out.println("1. 받음");
			HashMap<String, Object> searchParam = new HashMap<String, Object>(); // 파라미터 생성
			searchParam.put("startNum", startNum);
			searchParam.put("endNum", endNum);
			searchParam.put("shopNo", shopNo);
			
			System.out.println("2. 해쉬 담음");
			// startNum ~ endNum 범위에 해당하는 감사 review 조회
			ArrayList<MzReview> mzList = mService.selectAllMzReview(searchParam);
			System.out.println("더보기 감사 후기 - "+mzList.toString());
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>(); // 컨트롤에 보낼 hash
			resultMap.put("mzList", mzList);
			resultMap.put("dataCnt", dataCnt);
			
			System.out.println("3. 후기 가져옴");
			response.setContentType("application/json"); // 
			response.setCharacterEncoding("utf-8"); // 데이터 한글 변환
			
			Gson gson = new Gson();
			gson.toJson(resultMap, response.getWriter()); // 조회한 감사리뷰 보내주기,,
			
			
		}
	
}