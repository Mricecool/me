package com.gogowan.petrochina.adapter;

import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.BitmapDrawable;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.gogowan.petrochina.R;
import com.gogowan.petrochina.bean.AupImage;
import com.gogowan.petrochina.bean.ImageItem;

import java.util.HashMap;
import java.util.List;

import me.nereo.multi_image_selector.bean.Image;

/**
 * 未复用view,复用view时，EditText的TextWatcher监听出现问题，待优化
 * 图片item，最多10条
 * Created by app on 2017/8/14.
 */
public class ImageItemAdapter extends BaseAdapter {

    private Context context;
    private List<ImageItem> data;
    private ViewHolder viewHolder;
    private View.OnClickListener onClickListener;
    private String[] imageType = new String[]{"票据", "竞争对手情报"};
    //图片类型
    private PopupWindow popImage;
    private int pop;
    private int index;

    public ImageItemAdapter(Context context, List<ImageItem> data, View.OnClickListener onClickListener) {
        this.context = context;
        this.data = data;
        this.onClickListener = onClickListener;
        initImageType();
    }

    @Override
    public int getCount() {
        return data != null ? data.size() : 0;
    }

    @Override
    public Object getItem(int position) {
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        convertView = LayoutInflater.from(context).inflate(R.layout.layout_image_item, null);
        viewHolder = new ViewHolder();
        viewHolder.txtImageType = (TextView) convertView.findViewById(R.id.txt_image_type);
        viewHolder.itemImage = (ImageView) convertView.findViewById(R.id.itemImage);
        viewHolder.itemEdit = (EditText) convertView.findViewById(R.id.itemContent);
        viewHolder.itemDel = (TextView) convertView.findViewById(R.id.itemDel);

        Glide.with(context)
                .load(data.get(position).getImageUrl())
                .error(R.drawable.img_failed)
                .into(viewHolder.itemImage);

        viewHolder.itemImage.setTag(position);
        viewHolder.itemImage.setOnClickListener(onClickListener);

        viewHolder.itemDel.setTag(position);
        viewHolder.itemDel.setOnClickListener(onClickListener);
        if (data.get(position).getImageType() == 1) {
            viewHolder.txtImageType.setText(imageType[0]);
        } else {
            viewHolder.txtImageType.setText(imageType[1]);
        }
        viewHolder.txtImageType.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pop = position;
                popImage.showAsDropDown(v, 0, -1);
            }
        });
        viewHolder.itemEdit.setText(data.get(position).getImageMs());
        viewHolder.itemEdit.setTag(position);
        viewHolder.itemEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                data.get(position).setImageMs(s.toString());
            }
        });
        return convertView;
    }

    public final class ViewHolder {
        private TextView txtImageType;
        private ImageView itemImage;
        private EditText itemEdit;
        private TextView itemDel;
    }

    //初始化图片
    private void initImageType() {
        View view = LayoutInflater.from(context).inflate(
                R.layout.pop_select_com, null);
        popImage = new PopupWindow(view,
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        popImage.setFocusable(true);
        popImage.setOutsideTouchable(true);
        popImage.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        popImage.setInputMethodMode(PopupWindow.INPUT_METHOD_FROM_FOCUSABLE);
        popImage.setBackgroundDrawable(new BitmapDrawable());

        ListView lv = (ListView) view.findViewById(R.id.login_user_window_list);
        ArrayAdapter adapter = new ArrayAdapter(context, R.layout.item_select_com, R.id.select_com_tv, imageType);
        lv.setAdapter(adapter);
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                switch (position) {
                    case 0:
                        data.get(pop).setImageType(1);
                        break;
                    case 1:
                        data.get(pop).setImageType(2);
                        break;
                }
                popImage.dismiss();
                ImageItemAdapter.this.notifyDataSetChanged();
            }
        });
    }
}
