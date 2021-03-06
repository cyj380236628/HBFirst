﻿<%@ Page Language="C#" AutoEventWireup="true" Inherits="FlowWeb.StepDialog" CodeBehind="StepDialog.aspx.cs" %>

<html>
<head>
    <title>Step Properties </title>
    <link rel="stylesheet" type="text/css" href="inc/style.css">
    <link rel="stylesheet" type="text/css" href="inc/webTab/webtab.css">
    <script language="jscript" src="inc/function.js"></script>
    <script language="jscript" src="inc/shiftlang.js"></script>
    <script language="jscript" src="inc/webTab/webTab.js"></script>
    <style>
        body
        {
            background-color: buttonface;
            scroll: no;
            margin: 7px, 0px, 0px, 7px;
            border: none;
            overflow: hidden;
        }
    </style>
    <script language="JavaScript">
<!--
        function iniWindow() {
            var opener = window.dialogArguments;
            var url = opener.dialogURL;
            var stepId = url.indexOf('?stepid=') < 0 ? '' : url.slice(url.indexOf('?stepid=') + 8, url.length);

            try {
                if (opener.LANG != '') shiftLanguage(opener.LANG, "stepdialog");

                var FlowXML = opener.document.all.FlowXML;
                if (stepId == '') {
                    atNewStep();
                } else {
                    if (FlowXML.value != '') {
                        atEditStep(FlowXML, stepId);
                    } else {
                        alert('打开流程属性对话框时出错！');
                        window.close();
                    }
                }
            } catch (e) {
                alert('打开步骤属性对话框时出错！');
                window.close();
            }
        }

        function okOnClick() {
            var opener = window.dialogArguments;
            var url = opener.dialogURL;
            var stepId = url.indexOf('?stepid=') < 0 ? '' : url.slice(url.indexOf('?stepid=') + 8, url.length);
            try {
                var FlowXML = opener.document.all.FlowXML;

                xml = getStepXML(FlowXML, stepId);
                if (xml != '') {
                    FlowXML.value = xml;
                    window.close();
                }

            } catch (e) {
                alert('关闭步骤属性对话框时出错！');
                window.close();
            }
        }
        function cancelOnClick() {
            window.close();
        }
        function applyOnClick() {
            var opener = window.dialogArguments;
            var url = opener.dialogURL;
            var stepId = url.indexOf('?stepid=') < 0 ? '' : url.slice(url.indexOf('?stepid=') + 8, url.length);

            try {
                var FlowXML = opener.document.all.FlowXML;

                xml = getStepXML(FlowXML, stepId);
                if (xml != '') {
                    FlowXML.value = xml;
                    btnApply.disabled = true;
                }
            } catch (e) {
                alert('应用步骤属性时出错！');
                window.close();
            }
        }

        function atNewStep() { }
        function atEditStep(FlowXML, stepId) {
            var xmlDoc = new ActiveXObject('MSXML2.DOMDocument');
            xmlDoc.async = false;
            xmlDoc.loadXML(FlowXML.value);
            var xmlRoot = xmlDoc.documentElement;
            var Steps = xmlRoot.getElementsByTagName("Steps").item(0);
            for (var i = 0; i < Steps.childNodes.length; i++) {
                Step = Steps.childNodes.item(i);
                nId = Step.getElementsByTagName("BaseProperties").item(0).getAttribute("id");
                if (nId == stepId) {
                    document.all.StepId.value = stepId;
                    document.all.StepText.value = Step.getElementsByTagName("BaseProperties").item(0).getAttribute("text");
                    setRadioGroupValue(document.all.StepType, Step.getElementsByTagName("BaseProperties").item(0).getAttribute("stepType"));
                    setRadioGroupValue(document.all.StepUnion, Step.getElementsByTagName("BaseProperties").item(0).getAttribute("unionPass"));

                    document.all.StepIndex.value = Step.getElementsByTagName("BaseProperties").item(0).getAttribute("stepIndex");
                    document.all.Width.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("width");
                    document.all.Height.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("height");
                    document.all.X.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("x");
                    document.all.Y.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("y");
                    document.all.TextWeight.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("textWeight");
                    document.all.StrokeWeight.value = Step.getElementsByTagName("VMLProperties").item(0).getAttribute("strokeWeight");

                    document.all.StepPeople.value = Step.getElementsByTagName("FlowProperties").item(0).getAttribute("people").replace(/\$/g, "'");
                    break;
                }
            }

        }

        function getStepXML(FlowXML, stepId) {
            id = document.all.StepId.value;
            text = document.all.StepText.value;
            stepType = getRadioGroupValue(document.all.StepType);
            stepIndex = document.all.StepIndex.value;
            unionPass = getRadioGroupValue(document.all.StepUnion);
            if (id == '') { alert('请先填写步骤编号！'); return ''; }
            if (text == '') { alert('请先填写步骤名称！'); return ''; }
            if (stepIndex == '') { alert('请填写步骤序号！'); return ''; }
            if (!checkNumberHelp(document.all.StepIndex, '步骤序号应是大于0小于100的整数')) { return ''; }
            if (!checkIntRangeHelp(document.all.StepIndex, '', '步骤序号应大于0小于100', 99, 1)) { return ''; }
           

            width = document.all.Width.value;
            height = document.all.Height.value;
            x = document.all.X.value;
            y = document.all.Y.value;
            textWeight = document.all.TextWeight.value;
            strokeWeight = document.all.StrokeWeight.value;
            people = document.all.StepPeople.value;
            var xml = "";
            //生成步骤xml
            xml += '<Step><BaseProperties id="' + id + '" text="' + text + '" stepType="' + stepType + '" stepIndex="' + stepIndex + '" unionPass="' + unionPass + '"/>';
            xml += '<VMLProperties width="' + width + '" height="' + height + '" x="' + x + '" y="' + y + '" textWeight="' + textWeight + '" strokeWeight="' + strokeWeight + '" zIndex="" />';
            xml += '<FlowProperties people= "' + people + '" /></Step>';

            var xmlDoc = new ActiveXObject('MSXML2.DOMDocument');
            xmlDoc.async = false;
            xmlDoc.loadXML(FlowXML.value);
            var xmlRoot = xmlDoc.documentElement;
            var Steps = xmlRoot.getElementsByTagName("Steps").item(0);
            //添加：查找编号冲突的Id
            //修改：查找原来的Id
            for (var i = 0; i < Steps.childNodes.length; i++) {
                Step = Steps.childNodes.item(i);
                nId = Step.getElementsByTagName("BaseProperties").item(0).getAttribute("id");
                index = Step.getElementsByTagName("BaseProperties").item(0).getAttribute("stepIndex");
                if (nId == id && stepId == '') {
                    alert('新步骤编号已存在！请重新输入！'); 
                    return '';
                }
                if (index == stepIndex && nId!=id) {
                    alert('步骤序号已存在！请重新输入！');
                    document.all.StepIndex.value = '';
                    return '';
                }
                if (nId == stepId && stepId != '') {
                    Steps.removeChild(Step); break;
                }
            }
            var xmlDoc2 = new ActiveXObject('MSXML2.DOMDocument');
            xmlDoc2.async = false;
            xmlDoc2.loadXML(xml);
            Steps.appendChild(xmlDoc2.documentElement);
            return xmlRoot.xml;
        }
