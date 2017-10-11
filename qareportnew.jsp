<%--
  Created by IntelliJ IDEA.
  User: app
  Date: 2017/1/16
  Time: 13:49
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>质检报告管理</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" type="text/css" href="${ctx}/content/css/common.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/content/css/style.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/content/lib/webuploader/webuploader.css">

    <link rel="stylesheet" href="${ctx}/content/lib/bootstrap-3.3.0/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/content/lib/bootstrap-table/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/content/lib/bootstrap-validator/bootstrapValidator.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/content/css/my_dialog.css">
    <link rel="stylesheet" type="text/css"
          href="${ctx}/content/lib/bootstrap-datepicker-master/css/bootstrap-datepicker.css">
    <style>
        select {
            /*很关键：将默认的select选择框样式清除*/
            appearance: none;
            -moz-appearance: none;
            -webkit-appearance: none;
            /*在选择框的最右侧中间显示小箭头图片*/
            /*为下拉小箭头留出一点位置，避免被文字覆盖*/
            padding-right: 14px;
        }

        /*清除ie的默认选择框样式清除，隐藏下拉箭头*/
        select::-ms-expand {
            display: none;
        }
    </style>
</head>
<body>
<div>
    <div class="main_hd clearfix">
        <ul class="breadcrumb">
            <li class="icofont-home"><span class="dqwz">当前位置</span></li>
            <li>质检报告管理</li>
        </ul>
    </div>
    <div class="content clearfix">
        <div class="col-sm-2"
             style="padding: 0;height: 520px; border: 1px solid #dfdfdf;overflow-y:scroll; width: 20%;">
            <c:if test="${sessionScope.get('loginInfo').roleEntityList[0].roleType==3}">
                <label style="color: red; margin-top: 10px; margin-left: 10px; font-size: 14px;">选择种类后可添加质检报告</label>
            </c:if>
            <div id="tree"></div>
        </div>
        <div class="col-sm-10" style="padding-left: 5px; width: 80%">
            <div style="margin-bottom: 5px; margin-top: 5px;">
                <label style=" font-size: 14px; margin-bottom: 0px;">当前选择：</label>
                <label style=" font-size: 14px; margin-bottom: 0px;" id="lblSelect"></label>
            </div>
            <!-- 添加查询出来的table -->
            <c:if test="${(sessionScope.get('loginInfo').roleEntityList[0].roleType==3)}">
                <div style="margin-bottom: 5px;margin-right:10px;float: left">
                    <button type="button" id="addReport" onclick="addReport()" class="btn btn-primary">添加质检报告</button>
                </div>
            </c:if>
            <button type="button" id="searchUnit" onclick="searchUnit()" class="btn btn-primary"
                    style="margin-bottom: 5px;margin-right:10px;float: left">查 询
            </button>
            <button type="button" id="searchClear" onclick="searchClear()" class="btn btn-primary"
                    style="display: none;margin-bottom: 5px;margin-right:10px">清除查询
            </button>
            <div id="mdiv" class="mdiv">
                <table class="table table-hover" id="dataShow" style="width: 100%;table-layout:fixed">
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal(添加质检报告) -->
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width: 75%">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h3 class="modal-title" id="myModalLabel"><b style="color: #2aabd2">质检报告</b></h3>
            </div>
            <div class="modal-body" style="padding-right: 40px;padding-left:35px;height:500px;overflow-y:scroll;">
                <form class="form-horizontal" role="form" id="qaForm">
                    <table width="100%">
                        <tr>
                            <td style="padding-bottom: 5px">
                                <div class="form-group">
                                    <label class="col-sm-4" style="text-align: right">企业名称:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <span id="unitN" style="font-weight: normal"></span>
                                    </div>
                                </div>
                            </td>
                            <td style="padding-bottom: 5px">
                                <div class="form-group">
                                    <label class="col-sm-4" style="text-align: right">分店名称:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <span id="subN" style="font-weight: normal"></span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 5px">
                                <div class="form-group">
                                    <label class="col-sm-4" style="text-align: right">编号或批号:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <span id="qaNo" name="qaNo"
                                              style="font-weight: normal"></span>
                                    </div>
                                </div>
                            </td>
                            <td style="padding-bottom: 5px">
                                <div class="form-group">
                                    <label class="col-sm-4" style="text-align: right">质检种类:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <span id="cName" style="font-weight: normal"></span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 6px">
                                <div class="form-group">
                                    <label for="simpleOrg" class="col-sm-2 control-label"
                                    ><span
                                            class="warning">*</span>被采样单位:</label>
                                    <div class="col-sm-10" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="simpleOrg" name="simpleOrg"
                                               placeholder="被采样单位" maxlength="110">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>采样日期:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <div class="input-group date" id="date-start">
                                            <input class="form-control" size="16" style="cursor:pointer" type="text"
                                                   id="samplingDate"
                                                   name="samplingDate"
                                                   value=""
                                                   readonly>
                                            <span class="input-group-addon" id="samplingDateSpan"><span
                                                    class="glyphicon glyphicon-calendar"></span></span>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>检测日期:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <div class="input-group date" id="date-end">
                                            <input class="form-control" size="16" style="cursor:pointer" type="text"
                                                   id="detectDate"
                                                   name="detectDate"
                                                   value=""
                                                   readonly>
                                            <span class="input-group-addon" id="detectDateSpan"><span
                                                    class="glyphicon glyphicon-calendar"></span></span>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label for="sampleSource" class="col-sm-4 control-label" style="line-height: 24px;"
                                    ><span
                                            class="warning" style="display: none">*</span>样品来源:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="sampleSource" name="sampleSource"
                                               placeholder="样品来源" maxlength="50">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <label for="sampleNum" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>样品数量:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="sampleNum" name="sampleNum"
                                               placeholder="样品数量" maxlength="10">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label for="orgLinkMan" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>负责人:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="orgLinkMan" name="orgLinkMan"
                                               placeholder="负责人" maxlength="20">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group"><label for="orgLinkPhone" class="col-sm-4 control-label"
                                ><span
                                        class="warning">*</span>联系方式:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="orgLinkPhone" name="orgLinkPhone"
                                               placeholder="联系方式" maxlength="13">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label for="samplingMan" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>采样人:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="samplingMan" name="samplingMan"
                                               placeholder="采样人" maxlength="20">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <label for="detectMan" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>检测人:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="detectMan" name="detectMan"
                                               placeholder="检测人" maxlength="20">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label for="checkMan" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>核对人:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" width="100%" class="form-control" id="checkMan"
                                               name="checkMan" placeholder="核对人" maxlength="20">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <label for="issueMan" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>签发人:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <input type="text" class="form-control" id="issueMan" name="issueMan"
                                               placeholder="签发人" maxlength="20">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <label for="detectType" class="col-sm-4 control-label"
                                    ><span
                                            class="warning">*</span>检测依据:</label>
                                    <div class="col-sm-8" style="padding-left: 0px">
                                        <select id="detectType" name="detectType" class="form-control"
                                                placeholder="签发人">
                                            <option value="-1">请选择</option>
                                            <c:forEach items="${detectType}" var="t">
                                                <option value="${t.value}">${t.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </td>
                            <td></td>
                        </tr>
                        <style type="text/css">
                            ul {
                                margin: 0;
                                padding: 0;
                                list-style-type: none;
                            }

                            ul#navlist {
                                font: 12px verdana;
                                padding-bottom: 13px;
                            }

                            ul#navlist li span {
                                background: #FBFBFB;
                            }

                            ul#navlist li {
                                float: left;
                                height: 30px;
                                border: 0px solid #a1a1a1;
                                width: 100%;
                            }

                            ul#navlist .list1 {
                                border-bottom: 1px solid #a1a1a1;
                                width: 100%;
                                margin-bottom: -15px;
                            }

                            #navlist a {
                                display: block;
                                color: #a1a1a1;
                                text-decoration: none;
                                cursor: default;
                                padding: 6px 5px;
                                width: 100%;
                                text-align: center;
                            }
                        </style>
                        <tr>
                            <td colspan="2">
                                <div class="form-group">
                                    <ul id="navlist">
                                        <li class="list1"></li>
                                        <li class="list2"><a
                                                href="javascript:void(0)"><span>&nbsp;&nbsp;检测项目&nbsp;</span></a></li>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table id="dItem" width="100%" style="margin-left: 5px"></table>
                    <table width="100%">
                        <tr>
                            <td colspan="2" style="padding-left: 6px">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"><span
                                            class="warning">*</span>检测报告:</label>
                                    <div class="col-sm-10" style="padding-left: 0px">
                                        <input type='hidden' id="reportImg" name="imgUrl" class='imgurl'>
                                        <div id="pk" class="filePicker" style="float: left">上传图片</div>
                                        <div id="tList" class='theList' style="margin-bottom: 12px"></div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
                <div class="modal-footer" style="text-align: center">
                    <button type="button" class="btn btn-primary" id="reportSave">保 存</button>
                    <button type="button" class="btn btn-primary" id="reportSubmit">提 交</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal(添加质检报告) -->
