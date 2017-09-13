package com.gogowan.petrochina.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.gogowan.petrochina.R;
import com.gogowan.petrochina.base.PalUtils;
import com.gogowan.petrochina.base.ToastUtils;
import com.gogowan.petrochina.bean.ImageItem;
import com.gogowan.petrochina.bean.StationImage;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by app on 2017/9/11.
 */
public class GridImgAdapter extends BaseAdapter {

    private Context context;
    private List<StationImage> data;
    private ViewHolder viewHolder;
    private int width;
    private RelativeLayout.LayoutParams params = null;
    private AddItemClickListener addItemClickListener;
    private RemoveItemClickListener removeItemListener;
    private ItemClickListener itemClickListener;

    public GridImgAdapter(Context context, List<StationImage> data, int width) {
        this.context = context;
        this.data = data;
        params = new RelativeLayout.LayoutParams(width / 3, width / 3);
    }

    public void setOnAddItemListener(AddItemClickListener addItemListener) {
        this.addItemClickListener = addItemListener;
    }

    public void setOnRemoveItemListener(RemoveItemClickListener removeItemListener) {
        this.removeItemListener = removeItemListener;
    }

    public void setItemClickListener(ItemClickListener itemClickListener) {
        this.itemClickListener = itemClickListener;
    }

    @Override
    public int getCount() {
        return data.size();
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
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.img_select_item, null);
            viewHolder = new ViewHolder();
            viewHolder.itemImage = (ImageView) convertView.findViewById(R.id.img);
            viewHolder.itemDel = (ImageView) convertView.findViewById(R.id.img_del);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.itemImage.setLayoutParams(params);
        //if ("add".equals(data.get(position).getImageUrl())) {
        if ((position == data.size() - 1)) {
            viewHolder.itemDel.setVisibility(View.GONE);
            Glide.with(context)
                    .load(R.drawable.image_add)
                    .error(R.drawable.img_failed)
                    .into(viewHolder.itemImage);
            viewHolder.itemImage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    addItemClickListener.OnAddItemClick();
                }
            });
            if (data.size() > 9) {
                viewHolder.itemImage.setVisibility(View.GONE);
            } else {
                viewHolder.itemImage.setVisibility(View.VISIBLE);
            }
        } else {
            viewHolder.itemDel.setVisibility(View.VISIBLE);
            viewHolder.itemDel.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    removeItemListener.OnRemoveItemClick(position);
                }
            });
            if (data.get(position).getImageId() != 0) {
                Glide.with(context)
                        .load(PalUtils.REQUEST_URI + data.get(position).getImageUrl())
                        .error(R.drawable.img_failed)
                        .centerCrop()
                        .into(viewHolder.itemImage);
            } else {
                Glide.with(context)
                        .load(data.get(position).getImageUrl())
                        .error(R.drawable.img_failed)
                        .centerCrop()
                        .into(viewHolder.itemImage);
            }

            viewHolder.itemImage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    itemClickListener.OnItemClick(v, position);
                }
            });
        }


        return convertView;
    }

    public final class ViewHolder {
        private ImageView itemImage;
        private ImageView itemDel;
    }

    public interface AddItemClickListener {
        void OnAddItemClick();
    }

    public interface RemoveItemClickListener {
        void OnRemoveItemClick(int position);
    }

    public interface ItemClickListener {
        void OnItemClick(View v, int position);
    }
}
