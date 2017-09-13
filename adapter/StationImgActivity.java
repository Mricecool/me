package com.gogowan.petrochina.context;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.Toast;

import com.gogowan.petrochina.R;
import com.gogowan.petrochina.adapter.GridImgAdapter;
import com.gogowan.petrochina.base.BaseActivity;
import com.gogowan.petrochina.base.PalUtils;
import com.gogowan.petrochina.base.TitleActivity;
import com.gogowan.petrochina.bean.EnterpriseOperateRequest;
import com.gogowan.petrochina.bean.ImageItem;
import com.gogowan.petrochina.bean.LoginResult;
import com.gogowan.petrochina.bean.StationImage;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 图片选择
 * Created by app on 2017/9/11.
 */
public class StationImgActivity extends TitleActivity {

    private LoginResult mLoginResult;
    private GridImgAdapter gridImgAdapter;
    private GridView gridView;
    private int mWidth;
    private static final int PHOTO_SELECT = 0x1000;
    private int maxNum = 9;
    private Button btnOk;
    private int type = -1;
    private boolean isChange = false;
    /**
     * 本次选择图片目录
     */
    private ArrayList<String> selectListPath = new ArrayList<String>();
    /**
     * 临时存储位置
     */
    public static final String STORAGE = "com.gogowan.petrochina";
    /**
     * 图片保存根目录
     */
    private String rootPath = Environment.getExternalStorageDirectory()
            + "/" + STORAGE;
    private ArrayList<StationImage> sourceData = null;
    private ArrayList<StationImage> targetData = null;
    private long orgId = -1;

    @Override
    protected int setContentViewId() {
        return R.layout.img_select;
    }

    @Override
    protected boolean initData(Intent intent, Bundle savedInstanceState) {
        mLoginResult = PalUtils.getLoginResult(getApplicationContext());
//        mEnterpriseOperateRequest = (EnterpriseOperateRequest) intent.getSerializableExtra("IMG_LIST");
//        if (mEnterpriseOperateRequest != null && mEnterpriseOperateRequest.getImageList() != null && mEnterpriseOperateRequest.getImageList().size() > 0) {
//            sourceData.addAll(mEnterpriseOperateRequest.getImageList());
//            targetData.addAll(mEnterpriseOperateRequest.getImageList());
//        }
        sourceData = (ArrayList<StationImage>) intent.getSerializableExtra("source");
        targetData = (ArrayList<StationImage>) intent.getSerializableExtra("upload");
        orgId = intent.getLongExtra("orgId", orgId);
        type = intent.getIntExtra("type", type);
        return mLoginResult != null;
    }

    @Override
    protected void initView(Bundle savedInstanceState) {

        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        mWidth = dm.widthPixels;
        setTitle("站点图片", false);
        btnOk = (Button) findViewById(R.id.btn_ok);
        btnOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.putExtra("source", sourceData);
                //删除新增按钮
                targetData.remove(targetData.size() - 1);
                intent.putExtra("target", targetData);
                intent.putExtra("isChange", isChange);
                setResult(RESULT_OK, intent);
                finish();
            }
        });
        gridView = (GridView) findViewById(R.id.grid_img);
//        if (targetData.size() > 0) {
//            for (StationImage stationImage : targetData) {
//                stationImage.setImageUrl(PalUtils.REQUEST_URI + stationImage.getImageUrl());
//            }
//        }
        //默认添加按钮
        targetData.add(new StationImage(0, 0, "add", 0));
        gridImgAdapter = new GridImgAdapter(StationImgActivity.this, targetData, mWidth);
        //添加
        gridImgAdapter.setOnAddItemListener(new GridImgAdapter.AddItemClickListener() {
            @Override
            public void OnAddItemClick() {
                selectImage();
            }
        });
        //删除
        gridImgAdapter.setOnRemoveItemListener(new GridImgAdapter.RemoveItemClickListener() {
            @Override
            public void OnRemoveItemClick(int position) {
                if (sourceData != null && sourceData.size() > 0) {
                    //修改原数据中类型值
                    for (StationImage stationImage : sourceData) {
                        if (stationImage.getImageId() == targetData.get(position).getImageId()) {
                            stationImage.setOperatorType(2);
                            isChange = true;
                        }
                    }
                }
                //直接删除该项
                targetData.remove(position);
                gridImgAdapter.notifyDataSetChanged();
            }
        });
        gridImgAdapter.setItemClickListener(new GridImgAdapter.ItemClickListener() {
            @Override
            public void OnItemClick(View v, int position) {
                startPhotoActivity(StationImgActivity.this, (ImageView) v, position);
            }
        });
        gridView.setAdapter(gridImgAdapter);
    }

    @Override
    protected void onClicked(View v) {

    }

    @Override
    protected void handleMessage(BaseActivity activity, Message msg) {

    }

    public void selectImage() {
        String sdStatus = Environment.getExternalStorageState();
        if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) { // 检测sd是否可用
            PalUtils.showShortToast(getApplicationContext(), getString(R.string.no_permission_storage));
            return;
        }

        if (!PalUtils.isGrantExternalRW(StationImgActivity.this)) {
            PalUtils.showShortToast(getApplicationContext(), getString(R.string.no_permission_storage));
            return;
        }

        Intent intent = new Intent(StationImgActivity.this, MultiImageSelectorActivity.class);
        /**
         *  是否显示拍摄图片  true：显示  false：不显示
         */
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, true);
        // 最大可选择图片数量 1-9
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, maxNum - targetData.size() + 1);
        /**
         * 选择模式
         * 单选： MultiImageSelectorActivity.MODE_SINGLE
         * 多选： MultiImageSelectorActivity.MODE_MULTI;
         */
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, MultiImageSelectorActivity.MODE_MULTI);
        startActivityForResult(intent, PHOTO_SELECT);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                //选图
                case PHOTO_SELECT:
                    selectListPath = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
                    File file = new File(rootPath);
                    if (!file.exists()) {
                        file.mkdirs();
                    }
                    //删除添加按钮
                    if (targetData.size() > 0) {
                        targetData.remove(targetData.size() - 1);
                    }
                    for (String item : selectListPath) {
                        if (type == 1) {
                            //如果没有企业信息，则为新增加油站
                            targetData.add(new StationImage(0, 0, item, 1));
                        } else {
                            //修改加油站
                            targetData.add(new StationImage(0, orgId, item, 1));
                        }
                    }
                    //添加新增按钮
                    targetData.add(new StationImage(0, 0, "add", 0));
                    gridImgAdapter.notifyDataSetChanged();
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * 看图
     */
    public void startPhotoActivity(Context context, ImageView imageView, int position) {
        ArrayList<String> picList = new ArrayList<>();
//        for (StationImage item : targetData) {
//            picList.add(item.getImageUrl());
//        }
        if (targetData.get(position).getImageId() != 0) {
            picList.add((PalUtils.REQUEST_URI + targetData.get(position).getImageUrl()));
        } else {
            picList.add(targetData.get(position).getImageUrl());
        }

        Intent intent = new Intent(context, DragPhotoActivity.class);
        int location[] = new int[2];
        imageView.getLocationOnScreen(location);
        intent.putExtra("left", location[0]);
        intent.putExtra("top", location[1]);
        intent.putExtra("height", imageView.getHeight());
        intent.putExtra("width", imageView.getWidth());
        intent.putExtra(PalUtils.TYPE_ITT, position);
        intent.putExtra(PalUtils.MODEL_ITT, picList);
        context.startActivity(intent);
        overridePendingTransition(0, 0);
    }
}
