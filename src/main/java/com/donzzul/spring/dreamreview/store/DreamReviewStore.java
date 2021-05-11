package com.donzzul.spring.dreamreview.store;

import java.util.ArrayList;

import com.donzzul.spring.dreamreview.domain.DreamReview;

public interface DreamReviewStore {
	public ArrayList<DreamReview> selectAllDreamReview();
	public DreamReview selectOneDreamReview(int dReviewNo);
	public int insertDreamReview(DreamReview dreamReview);
	public int updateDreamReview(DreamReview dreamReview);
	public int deleteDreamReview(int dReviewNo);
	public ArrayList<DreamReview> selectAllDreamReview(int shopNo);
}