//-->
    </script>
</head>
<body onload='iniWindow()' onunload=''>
    <table border="0" cellpadding="0" cellspacing="0" height="385px">
        <thead>
            <tr id="WebTab">
                <td class="selectedtab" id="tab1" onmouseover='hoverTab("tab1")' onclick="switchTab('tab1','contents1');">
                    <span id="tabpage1">基本属性</span>
                </td>
                <td class="tab" id="tab2" onmouseover='hoverTab("tab2")' onclick="switchTab('tab2','contents2');">
                    <span id="tabpage2">图表属性</span>
                </td>
                <td class="tab" id="tab3" onmouseover='hoverTab("tab3")' onclick="switchTab('tab3','contents3');">
                    <span id="tabpage3">步骤人员</span>
                </td>
                <td class="tabspacer" width="140">
                    &nbsp;
                </td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td id="contentscell" colspan="5">
                    <!-- Tab Page 1 Content Begin -->
                    <div class="selectedcontents" id="contents1">
                        <table border="0" width="100%" height="100%">
                            <tr valign="top">
                                <td>
                                </td>
                                <td width="100%" valign="top">
                                    <fieldset style="border: 1px solid #C0C0C0;">
                                        <legend align="left" style="font-size: 9pt;">&nbsp;<span id="tabpage1_1">基本属性</span>&nbsp;</legend>
                                        <table border="0" width="100%" height="100%" style="font-size: 9pt;">
                                            <tr valign="top" style="display: none">
                                                <td width="5">
                                                </td>
                                                <td>
                                                    <span id="tabpage1_2">步骤编号</span>&nbsp;&nbsp;<input type="text" name="StepId" value="<%=GetGuid()%>"
                                                        class="txtput" disabled="disabled">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage1_3">步骤名称</span>&nbsp;&nbsp;<input type="text" name="StepText" value=""
                                                        class="txtput" style="border-color: Red; width: 220px">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage1_url">步骤顺序</span>&nbsp;&nbsp;<input type="text" name="StepIndex"
                                                        value="" class="txtput" style="border-color: Red; width: 220px">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage1_4">步骤类型</span>&nbsp;&nbsp;<font style="font-size: 10pt;" color="#919CD0"><input
                                                        type="radio" name="StepType" value="BeginStep" disabled="disabled"><span id="tabpage1_5">开始步骤</span>&nbsp;<input
                                                            type="radio" name="StepType" value="EndStep" disabled="disabled"><span id="tabpage1_6">结束步骤</span>&nbsp;<input
                                                                type="radio" name="StepType" value="NormalStep" checked="checked" disabled="disabled"><span
                                                                    id="tabpage1_7">中间步骤</span>&nbsp;</font>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="Span1">通过类型</span>&nbsp;&nbsp;<font style="font-size: 10pt;" color="#919CD0"><input
                                                        type="radio" name="StepUnion" value="1"><span id="Span3">多人同时通过</span>&nbsp;<input
                                                            type="radio" name="StepUnion" value="0" checked="checked"><span id="Span4">一人通过即可</span>&nbsp;</font>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr height="3">
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            <tr height="100%">
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- Tab Page 1 Content End -->
                    <!-- Tab Page 2 Content Begin -->
                    <div class="contents" id="contents2">
                        <table border="0" width="100%" height="100%">
                            <tr valign="top">
                                <td>
                                </td>
                                <td width="100%" valign="top">
                                    <fieldset style="border: 1px solid #C0C0C0;">
                                        <legend align="left" style="font-size: 9pt;">&nbsp;<span id="tabpage2_1">坐标与大小</span>&nbsp;</legend>
                                        <table border="0" width="100%" height="100%" style="font-size: 9pt;">
                                            <tr valign="top">
                                                <td width="5">
                                                </td>
                                                <td>
                                                    <span id="tabpage2_2">图形宽度</span>&nbsp;&nbsp;<input type="text" name="Width" value="200"
                                                        class="txtput">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage2_3">图形高度</span>&nbsp;&nbsp;<input type="text" name="Height" value="200"
                                                        class="txtput">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage2_4">图形X坐标</span>&nbsp;&nbsp;<input type="text" name="X" value="1792px"
                                                        class="txtput" style="width: 190px">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage2_5">图形Y坐标</span>&nbsp;&nbsp;<input type="text" name="Y" value="2px"
                                                        class="txtput" style="width: 190px">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr height="3">
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            <tr valign="top">
                                <td>
                                </td>
                                <td width="100%" valign="top">
                                    <fieldset style="border: 1px solid #C0C0C0;">
                                        <legend align="left" style="font-size: 9pt;">&nbsp;<span id="tabpage2_6">步骤样式</span>&nbsp;</legend>
                                        <table border="0" width="100%" height="100%" style="font-size: 9pt;">
                                            <tr valign="top">
                                                <td width="5">
                                                </td>
                                                <td>
                                                    <span id="tabpage2_7">文本大小</span>&nbsp;&nbsp;<input type="text" name="TextWeight"
                                                        value="" class="txtput">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                </td>
                                                <td>
                                                    <span id="tabpage2_8">边框粗细</span>&nbsp;&nbsp;<input type="text" name="StrokeWeight"
                                                        value="" class="txtput">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr height="3">
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            <tr height="100%">
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- Tab Page 2 Content End -->
                    <!-- Tab Page 3 Content Begin -->
                    <div class="contents" id="contents3">
                        <table width="100%" height="100%" style="font-size: 10pt;">
                            <tr>
                                <td width="100%" valign="top">
                                    <fieldset style="border: 1px solid #C0C0C0;">
                                        <legend align="left" style="font-size: 9pt;">&nbsp;<span id="Span2">人员选择</span>&nbsp;</legend>
                                        <textarea style="margin: 10,0,10,10; width: 315px" rows="20" class="txtput" name="StepPeople"></textarea>
                                        <br />
                                        <table border="0" cellpadding="0" cellspacing="0" style="margin: 0,0,10,10">
                                            <tr>
                                                <td>
                                                    <div align="left">
                                                        <img src="images/22.gif" width="14" alt="选择" onclick="workFlowDialog()" height="14"
                                                            style="cursor: hand" /></div>
                                                </td>
                                                <td>
                                                    <div align="left" style="cursor: hand" onclick="workFlowDialog()">
                                                        选择</div>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <!-- Tab Page 3 Content End -->
                </td>
            </tr>
        </tbody>
    </table>
    <table cellspacing="1" cellpadding="0" border="0" style="position: absolute; top: 400px;
        left: 0px;">
        <tr>
            <td width="100%">
            </td>
            <td>
                <input type="button" id="btnOk" class="btn" value="确 定" onclick="jscript: okOnClick();">&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                <input type="button" id="btnCancel" class="btn" value="取 消" onclick="jscript: cancelOnClick();">&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                <input type="button" id="btnApply" class="btn" value="应 用" onclick="jscript: applyOnClick();">&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
    </table>
</body>
</html>
<script type="text/javascript" language="javascript">
    function workFlowDialog() {
        var dialogURL = '/SysManage/Window_RoleList.aspx'
        var dialog = window.showModalDialog(dialogURL, window, "dialogWidth:473px; dialogHeight:260px; center:yes; help:no; resizable:no; status:no;");
        if (typeof (dialog) != "undefined") {
            document.all.StepPeople.value = dialog;
            //window.location.href = window.location.href;
            //window.location.reload;
        }
    }
</script>