<div class="modal fade" id="bundleModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h3 class="modal-title"><b style="color: #2aabd2">货品流向信息</b></h3>
            </div>
            <div class="modal-body" style="padding-bottom: 5px">
                <form class="form-horizontal">
                    <div class="form-group">
                        <div class="col-sm-6" style="padding-left: 20px">
                            <label>编号或批号:</label>
                            <span id="bNo"></span>
                        </div>
                        <div class="col-sm-6">
                            <label>质检种类:</label>
                            <span id="bName"></span>
                            <input type="hidden" id="cId">
                        </div>
                    </div>
                    <div class="form-group">
                        <c:if test="${sessionScope.get('loginInfo').roleEntityList[0].roleType==3}">
                            <div class="col-sm-3">
                                <button type="button" class="btn btn-primary btn-sm" onclick="selectFlow()">添加流向单位
                                </button>
                            </div>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-12">
                            <table class="table table-hover" id="flowData" style="width: 100%">
                            </table>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="text-align: center">
                <c:if test="${sessionScope.get('loginInfo').roleEntityList[0].roleType==3}">
                    <button type="button" class="btn btn-primary" style="margin-right: 20px" onclick="flowSave()">保 存
                    </button>
                </c:if>
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal(流向单位) -->
<div class="modal fade" id="flowModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:30%;">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title"><b style="color: #2aabd2">选择流向单位</b></h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <div class="col-sm-12">
                            <select class="form-control" name="selUnitList" id="selUnitList" size="10"
                                    onchange="selectFlowUnit(this)">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="text-align: center">
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal(流向单位) -->
<div class="modal fade text-center" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title"><b style="color: #2aabd2">查看大图</b></h4>
            </div>
            <div class="modal-body" style="height:500px;overflow: scroll">
                <img id="bigImage">
            </div>
        </div>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="searchModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width: 40%">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title"><b style="color: #2aabd2">查 询</b>
                </h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" style="text-align: center">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">报告编号:</label>
                        <div class="col-sm-7" style="padding-left: 0px">
                            <input type="text" class="form-control" id="sQaNo" name="sQaNo" placeholder="报告编号"
                                   maxlength="15">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">检测人:</label>
                        <div class="col-sm-7" style="padding-left: 0px">
                            <input type="text" class="form-control" id="sDetectMan" name="sDetectMan" placeholder="检测人"
                                   maxlength="20">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">检测时间(起):</label>
                        <div class="col-sm-7" style="padding-left: 0px">
                            <div class="input-group date" id="mdate-start">
                                <input class="form-control" size="16" type="text" id="txtStartTime" name="txtStartTime"
                                       value=""
                                       readonly>
                                <span class="input-group-addon"><span
                                        class="glyphicon glyphicon-calendar"></span></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">检测时间(止):</label>
                        <div class="col-sm-7" style="padding-left: 0px">
                            <div class="input-group date" id="mdate-end">
                                <input class="form-control" size="16" type="text" id="txtEndTime" name="txtEndTime"
                                       value="" readonly>
                                <span class="input-group-addon"><span
                                        class="glyphicon glyphicon-calendar"></span></span>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="text-align: center">
                <button type="button" class="btn btn-primary" onclick="search()" style="margin-right: 50px">查 询</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="videoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="text-align: center">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title"><b style="color: #2aabd2">视频播放</b>
                </h4>
            </div>
            <div class="modal-body" style="text-align: center;vertical-align: middle">
                <video id="mov" autoplay='autoplay' controls='controls' width='480px' height='320px'></video>
            </div>
            <div class="modal-footer" style="text-align: center">
                <button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
            </div>
        </div>
    </div>
</div>
</body>
<script src="${ctx}/content/lib/jequery/jquery.min.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-3.3.0/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-table/bootstrap-table.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-table/bootstrap-table-zh-CN.js" type="text/javascript"></script>
<!-- 添加验证 -->
<script src="${ctx}/content/lib/bootstrap-validator/bootstrapValidator.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-validator/zh_CN.js" type="text/javascript"></script>
<script type="text/javascript" src="${ctx}/content/lib/webuploader/webuploader.nolog.js"></script>
<script type="text/javascript" src="${ctx}/content/localjs/commonJs.js"></script>
<script src="${ctx}/content/lib/bootstrap-treeview/bootstrap-treeview.min.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/jequery/jq_mydialog.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-datepicker-master/js/bootstrap-datepicker.js" type="text/javascript"></script>
<script src="${ctx}/content/lib/bootstrap-datepicker-master/locales/bootstrap-datepicker.zh-CN.min.js"
        type="text/javascript"></script>
