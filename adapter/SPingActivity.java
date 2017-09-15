package com.gogowan.petrochina.context;

import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.android.volley.manager.LoadController;
import com.android.volley.manager.RequestManager;
import com.gogowan.petrochina.R;
import com.gogowan.petrochina.adapter.EnterpriseAdapter;
import com.gogowan.petrochina.adapter.EnterpriseSelectAdapter;
import com.gogowan.petrochina.base.BaseActivity;
import com.gogowan.petrochina.base.PalUtils;
import com.gogowan.petrochina.base.TitleActivity;
import com.gogowan.petrochina.bean.EnterpriseOperateRequest;
import com.gogowan.petrochina.bean.GasPriceRequest;
import com.gogowan.petrochina.bean.GasPriceResult;
import com.gogowan.petrochina.bean.GetEnterpriseInfoRequest;
import com.gogowan.petrochina.bean.GetEnterpriseInfoResult;
import com.gogowan.petrochina.bean.GetOperateInfoRequest;
import com.gogowan.petrochina.bean.GetOperateInfoResult;
import com.gogowan.petrochina.bean.LoginResult;
import com.gogowan.petrochina.bean.MsgType;
import com.gogowan.petrochina.bean.ResultInfo;
import com.gogowan.petrochina.custom.LoadingLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 审批中
 * Created by app on 2017/9/13.
 */
public class SPingActivity extends TitleActivity implements RequestManager.RequestListener {

    private static final int REQUEST_SEL_DATA_GET = 0;//获取地市级数据
    private static final int REQUEST_DATA_GET = 1;//获取加油站数据
    //登录信息
    private LoginResult mLoginResult;
    private LoadController mLoadController;
    private LoadingLayout loadingLayout;
    private ListView lv;
    //加油站
    private EnterpriseAdapter enterpriseAdapter;
    //地市级
    private EnterpriseSelectAdapter enterpriseSelectAdapter;
    private EditText search;
    private PopupWindow popupSel;
    private Button btnSel;

    //组织ID
    private long orgId;
    //地市级列表
    private List<EnterpriseOperateRequest> selList = new ArrayList<>();
    //加油站列表
    private List<EnterpriseOperateRequest> list = new ArrayList<>();

    @Override
    protected int setContentViewId() {
        return R.layout.sp_ing;
    }

    @Override
    protected boolean initData(Intent intent, Bundle savedInstanceState) {
        mLoginResult = PalUtils.getLoginResult(getApplicationContext());
        return mLoginResult != null;
    }

