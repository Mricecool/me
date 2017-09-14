package com.gogowan.petrochina.adapter.abslistview;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * AbsListView 的通用适配器抽象类(单一布局Id)
 */
public abstract class AbsListAdapter<T> extends BaseAdapter {

    protected Context mContext;
    private List<T> mDataList = new ArrayList<>();
    private int mLayoutId;

    /**
     * @param context  上下文
     * @param dataList 数据集
     * @param layoutId 布局ID
     */
    public AbsListAdapter(Context context, List<T> dataList, int layoutId) {
        mContext = context;
        mLayoutId = layoutId;
        mDataList = dataList;
    }

    /**
     * （数据已绑定）
     */
    public void addDataList(List<T> dataList) {
        mDataList.addAll(dataList);
        notifyDataSetChanged();
    }

    /**
     * （数据已绑定）
     */
    public void refreshDataList(List<T> dataList) {
        mDataList = dataList;
        notifyDataSetChanged();
    }

    /**
     * （数据已绑定）
     */
    public void clearDataList() {
        mDataList.clear();
        notifyDataSetChanged();
    }

    /**
     * （数据已绑定）
     *
     * @param index
     */
    public void removeData(int index) {
        if (null != mDataList && mDataList.size() > index && index > -1) {
            mDataList.remove(index);
            notifyDataSetChanged();
        }
    }

    /**
     * （数据已绑定）支持换内存地址
     */
    public void setDataList(List<T> dataList) {
        mDataList = dataList;
    }

    public List<T> getDataList() {
        return mDataList;
    }

    @Override
    public int getCount() {
        return mDataList.size();
    }

    @Override
    public T getItem(int position) {
        if (position > -1 && null != mDataList && mDataList.size() > position) {
            return mDataList.get(position);
        }
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //实例化一个ViewHolder
        ViewHolder viewHolder = ViewHolder.getInstance(mContext, convertView, parent, mLayoutId);
        //需要自定义的部分
        onBindViewHolder(position, viewHolder, getItem(position));
        return viewHolder.getConvertView();
    }

    /**
     * 需要处理的部分，在这里给View设置值
     *
     * @param viewHolder ViewHolder
     * @param data       数据集
     */
    public abstract void onBindViewHolder(int position, ViewHolder viewHolder, T data);
}