<script type="text/javascript" src="${ctx}/content/localjs/report.js"></script>
<script language="javascript" type="text/javascript">

    //ajax请求登录验证
    $.ajaxSetup({
        type: 'POST',
        complete: function (xhr, status) {
            var sessionStatus = xhr.getResponseHeader('sessionstatus');
            $.myloading("hide");
            if (sessionStatus == 'timeout') {
                /* $.messager.alert("登录失效","由于您长时间未操作,登录已失效,请重新登录","info",function(){
                 parent.location.href$ = {ctx}+"/login.jsp";
                 });*/
                alert("您还没有登录或登录信息超时，请登录");
                parent.location.href = "${ctx}" + "/login.jsp";
            }
        }
    });

    //图片上传组件
    var uploader;
    //视频上传组件
    var videoUploader;
    //种类ID
    var classId = -1;
    //企业种类关系ID
    var betweenId = -1;
    //分店ID
    var subId = -1;
    //企业ID
    var unitId = -1;
    //质检报告ID
    var qd = -1;
    //企业名称
    var unitN;
    //分店名称
    var subN;
    //种类名称
    var cName;
    //节点级别
    var level = -1;

    //添加回车事件
    $('#searchName').keypress(function (event) {
        if (event.keyCode == '13') {
            //取消浏览器的默认事件
            event.preventDefault();
        }
    });

    //页面打开时获取企业信息
    $(function () {
        getQAInfo();
    })

    //搜索功能
    function search() {
        $("#dataShow").bootstrapTable('destroy');
        getQAInfo();
        $("#searchModal").modal('hide');
        checkSearch();
    }

    function searchClear() {
        $("#sQaNo").val("");
        $("#sDetectMan").val("");
        $("#txtStartTime").val("");
        $("#txtEndTime").val("");
        refresh();
        $("#searchClear").hide();
    }

    function checkSearch() {
        var sUN = $.trim($("#sQaNo").val());
        var sUA = $.trim($("#sDetectMan").val());
        var sSD = $("#txtStartTime").val();
        var sED = $("#txtEndTime").val();
        if (sUN.length == 0 && sUA.length == 0 && sSD.length == 0 && sED.length == 0) {
            $("#searchClear").hide();
        } else {
            $("#searchClear").show();
        }
    }

    function searchUnit() {
        $('#searchModal').modal('show')
    }

    //企业树结构数据
    function getTree() {
        var tree = ${unitTree};
        return tree;
    }
    //企业树结构
    $('#tree').treeview({
        data: getTree(),
        highlightSelected: true,
        showBorder: false,
        onNodeSelected: function (event, data) {
            var name;
            level = data.level;
            if (level == 1) {
                classId = -1;
                betweenId = -1;
                //企业节点
                unitId = data.realId;
                unitN = data.text;
                name = data.text;
            } else if (level == 2) {
                classId = -1;
                betweenId = -1;
                //分店节点
                subId = data.realId;
                subN = data.text;
                var parent = $('#tree').treeview('getNode', data.parentId);
                unitId = parent.realId;
                unitN = parent.text;
                name = parent.text + " > " + data.text;
            } else if (level == 3) {
                //种类节点
                classId = data.realId;
                betweenId = data.otherId;
                var parent = $('#tree').treeview('getNode', data.parentId);
                var p = $('#tree').treeview('getNode', parent.parentId);
                unitN = p.text;
                unitId = p.realId;
                subN = parent.text;
                subId = parent.realId;
                cName = data.text;
                name = p.text + " > " + parent.text + " > " + data.text;
            }
            $("#lblSelect").text(name);
            refresh();
        }
    });

    $('#tree').treeview('collapseAll',
            {silent: true});

    //    window.onload = function() {
    //        var node = $('#tree').treeview("getNode", 0);
    //        $('#tree').treeview('selectNode', [node, {silent: true}]);
    //    }

    //初始化使用table 插件
    function queryParams(params) {
        return { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
            limit: params.limit, //页面大小 如每页显示10条
            offset: params.offset, //页码
            content: $.trim($("#sQaNo").val()),
            detectMan: $.trim($("#sDetectMan").val()),
            startDate: $("#txtStartTime").val(),
            endDate: $("#txtEndTime").val(),
            unitId: unitId,
            subId: subId,
            classId: classId,
            level: level
        }
    }
    //获取表格高度
    function getHeight() {
        return $(window).height() - 100;
    }
    //获取质检项（根据种类）
    function getDetectItem(id) {
        $.ajax({
            url: "${ctx}/report/detectItem",
            type: "POST",
            async: false,
            data: {
                classId: id
            },
            success: function (result) {
                if (result != null && !jQuery.isEmptyObject(result)) {
                    $.each(result, function (i, n) {
                        //质检项
                        var content = "<tr>" +
                                "<td colspan='2'>" +
                                "<div class='form-group'>" +
                                "<label class='col-sm-2 control-label'>" +
                                "<span class='warning'>*</span>" + n.itemName + ":</label>" + <!--质检项名称-->
                                "<div class='col-sm-3' style='padding-left: 0px'>" +
                                "<select id='qaItems" + i + "' name='qaItems" + i + "' class='form-control'>" +
                                "<option value='-1' selected>请选择</option>" +
                                "</select>" +
                                //"<input type='text' class='form-control'/>" +
                                "</div>" +
                                "<input type='hidden' class='itemId' value='" + n.itemId + "'> " + <!--质检项ID-->
                                "<input type='hidden' class='itemName' value='" + n.itemName + "'> " + <!--质检项名称-->
                                "<input type='hidden' class='imgurl'> " + <!--图片路径-->
                                "<div class='filePicker' style='float: left'>选择图片</div>" +
                                "<div class='videoPicker' style='float: left;margin-left: 5px'>上传视频</div><input type='hidden' class='video'><div class='pg' style='margin-top: 10px'></div>" +
                                "</div>" +
                                "<div class='form-group'>" +
                                "<div class='col-sm-2'></div>" +
                                "<div class='theList'></div></div>" +
                                "</td>" +
                                "<td></td>" +
                                "</tr>";

                        $("#dItem").append(content);
                        //质检结果项
                        if (n.itemResultList != null) {
                            $.each(n.itemResultList, function (j, s) {
                                $("#qaItems" + i).append("<option value='" + s.resultId + "'>" + s.resultName + '(' + s.passedName + ')' + "</option>");
                            });
                        }
                        //动态添加验证
                        $('#qaForm').bootstrapValidator('addField', 'qaItems' + i, {
                            validators: {
                                regexp: {
                                    regexp: /^[1-9]\d*|0$/,
                                    message: '请选择检测结果'
                                }
                            }
                        });
                    });
                    //uploadInit();
                } else {
//                    $('#reportModal').modal('hide');
                }
            },
            error: function (info) {
            }
        })
    }

    //获取企业信息
    function getQAInfo() {
        $('#dataShow').bootstrapTable({
            url: '${ctx}/report/list',   //请求后台的URL（*）
            height: getHeight(),
            method: 'get',      //请求方式（*）
            striped: true,      //是否显示行间隔色
            cache: false,      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: true,     //是否显示分页（*）
            sortable: false,      //是否启用排序
            sortOrder: "desc",     //排序方式
            sidePagination: "server",   //分页方式：client客户端分页，server服务端分页（*）
            queryParams: queryParams,//参数
            pageNumber: 1,      //初始化加载第一页，默认第一页
            pageSize: 10,      //每页的记录行数（*）
            pageList: [10, 25, 50, 100],  //可供选择的每页的行数（*）
            search: false,      //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
            strictSearch: false,
            showColumns: false,     //是否显示所有的列
            showRefresh: false,     //是否显示刷新按钮
            minimumCountColumns: 2,    //最少允许的列数
            clickToSelect: true,    //是否启用点击选中行//行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            idField: "qaId",
            uniqueId: "qaId",      //每一行的唯一标识，一般为主键列
            showToggle: false,     //是否显示详细视图和列表视图的切换按钮
            cardView: false,     //是否显示详细视图
            detailView: false,     //是否显示父子表
            columns: [
                {
                    title: '序号',
                    valign: 'middle',
                    align: 'center',
                    width: 60,
                    formatter: indexFormatter
                },
                {
                    field: 'qaNo',
                    title: '编号或批号',
                    valign: 'middle',
                    align: 'center'
                }, {
                    field: 'simpleOrg',
                    title: '被采样单位',
                    valign: 'middle',
                    align: 'center'
                }, {
                    field: 'detectMan',
                    title: '检测人',
                    valign: 'middle',
                    align: 'center'
                }, {
                    field: 'name',
                    title: '检测地点',
                    valign: 'middle',
                    align: 'center'

                }, {
                    field: 'detectDate',
                    title: '检测日期',
                    valign: 'middle',
                    align: 'center'
                }, {
                    title: '',
                    valign: 'middle',
                    align: 'center',
                    width: 80,
                    events: operateEvents,
                    formatter: detailsFormatter
                }, {
                    title: '',
                    valign: 'middle',
                    align: 'center',
                    width: 80,
                    events: operateEvents,
                    formatter: bundleFormatter
                }, {
                    title: '',
                    valign: 'middle',
                    align: 'center',
                    width: 60,
                    events: operateEvents,
                    formatter: downFormatter
                }, {
                    title: '',
                    field: 'del',
                    valign: 'middle',
                    align: 'center',
                    width: 60,
                    events: operateEvents,
                    formatter: delFormatter
                }
            ]
        });
        if (${s==1}) {
            $('#dataShow').bootstrapTable('showColumn', 'del');
        } else {
            $('#dataShow').bootstrapTable('hideColumn', 'del');
        }
    }
    //查看详情按钮
    window.operateEvents = {
        'click .details': function (e, value, row, index) {
            if (row.qaType == 2) {
                getReportDetails(row.qaCopy, row.status);
            } else {
                getReportDetails(row.qaId, row.status);
            }
            unitId = row.unitId;
            subId = row.subId;
            classId = row.classId;
            betweenId = row.betweenId;
            $("#unitN").text(unitN);
            $("#subN").text(row.subName);
            $("#cName").text(row.className);
            $("#qaNo").text(row.qaNo);
            $("#simpleOrg").val(row.simpleOrg);
            $("#samplingDate").val(row.samplingDate);
            $("#detectDate").val(row.detectDate);
            $("#sampleSource").val(row.sampleSource);
            $("#sampleNum").val(row.sampleNum);
            $("#orgLinkMan").val(row.orgLinkMan);
            $("#orgLinkPhone").val(row.orgLinkPhone);
            $("#samplingMan").val(row.samplingMan);
            $("#detectMan").val(row.detectMan);
            $("#checkMan").val(row.checkMan);
            $("#issueMan").val(row.issueMan);
            $("#detectType").val(row.detectTypeId);
            //$("#reportImg").val(row.urlReport);
            if (null == row.urlReport || row.urlReport.length == 0) {
                alert("该质检报告存在异常数据");
                return;
            }
            var arrs = row.urlReport.split("|");
            //编辑
            if (row.status == 1) {
                $.each(arrs, function (i, obj) {
                    //质检报告图片
                    var $li = $('<div class="file-item thumbnail" style="float: left;text-align: center"> ' +
                            '<input type="hidden" value="' + obj + '">' + <!--图片地址-->
                            '<img src="${ctx}' + obj + '" style="width:70px;height:70px;cursor:pointer" onclick="showImage(this)">' +
                            '<a id="tempId_' + i + '" href="javascript:void(0);">删除</a>' +
                            '</div>');
                    $("#tList").append($li);
                    $("#tempId_" + i).bind("click", function () {
                        var fileItem = $(this).parent();
                        $(fileItem).remove();
                    });
                });
                operEnable();
            } else {
                $.each(arrs, function (i, obj) {
                    //查看
                    //质检报告图片
                    var $li = $('<div class="file-item thumbnail" style="float: left;text-align: center"> ' +
                            '<input type="hidden" value="' + obj + '">' + <!--图片地址-->
                            '<img src="${ctx}' + obj + '" style="width:70px;height:70px;cursor:pointer" onclick="showImage(this)">' +
                            '</div>');
                    $("#tList").append($li);
                });
                operUnEnable();
            }

            $('#reportModal .modal-footer #reportSave').attr("onclick", "valSubmit(" + row.qaId + ",1)");
            $('#reportModal .modal-footer #reportSubmit').attr("onclick", "valSubmit(" + row.qaId + ",2)");
            $('#reportModal').modal('show')
        },
        'click .bundle': function (e, value, row, index) {
            if (row.status == 1) {
                alert("该报告尚未提交，无法查看流向信息");
            } else {
                $("#bNo").text(row.qaNo);
                $("#bName").text(row.className);
                $("#cId").val(row.classId);
                qd = row.qaId;
                flowInfo(row.qaId, row.qaType, row.qaCopy);
                $("#bundleModal").modal('show');
            }
        },
        'click .down': function (e, value, row, index) {
            if (row.status == 1) {
                alert("该报告尚未提交，无法下载");
            } else {
                $.myloading({title: '正在生成，请稍后...'});
                $.ajax({
                    url: "${ctx}/report/checkPDF",
                    type: "POST",
                    data: {
                        qaId: row.qaId
                    },
                    success: function (data) {
                        $.myloading("hide");
                        if (data != null && data != "") {
                            parent.location.href = "${ctx}/report/downPDF?url=" + data;
                        } else {
                            alert("无法找到该质检报告信息");
                        }
                    },
                    error: function (data) {
                        $.myloading("hide");
                    }
                });
            }
        },
        'click .del': function (e, value, row, index) {
            if (confirm("确定要删除此质检报告吗?")) {
                if (row.qaType == 2) {
                    alert("该报告存在其他流向单位，无法删除");
                } else {
                    delQA(row.qaId);
                }
            }
        }
    };

    //删除企业
    function delQA(qaId) {
        $.ajax({
            url: "${ctx}/report/delQA",
            type: "POST",
            data: {
                qaId: qaId
            },
            success: function (data) {
                if (data != null) {
                    if (data.result == 1) {
                        refresh();
                    } else {
                        alert(data.resultInfo);
                    }
                } else {
                    alert("删除失败");
                }
            },
            error: function (info) {
            }
        });
    }

    //格式化序号
    function indexFormatter(value, row, index) {
        return index + 1;
    }

    //流向
    function bundleFormatter(value, row, index) {
        return ["<a href='javascript:void(0);' class='bundle'>查看流向</a>"];
    }
    //查看详情
    function detailsFormatter(value, row, index) {
        if (row.status == 1) {
            return ["<a href='javascript:void(0);' class='details'>编辑</a>"];
        } else {
            return ["<a href='javascript:void(0);' class='details'>查看详情</a>"];
        }
    }

    function delFormatter() {
        return ["<a href='javascript:void(0);' class='del'>删除</a>"];
    }

    function downFormatter() {
        return ["<a href='javascript:void(0);' class='down'>下载</a>"];
    }

    //添加质检报告
    function addReport() {
        if (classId != -1) {
            getQaNum();
        } else {
            alert("请选择完种类后再添加质检报告");
        }
    }

    function getQaNum() {
        $.ajax({
            url: "${ctx}/report/getQaNum",
            type: "POST",
            async: false,
            success: function (data) {
                if (data != null && data != "") {
                    $("#qaNo").text(data);
                    getDetectItem(classId);
                    $("#unitN").text(unitN);
                    $("#subN").text(subN);
                    $("#cName").text(cName);
                    $("#simpleOrg").val(unitN + "-" + subN);
                    $("#sampleSource").val("");
                    $("#sampleNum").val("");
                    $("#orgLinkMan").val("");
                    $("#orgLinkPhone").val("");
                    $("#samplingMan").val("");
                    $("#detectMan").val("");
                    $("#checkMan").val("");
                    $("#issueMan").val("");
                    $("#detectType option:first").prop("selected", 'selected');
                    $("#reportImg").val("");
                    $("#samplingDate").val(commonJs.getSysDay());
                    $("#detectDate").val(commonJs.getSysDay());

                    operEnable();
                    $('#reportModal .modal-footer #reportSave').attr("onclick", "valSubmit(0,1)");
                    $('#reportModal .modal-footer #reportSubmit').attr("onclick", "valSubmit(0,2)");
                    $('#reportModal').modal('show')
                }
            },
            error: function (info) {
            }
        })
    }

    //查看详情
    function getReportDetails(qaId, status) {
        $.ajax({
            url: "${ctx}/report/qaDetails",
            type: "POST",
            async: false,
            data: {
                qaId: qaId
            },
            success: function (data) {
                if (data != null) {
                    //尚未提交
                    if (status == 1) {
                        $.each(data, function (i, m) {
                            //质检项
                            var content = "<tr>" +
                                    "<td colspan='2'>" +
                                    "<div class='form-group'>" +
                                    "<label class='col-sm-2 control-label'>" +
                                    "<span class='warning'>*</span>" + m.itemName + ":</label>" +
                                    "<div class='col-sm-3' style='padding-left: 0px'>" +
                                    "<select id='qaItems" + i + "' name='qaItems" + i + "' class='form-control'>" +
                                    "<option value='-1' selected>请选择</option>" +
                                    "</select>" +
                                    "</div>" +
                                    "<input type='hidden' class='qid' value='" + m.id + "'> " +
                                    '<input type="hidden" class="itemId" value="' + m.itemId + '"> ' +
                                    '<input type="hidden" class="itemName" value="' + m.itemName + '"> ' +
                                    '<div class="filePicker" style="float: left">选择图片</div>' +
                                    "<div class='videoPicker' style='float: left;margin-left: 5px'>上传视频</div><input id='video_" + i + "' type='hidden' class='video' value='" + m.vedioUrl + "'><div id='pg" + i + "' class='pg' style='margin-top: 10px'></div>" +
                                    "</div>" +
                                    "<div class='form-group'>" +
                                    "<div class='col-sm-2'></div>" +
                                    '<div id="theList' + i + '"class="theList">' +
                                    '</div>' +
                                    '</div></td>' +
                                    '<td></td>' +
                                    '</tr>';

                            $("#dItem").append(content);

                            if (m.urlDetect != null && m.urlDetect.length > 0) {
                                var imgs = m.urlDetect.split("|");
                                $.each(imgs, function (k, g) {
                                    var $l = $(
                                            '<div id="id' + i + k + '"class="file-item thumbnail" style="float: left;text-align: center"> ' +
                                            '<input type="hidden" value="' + g + '">' +
                                            '<img src="${ctx}' + g + '" style="width:70px;height:70px;cursor:pointer" onclick="showImage(this)">' +
                                            '<a id="btn_' + i + k + '" href="javascript:void(0);">删除</a>' +
                                            '</div>'
                                    );
                                    $("#theList" + i).append($l);
                                    $("#btn_" + i + k).bind("click", function () {
                                        var fileItem = $(this).parent();
//                                        var u = fileItem.find("input").val();
//                                        if (u != "") {
//                                            delSource(u);
//                                        }
                                        $(fileItem).remove();
                                    });
                                });
                            }

                            if (m.vedioUrl != null && m.vedioUrl.length > 0) {
                                $("#pg" + i).empty();
                                var $a = $("<div>&nbsp;&nbsp;<a id='alook_" + i + "'>查看视频</a>&nbsp;&nbsp;&nbsp;&nbsp;<a id='e_" + i + "'>删除</a>&nbsp;&nbsp;<span class='errortip'>(请检查视频,如无法播放请删除)</span></div>");
                                $("#pg" + i).append($a);
                                $("#e_" + i).bind("click", function () {
//                                    var u = $("#video_" + i).val();
//                                    if (u != "") {
//                                        delSource(u);
//                                    }
                                    $("#video_" + i).val("");
                                    $("#pg" + i).empty();
                                });
                                $("#alook_" + i).bind("click", function () {
                                    var url = $("#video_" + i).val();
                                    playVideo(url);
                                });
                            }

                            //质检结果项
                            if (m.itemResultList != null) {
                                $.each(m.itemResultList, function (j, s) {
                                    $("#qaItems" + i).append("<option value='" + s.resultId + "'>" + s.resultName + '(' + s.passedName + ')' + "</option>");
                                });
                                $("#qaItems" + i).val(m.resultId);
                            }

                            $('#qaForm').bootstrapValidator('addField', 'qaItems' + i, {
                                validators: {
                                    regexp: {
                                        regexp: /^[1-9]\d*|0$/,
                                        message: '请选择检测结果'
                                    }
                                }
                            });
                        });
                    } else {
                        $.each(data, function (i, m) {
                            //质检项
                            var content = "<tr>" +
                                    "<td colspan='2'>" +
                                    "<div class='form-group'>" +
                                    "<label class='col-sm-2 control-label'>" +
                                    "<span class='warning'>*</span>" + m.itemName + ":</label>" +
                                    "<div class='col-sm-3' style='padding-left: 0px'>" +
                                    "<input id='qaItems" + i + "' type='text' class='form-control' readonly/>" +
                                    "</div>" +
                                    "<input id='video" + i + "' type='hidden' class='video' value='" + m.vedioUrl + "'><div id='pg" + i + "' class='pg' style='margin-top: 10px'></div>" +
                                    "</div>" +
                                    "<div class='form-group'>" +
                                    "<div class='col-sm-2'></div>" +
                                    '<div id="theList' + i + '" class="theList">' +
                                    '</div>' +
                                    '</div></td>' +
                                    '<td></td>' +
                                    '</tr>';

                            $("#dItem").append(content);

                            if (m.urlDetect != null && m.urlDetect.length > 0) {
                                var imgs = m.urlDetect.split("|");
                                $.each(imgs, function (k, g) {
                                    var $l = $(
                                            '<div class="file-item thumbnail" style="float: left;text-align: center"> ' +
                                            '<input type="hidden" value="' + g + '">' +
                                            '<img src="${ctx}' + g + '" style="width:70px;height:70px;cursor:pointer" onclick="showImage(this)">' +
                                            '</div>'
                                    );
                                    $("#theList" + i).append($l);
                                });
                            }

                            if (m.vedioUrl != null && m.vedioUrl.length > 0) {
                                $("#pg" + i).empty();
                                var $a = $("<div>&nbsp;&nbsp;<a id='alook_" + i + "'>查看视频</a></div>");
                                $("#pg" + i).append($a);
                                $("#alook_" + i).bind("click", function () {
                                    var url = $("#video" + i).val();
                                    playVideo(url);
                                });
                            }

                            //质检结果项
                            if (m.itemResultList != null) {
                                $.each(m.itemResultList, function (j, s) {
                                    if (s.resultId == m.resultId) {
                                        var str = "(" + s.passedName + ")";
                                        $("#qaItems" + i).val(s.resultName + str);
                                    }
                                });
                            }
                        });
                    }
                } else {
                    alert("该质检报告存在异常");
                }
            },
            error: function (info) {
            }
        })
    }

    //销毁时重置验证
    $('#reportModal').on('hidden.bs.modal', function () {
        //重置验证
        $("#qaForm").data('bootstrapValidator').destroy();
        $('#qaForm').data('bootstrapValidator', null);
        //清除检测项内容
        $("#dItem").empty();
        //清除质检报告信息
        $("#tList").empty();
        //销毁上传组件
        uploader.destroy();
        videoUploader.destroy();
        //重新初始化验证
        formValidator();
    });

    $('#reportModal').on('shown.bs.modal', function () {
        //初始化上传组件
        uploadInit();
        videoUploadInit();
    });

    //验证提交
    function valSubmit(id, status) {
        //获取报告图片
        reportImg();
        //获取表单对象
        var bootstrapValidator = $("#qaForm").data("bootstrapValidator");
        //手动触发验证
        bootstrapValidator.validate();
        if (bootstrapValidator.isValid()) {
            //表单提交的方法、比如ajax提交
            if (uploader.getStats().queueNum == 0 && videoUploader.getStats().queueNum == 0) {
                reportSave(id, status);
            } else {
                alert("图片正在上传，请耐心等待")
            }
        }
    }

    //保存分店信息
    function reportSave(id, status) {
        var qaNo = $("#qaNo").text();
        var simpleOrg = $.trim($("#simpleOrg").val());
        var samplingDate = $("#samplingDate").val();
        var detectDate = $("#detectDate").val();

        if (samplingDate == "") {
            alert("采样日期不能为空");
            return;
        }

        if (detectDate == "") {
            alert("检测日期不能为空");
            return;
        }

        var sampleSource = $.trim($("#sampleSource").val());
        var sampleNum = $.trim($("#sampleNum").val());
        var orgLinkMan = $.trim($("#orgLinkMan").val());
        var orgLinkPhone = $.trim($("#orgLinkPhone").val());
        var samplingMan = $.trim($("#samplingMan").val());
        var detectMan = $.trim($("#detectMan").val());
        var checkMan = $.trim($("#checkMan").val());
        var issueMan = $.trim($("#issueMan").val());
        var detectTypeId = $("#detectType").val();
        var detectType = $("#detectType").find("option:selected").text();
        var urlReport = $("#reportImg").val();
        //保存操作
        var qainfoEntity = {
            qaId: id,
            qaNo: qaNo,
            unitId: unitId,
            subId: subId,
            classId: classId,
            betweenId: betweenId,
            simpleOrg: simpleOrg,
            samplingDate: samplingDate,
            detectDate: detectDate,
            sampleSource: sampleSource,
            sampleNum: sampleNum,
            orgLinkMan: orgLinkMan,
            orgLinkPhone: orgLinkPhone,
            samplingMan: samplingMan,
            detectMan: detectMan,
            checkMan: checkMan,
            issueMan: issueMan,
            detectType: detectType,
            detectTypeId: detectTypeId,
            urlReport: urlReport,
            status: status
        };

        var lists = packageQAItem(id);

        if (jQuery.isEmptyObject(lists)) {
            alert("质检项目为空，无法生成质检报告");
            return;
        }

        //封装请求对象
        var reportInfo = {
            qainfoEntity: qainfoEntity,
            itemList: lists
        }

        $.myloading({title: '正在保存，请稍后...'});

        //请求注册
        $.ajax({
            url: "${ctx}/report/addReportInfo",
            data: JSON.stringify(reportInfo),
            contentType: "application/json",
            type: "post",
            success: function (result) {
                $.myloading("hide");
                if (result != null) {
                    if (result.result == 1) {
                        refresh();
                    } else {
                        alert(result.resultInfo);
                    }
                } else {
                    alert("质检报告保存失败");
                }
                $('#reportModal').modal('hide')
            },
            error: function (info) {
            }
        })
    }

    //刷新
    function refresh() {
        $("#dataShow").bootstrapTable('destroy');
        getQAInfo();
        checkSearch();
    }
    //初始化上传类
    function uploadInit() {
        //var $list = $("#fileList");   //这几个初始化全局的百度文档上没说明，好蛋疼。
        uploader = WebUploader.create({
            auto: true,
            //重复上传
            duplicate: true,
            // swf文件路径
            swf: '${ctx}/content/lib/webuploader/Uploader.swf',
            // 文件接收服务端。
            server: '${ctx}/report/uploadFile;jsessionid=${pageContext.session.id}?type=' + Math.random(),
            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            //pick: '.filePicker',
            pick: {
                id: '.filePicker',
                multiple: false            //默认为true，true表示可以多选文件，HTML5的属性
            },
            // 只允许选择图片文件。
            accept: {
                title: 'Images',
                extensions: 'jpg,jpeg,png',
                mimeTypes: 'image/jpg,image/jpeg,image/png'
            },
            method: 'POST',
        });

        uploader.on('beforeFileQueued', function (file) {
            var uploaderId = "#rt_" + file.source.ruid;
            var size = $(uploaderId).parent().parent().parent().find(".theList").children().length;
            if (size >= 5) {
                alert("每项最多上传5张图片");
                return false;
            }
        });

        // 当有文件添加进来的时候
        uploader.on('fileQueued', function (file) {
            var uploaderId = "#rt_" + file.source.ruid;
            var $li = $(
                            '<div id="' + file.id + '" class="file-item thumbnail" style="float: left;text-align: center"> ' +
                            '<input id="input_' + file.id + '" type="hidden">' + <!--图片地址-->
                            '<img style="cursor:pointer" onclick="showImage(this)">' +
                            '<a id="btn_' + file.id + '" href="javascript:void(0);">删除</a>' +
//                            '<div class="info">Image' + file.name + '</div>' +
                            '</div>'
                    ),
                    $img = $li.find('img');
            //如果包含子元素，从队列中移除id
            /*            if ($(uploaderId).parent().parent().find(".theList").children().length > 0) {
             // $list为容器jQuery实例
             var id = $(uploaderId).parent().parent().find(".theList").children("div").attr("id");
             if (uploader.getFile(id) != null) {
             uploader.removeFile(id, true);
             }
             $(uploaderId).parent().parent().find(".theList").empty();
             }*/
            $(uploaderId).parent().parent().parent().find(".theList").append($li);
            // 创建缩略图
            // 如果为非图片文件，可以不用调用此方法。
            // thumbnailWidth x thumbnailHeight 为 100 x 100
            uploader.makeThumb(file, function (error, src) {
                        if (error) {
                            $img.replaceWith('<span>不能预览</span>');
                            return;
                        }
                        $img.attr('src', src);
                    }
                    , 70, 70);
            //删除按钮
            $("#btn_" + file.id).bind("click", function () {
                var fileItem = $(this).parent();
                var u = fileItem.find("input").val();
                if (u != "") {
                    delSource(u);
                }
                //队列中删除
                uploader.removeFile($(fileItem).attr("id"), true);
                $(fileItem).fadeOut(function () {
                    //清空图片地址
                    $(fileItem).remove();
                });
            });
        });
        // 文件上传过程中创建进度条实时显示。
        uploader.on('uploadProgress', function (file, percentage) {
            var $li = $('#' + file.id),
                    $percent = $li.find('.progress div');
            // 避免重复创建
            if (!$percent.length) {
                $percent = $('<div class="progress" style="width:70px;height:10px;margin-bottom: 5px"><div class="progress-bar"></div></div>')
                        .appendTo($li)
                        .find('.progress-bar');
            }
            $percent.css('width', percentage * 100 + '%');
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
        uploader.on('uploadSuccess', function (file, response) {
            var uploaderId = "#rt_" + file.source.ruid;
            $('#input_' + file.id).val(response._raw).change();
            if ($(uploaderId).parent().attr("id") == "pk") {
                $('#reportImg').val(response._raw).change();
            }
            $('#' + file.id).addClass('upload-state-done');
        });

        // 文件上传失败，显示上传出错。
        uploader.on('uploadError', function (file) {
            var $li = $('#' + file.id),
                    $error = $li.find('div.error');

            // 避免重复创建
            if (!$error.length) {
                $error = $('<div class="error"></div>').appendTo($li);
            }

            $error.text('上传失败');
        });

        //  验证大小
        uploader.on("error", function (type) {
            if (type == "Q_TYPE_DENIED") {
                alert("图片格式错误")
            }
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        uploader.on('uploadComplete', function (file) {
            $('#' + file.id).find('.progress').remove();
        });
    }

    //初始化上传类
    function videoUploadInit() {
        videoUploader = WebUploader.create({
            auto: true,
            //重复上传
            duplicate: true,
            // swf文件路径
            swf: '${ctx}/content/lib/webuploader/Uploader.swf',
            // 文件接收服务端。
            server: '${ctx}/report/uploadFile;jsessionid=${pageContext.session.id}?type=' + Math.random(),
            // 选择文件的按钮。可选。
            pick: {
                id: '.videoPicker',
                multiple: false            //默认为true，true表示可以多选文件，HTML5的属性
            },
            fileSingleSizeLimit: 15 * 1024 * 1024,//限制大小10M，单文件
            //fileSizeLimit: allMaxSize*1024*1024,//限制大小10M，所有被选文件，超出选择不上
            accept: {
                extensions: 'mp4',
                mimeTypes: 'video/mp4'
            },
            method: 'POST',
        });

        videoUploader.on('beforeFileQueued', function (file) {
            var uploaderId = "#rt_" + file.source.ruid;
        });

        // 当有文件添加进来的时候
        videoUploader.on('fileQueued', function (file) {
            var uploaderId = "#rt_" + file.source.ruid;
        });
        // 文件上传过程中创建进度条实时显示。
        videoUploader.on('uploadProgress', function (file, percentage) {
            var uploaderId = "#rt_" + file.source.ruid;
            var $li = $(uploaderId).parent().parent().find(".pg");
            $li.empty();
            $percent = $('<div class="progress" style="width:70px;height:10px;margin-left:5px;margin-bottom: 5px;float: left"><div class="progress-bar"></div></div><span>&nbsp;&nbsp;正在上传&nbsp;&nbsp;<a id="c_' + file.id + '">取消</a></span>')
                    .appendTo($li)
                    .find('.progress-bar');
            $percent.css('width', percentage * 100 + '%');
            $("#c_" + file.id).bind("click", function () {
                //队列中删除
                videoUploader.removeFile(file.id, true);
                $(uploaderId).parent().parent().find(".video").val("");
                $(uploaderId).parent().parent().find(".pg").empty();
            });
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
        videoUploader.on('uploadSuccess', function (file, response) {
            var uploaderId = "#rt_" + file.source.ruid;
            //只保存一个视频
            var u = $(uploaderId).parent().parent().find(".video").val();
            if (u != "") {
                delSource(u);
            }
            $(uploaderId).parent().parent().find(".video").val(response._raw);
            $(uploaderId).parent().parent().find(".pg").empty();
            var $a = $("<div>&nbsp;&nbsp;<a id='alook_" + file.id + "'>查看视频</a>&nbsp;&nbsp;&nbsp;&nbsp;<a id='a_" + file.id + "'>删除</a>&nbsp;&nbsp;<span class='errortip'>(请检查视频,如无法播放请删除)</span></div>");
            $(uploaderId).parent().parent().find(".pg").append($a);
            $("#a_" + file.id).bind("click", function () {
                //队列中删除
                videoUploader.removeFile(file.id, true);
                var u = $(uploaderId).parent().parent().find(".video").val();
                if (u != "") {
                    delSource(u);
                }
                $(uploaderId).parent().parent().find(".video").val("");
                $(uploaderId).parent().parent().find(".pg").empty();
            });
            $("#alook_" + file.id).bind("click", function () {
                var url = $(uploaderId).parent().parent().find(".video").val();
                playVideo(url);
            });
        });

        // 文件上传失败，显示上传出错。
        videoUploader.on('uploadError', function (file) {
            var uploaderId = "#rt_" + file.source.ruid;
            $(uploaderId).parent().parent().find(".pg").empty();
            var $a = $("<div>上传失败，请重新上传</div>");
            $(uploaderId).parent().parent().find(".pg").append($a);
        });

        //  验证大小
        videoUploader.on("error", function (type) {
            /*            if (type == "F_DUPLICATE") {
             alert("请不要重复选择文件！");
             } else */
            if (type == "Q_TYPE_DENIED") {
                alert("视频格式错误,请选择mp4格式")
            } else if (type == "F_EXCEED_SIZE") {
                alert("视频大小不可超过15M")
            }
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        videoUploader.on('uploadComplete', function (file) {
            $('#' + file.id).find('.progress').remove();
        });
    }


    //可流向单位
    function selectFlow() {
        var cid = $("#cId").val();
        enableFlowList(unitId, cid);
    }
    //流向信息
    function flowInfo(qaId, qaType, qaCopy) {
        $("#flowData").bootstrapTable('destroy');
        $('#flowData').bootstrapTable({
            url: '${ctx}/report/flowList',   //请求后台的URL（*）
            method: 'get',      //请求方式（*）
            cache: false,      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: false,     //是否显示分页（*）
            sortable: false,      //是否启用排序
            sortOrder: "desc",     //排序方式
            queryParams: {qaId: qaId, qaType: qaType, qaCopy: qaCopy},//参数
            search: false,      //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
            strictSearch: false,
            showColumns: false,     //是否显示所有的列
            showRefresh: false,     //是否显示刷新按钮
            minimumCountColumns: 2,    //最少允许的列数
            clickToSelect: true,    //是否启用点击选中行//行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            idField: "flowId",
            uniqueId: "flowId",      //每一行的唯一标识，一般为主键列
            showToggle: false,     //是否显示详细视图和列表视图的切换按钮
            cardView: false,     //是否显示详细视图
            detailView: false,     //是否显示父子表
            columns: [
                {
                    title: '序号',
                    valign: 'middle',
                    align: 'center',
                    width: 100,
                    formatter: indexFormatter
                }, {
                    field: 'flowName',
                    title: '流向单位',
                    valign: 'middle',
                    align: 'center'
                }]
        });
    }

    //获取可流向单位
    function enableFlowList(id, cid) {
        $.ajax({
            url: "${ctx}/report/enableFlowList",
            type: "POST",
            async: false,
            data: {
                parentId: id,
                classId: cid
            },
            success: function (result) {
                if (result != null && !jQuery.isEmptyObject(result)) {
                    $("#selUnitList").find("option").remove();
                    $(result).each(function () {
                        var opt = $("<option/>").text(this.unitName).attr("value", this.unitId).attr("ava", this.betweenId);
                        $("#selUnitList").append(opt);
                    })
                    $("#flowModal").modal('show');
                } else {
                    alert("无可选择的流向单位");
                }
            },
            error: function (info) {
            }
        })
    }

    //选择流向单位
    function selectFlowUnit(obj) {
        var s = $(obj).find("option:selected").attr("ava");
        if (s == "0") {
            alert("此分店没有该种类，请先添加种类");
            return;
        }
        //判断是否已经存在
        var allTableData = $('#flowData').bootstrapTable('getData');//获取表格的所有内容行
        var flag = false;
        <!-- 对json数据进行循环 -->
        $.each(allTableData, function (n, v) {
            if (obj.value == $.trim(v.flowId)) {
                flag = true;
            }
        });
        if (flag) {
            alert("已存在该单位，请重新选择！");
        } else {
            var obj = new flow(0, obj.value, obj.selectedOptions[0].text);
            $("#flowData").bootstrapTable("append", obj);
            $('#flowModal').modal('hide');
        }
    }

    //质检机构
    function flow(qid, uid, uName) {
        this.qaId = qid;
        this.flowId = uid;
        this.flowName = uName;
    }

    //获取流向内容
    function getFlows() {
        var list = [];
        var data = $('#flowData').bootstrapTable('getData');
        $.each(data, function (n, v) {
            var obj = new flow(v.qaId, v.flowId, v.flowName);
            list.push(obj);
        });
        return list;
    }

    //保存信息
    function flowSave() {
        var flowSubmit = {
            qaId: qd,
            flowInfo: getFlows()
        };
        $.myloading({title: '正在保存，请稍后...'});
        $.ajax({
            url: "${ctx}/report/addFlowInfo",
            data: JSON.stringify(flowSubmit),
            contentType: "application/json",
            type: "post",
            success: function (result) {
                $.myloading("hide");
                if (result != null) {
                    if (result.result == 1) {
                        alert("保存成功");
                        $("#bundleModal").modal('hide');
                        refresh();
                    } else {
                        alert(result.resultInfo);
                    }
                } else {
                    alert("保存失败");
                }
            },
            error: function (info) {
            }
        })
    }

    function showImage(obj) {
        $("#bigImage").attr("src", "");
        if ($(obj).prev().val() != "") {
            $("#bigImage").attr("src", "${ctx}" + $(obj).prev().val());
            $('#imageModal').modal('show');
        } else if (obj.src != null && obj.src != "") {
            $("#bigImage").attr("src", obj.src);
            $('#imageModal').modal('show');
        } else {
            alert("图片处理中，请耐心等待");
        }
    }
    //删除服务器资源
    function delSource(url) {
        $.ajax({
            url: "${ctx}/report/delSource",
            type: "POST",
            data: {
                url: url
            }
        });
    }

    function playVideo(url) {
        $("#mov").attr("src", "${ctx}" + url);
        $("#videoModal").modal('show');
    }

</script>
</html>
