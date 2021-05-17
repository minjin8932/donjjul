package com.donzzul.spring.payment.service.logic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.donzzul.spring.payment.service.PaymentService;
import com.donzzul.spring.payment.store.PaymentStore;
import com.donzzul.spring.user.domain.User;

@Service
public class PaymentServiceImpl implements PaymentService{

	@Autowired
	private PaymentStore store;

	
	@Override
	public int usePoint(User user) { // 포인트 사용
		int result = store.updatePoint(user);
		return result;
	}

	@Override
	public String selectMyPoint(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int saveRoulettePoint(User user) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveReviewPoint(User user) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertDonList(User user) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String selectDonList(User user) {
		// TODO Auto-generated method stub
		return null;
	}


}
