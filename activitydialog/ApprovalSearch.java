package com.gogowan.petrochina.context;

import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;

import com.gogowan.petrochina.R;
import com.gogowan.petrochina.base.BaseActivity;
import com.gogowan.petrochina.base.PalUtils;
import com.gogowan.petrochina.base.TitleActivity;

/**
 * 审批查询
 * Created by app on 2017/9/12.
 */
public class ApprovalSearch extends TitleActivity {


    @Override
    protected int setContentViewId() {
        return R.layout.approval_search;
    }

    @Override
    protected boolean initData(Intent intent, Bundle savedInstanceState) {
        overridePendingTransition(R.anim.dialog_in, R.anim.dialog_out);
        return true;
    }

    @Override
    protected void initView(Bundle savedInstanceState) {

    }

    @Override
    protected void onClicked(View v) {

    }

    @Override
    protected void handleMessage(BaseActivity activity, Message msg) {

    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return close();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            return close();
        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * 关闭
     */
    private boolean close() {
        finish();
        overridePendingTransition(R.anim.dialog_in,
                R.anim.dialog_out);
        return true;
    }

    @Override
    protected void onPause() {
        super.onPause();
        PalUtils.hideSoftInput(this);
    }
}
