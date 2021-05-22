package com.donzzul.spring.notiqna.service.logic;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.donzzul.spring.common.PageInfo;
import com.donzzul.spring.notiqna.domain.Qna;
import com.donzzul.spring.notiqna.service.QnaService;
import com.donzzul.spring.notiqna.store.QnaStore;

@Service
public class QnaServiceImpl implements QnaService{

	@Autowired
	private QnaStore qnaStore;

	@Override
	public int getListCount() {
		return qnaStore.getListCount();
	}
	
	@Override
	public ArrayList<Qna> selectAllQna() {
		return qnaStore.selectAllQna();
	}
	
	@Override
	public ArrayList<Qna> selectAllQna(PageInfo pi) {
		return qnaStore.selectAllQna(pi);
	}

	@Override
	public Qna selectOneQna(int qaNo) {
		return qnaStore.selectOneQna(qaNo);
	}

	@Override
	public int insertQna(Qna qna) {
		return qnaStore.insertQna(qna);
	}
	
	@Override
	public int updateGroup(Qna qna) {
		return qnaStore.updateGroup(qna);
	}

	@Override
	public int updateQna(Qna qna) {
		return qnaStore.updateQna(qna);
	}

	@Override
	public int deleteQna(int qaNo) {
		return qnaStore.deleteQna(qaNo);
	}






	
	
}
