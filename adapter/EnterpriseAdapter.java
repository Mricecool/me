package com.gogowan.petrochina.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import com.gogowan.petrochina.R;
import com.gogowan.petrochina.bean.EnterpriseOperateRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by app on 2017/9/13.
 */
public class EnterpriseAdapter extends BaseAdapter implements Filterable {

    private Context context;
    //原数据
    private List<EnterpriseOperateRequest> data;
    //临时数据，会改变
    private List<EnterpriseOperateRequest> tempdata;
    private ViewHolder viewHolder;
    private MyFilter mFilter ;

    public EnterpriseAdapter(Context context, List<EnterpriseOperateRequest> data) {
        this.context = context;
        this.data = data;
        this.tempdata=data;
    }

    @Override
    public int getCount() {
        return tempdata.size();
    }

    @Override
    public Object getItem(int position) {
        return tempdata.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_enterprise, null);
            viewHolder = new ViewHolder();
            viewHolder.txtEnterprise = (TextView) convertView.findViewById(R.id.txtEnterprise);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.txtEnterprise.setText(tempdata.get(position).getGasStation());
        return convertView;
    }

    public final class ViewHolder {
        private TextView txtEnterprise;
    }

    //当ListView调用setTextFilter()方法的时候，便会调用该方法
    @Override
    public Filter getFilter() {
        if (mFilter ==null){
            mFilter = new MyFilter();
        }
        return mFilter;
    }

    //我们需要定义一个过滤器的类来定义过滤规则
    class MyFilter extends Filter {
        //我们在performFiltering(CharSequence charSequence)这个方法中定义过滤规则
        @Override
        protected FilterResults performFiltering(CharSequence charSequence) {
            FilterResults result = new FilterResults();
            List<EnterpriseOperateRequest> list ;
            if (TextUtils.isEmpty(charSequence)){//当过滤的关键字为空的时候，我们则显示所有的数据
                list  = data;
            }else {//否则把符合条件的数据对象添加到集合中
                list = new ArrayList<>();
                for (EnterpriseOperateRequest item:data){
                    if (item.getGasStation().contains(charSequence)){
                        list.add(item);
                    }
                }
            }
            result.values = list; //将得到的集合保存到FilterResults的value变量中
            result.count = list.size();//将集合的大小保存到FilterResults的count变量中

            return result;
        }
        //在publishResults方法中告诉适配器更新界面
        @Override
        protected void publishResults(CharSequence charSequence, FilterResults filterResults) {
            tempdata = (List<EnterpriseOperateRequest>)filterResults.values;
            if (filterResults.count>0){
                notifyDataSetChanged();//通知数据发生了改变
            }else {
                notifyDataSetInvalidated();//通知数据失效
            }
        }
    }
}