    @Override
    protected void initView(Bundle savedInstanceState) {
        setTitle("审批中", false);
        loadingLayout = getView(R.id.loadingLayout);
        loadingLayout.setReplacedView(findViewById(R.id.main));
        btnSel = getView(R.id.btnSel);
        btnSel.setOnClickListener(this);
        lv = getView(R.id.lv);
        lv.setTextFilterEnabled(true); // 开启过滤功能
        enterpriseAdapter = new EnterpriseAdapter(SPingActivity.this, list);
        lv.setAdapter(enterpriseAdapter);
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent i = new Intent(SPingActivity.this, SPingListActivity.class);
                i.putExtra("data", list.get(position));
                startActivity(i);
            }
        });
        search = getView(R.id.search);
        search.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int start, int before, int count) {
                if (TextUtils.isEmpty(charSequence.toString().trim()))
                    lv.clearTextFilter();//搜索文本为空时，清除ListView的过滤
                else
                    lv.setFilterText(charSequence.toString().trim());//设置过滤关键字
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });


        orgId = mLoginResult.getEnterpriseOperateID();
        if (mLoginResult.getEOLevel() == 1) {
            //省级登录
            initSelPopup();
            btnSel.setVisibility(View.VISIBLE);
            getView(R.id.main).setVisibility(View.GONE);
            requestInfo(REQUEST_SEL_DATA_GET, orgId);
        } else {
            //市级登录
            btnSel.setVisibility(View.GONE);
            requestStationInfo(REQUEST_DATA_GET, orgId);
        }
    }

    private void initSelPopup() {
        View view = getLayoutInflater().inflate(
                R.layout.pop_select_adjust, null);
        popupSel = new PopupWindow(view,
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        popupSel.setFocusable(true);
        popupSel.setOutsideTouchable(true);
        popupSel.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        popupSel.setInputMethodMode(PopupWindow.INPUT_METHOD_FROM_FOCUSABLE);
        popupSel.setBackgroundDrawable(new BitmapDrawable());

        ListView lv = (ListView) view.findViewById(R.id.login_user_window_list);
        enterpriseSelectAdapter = new EnterpriseSelectAdapter(this, selList);
        lv.setAdapter(enterpriseSelectAdapter);
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                btnSel.setText(selList.get(position).getGasStation());
                orgId = selList.get(position).getID();
                requestStationInfo(REQUEST_DATA_GET, orgId);
                popupSel.dismiss();
            }
        });
    }

    /**
     * 获取组织机构信息
     */
    private void requestInfo(int requestType, long ordId) {
        //loadingLayout.show();
        GetOperateInfoRequest request = new GetOperateInfoRequest();
        request.setOrgainzeID(ordId);
        String messageStr = PalUtils.getRequest(request, MsgType.GetOrgInfo);
        mLoadController = RequestManager.getInstance().post(MsgType.REQUEST_URL,
                messageStr, this, requestType);
    }

    /**
     * 获取组织机构信息
     */
    private void requestStationInfo(int requestType, long ordId) {
        loadingLayout.show();
        GetOperateInfoRequest request = new GetOperateInfoRequest();
        request.setOrgainzeID(ordId);
        String messageStr = PalUtils.getRequest(request, MsgType.GetStationInfo);
        mLoadController = RequestManager.getInstance().post(MsgType.REQUEST_URL,
                messageStr, this, requestType);
    }

    @Override
    protected void onClicked(View v) {
        switch (v.getId()) {
            case R.id.btnSel:
                popupSel.showAsDropDown(v, 0, 0);
                break;
        }
    }

    @Override
    protected void handleMessage(BaseActivity activity, Message msg) {

    }

    @Override
    public void onRequest() {

    }

    @Override
    public void onSuccess(String response, Map<String, String> headers, String url, int actionId) {
        hideDialogProgress();
        if (PalUtils.isEmpty(response)) {
            PalUtils.showShortToast(getApplicationContext(), getString(R.string.connect_error));
        } else {
            switch (actionId) {
                //加油站数据
                case REQUEST_DATA_GET:
                    GetOperateInfoResult result = (GetOperateInfoResult) PalUtils.getResponse(response, GetOperateInfoResult.class);
                    if (result != null && result.getResult() >= 0) {
                        list.clear();
                        list.addAll(result.getStationModelList());
                        enterpriseAdapter.notifyDataSetChanged();
                        if (list.size() > 0) {
                            loadingLayout.hide();
                        } else {
                            loadingLayout.showNull(new LoadingLayout.OnNullClickListener() {
                                @Override
                                public void onClick() {
                                    requestStationInfo(REQUEST_DATA_GET, orgId);
                                }
                            });
                        }
                    } else {
                        loadingLayout.showReload(new LoadingLayout.OnReloadClickListener() {
                            @Override
                            public void onClick() {
                                requestStationInfo(REQUEST_DATA_GET, orgId);
                            }
                        });
                    }
                    break;
                //地市级数据
                case REQUEST_SEL_DATA_GET:
                    GetOperateInfoResult resultSel = (GetOperateInfoResult) PalUtils.getResponse(response, GetOperateInfoResult.class);
                    if (resultSel != null && resultSel.getResult() >= 0) {
                        selList.clear();
                        selList.addAll(resultSel.getStationModelList());
                        enterpriseSelectAdapter.notifyDataSetChanged();
                        if (selList.size() > 0) {
                            //loadingLayout.hide();
                        } else {
                            loadingLayout.showNull(new LoadingLayout.OnNullClickListener() {
                                @Override
                                public void onClick() {
                                    requestInfo(REQUEST_SEL_DATA_GET, orgId);
                                }
                            });
                        }
                    } else {
                        loadingLayout.showReload(new LoadingLayout.OnReloadClickListener() {
                            @Override
                            public void onClick() {
                                requestInfo(REQUEST_SEL_DATA_GET, orgId);
                            }
                        });
                    }
                    break;
            }
        }
    }

    @Override
    public void onError(String errorMsg, String url, int actionId) {
        hideDialogProgress();
        switch (actionId) {
            case REQUEST_DATA_GET:
                loadingLayout.showReload(new LoadingLayout.OnReloadClickListener() {
                    @Override
                    public void onClick() {
                        requestStationInfo(REQUEST_DATA_GET, orgId);
                    }
                });
                break;
            case REQUEST_SEL_DATA_GET:
                loadingLayout.showReload(new LoadingLayout.OnReloadClickListener() {
                    @Override
                    public void onClick() {
                        requestInfo(REQUEST_SEL_DATA_GET, orgId);
                    }
                });
                break;
            default:
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mLoadController != null) {
            mLoadController.cancel();
        }
    }
}
