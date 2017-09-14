package com.gogowan.petrochina.adapter.abslistview;

import android.content.Context;
import android.support.annotation.IdRes;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

/**
 * 复用的是View(即ConvertView)及其Tag(即ViewHolder),而不是Data
 */
public class ViewHolder<T> {

    /**
     * ConvertView == null时的缓存存取
     * */
    private SparseArray<View> mViews;
    private View mConvertView;
    private int mConvertViewType;

    public ViewHolder(Context context, ViewGroup parent, int layoutId) {
        mViews = new SparseArray<>();
        mConvertView = LayoutInflater.from(context).inflate(layoutId, parent, false);
        mConvertViewType = layoutId;
        mConvertView.setTag(this);
    }

    /**
     * 获取ViewHolder的实例
     *
     * @param context     上下文
     * @param convertView 布局
     * @param parent      父布局
     * @param layoutId    布局ID
     * @return ViewHolder实例
     */
    public static ViewHolder getInstance(Context context, View convertView, ViewGroup parent, int layoutId) {
        if (convertView == null) {
            return new ViewHolder(context, parent, layoutId);
        } else {
            return (ViewHolder) convertView.getTag();
        }
    }

    /**
     * 通过View的id从缓存获取子View 没有(即无TAG时,即convertView == null时,即无法复用View时)则新建并加入缓存
     *
     * @param viewId view的id
     * @param <T>   泛型
     * @return 子View
     */
    public <T extends View> T getView(int viewId) {
        View view = mViews.get(viewId);
        //如果该View没有缓存过，则查找View并缓存
        if (view == null) {
            view = mConvertView.findViewById(viewId);
            mViews.put(viewId, view);
        }
        return (T) view;
    }

    /**
     * 获取布局View
     *
     * @return 布局View
     */
    public View getConvertView() {
        return mConvertView;
    }

    /**
     * 获取布局ViewType
     *
     * @return 布局View
     */
    public int getConvertViewType() {
        return mConvertViewType;
    }

    /**
     * TextView赋值
     * */
    public void setTextView(@IdRes int textViewId, String content){
        ((TextView)this.getView(textViewId)).setText(content);
    }
}