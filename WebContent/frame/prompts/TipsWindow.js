/**
 * 右下角的小贴士窗口
 * 
 * @author tipx.iteye.com
 * @params conf 参考Ext.Window conf中添加autoHide配置项, 默认3秒自动隐藏, 设置自动隐藏的时间(单位:秒),
 *         不需要自动隐藏时设置为false
 * @注: 使用独立的window管理组(manager:new Ext.WindowGroup()), 达到总是显示在最前的效果
 */

Ext.ns('ux');
(function($) {
	// 新建window组，避免被其它window影响显示在最前的效果
	var tipsGroupMgr = new Ext.WindowGroup();
	tipsGroupMgr.zseed = 99999; // 将小贴士窗口前置
	var hideTask; // 隐藏窗口的任务
	var delaySecond; // 延迟隐藏的时间

	$.TipsWindow = Ext.extend(Ext.Window, {
		width : 200,
		height : 150,
		layout : 'fit',
		modal : false,
		plain : true,
		isHide : true, // 隐藏状态
		shadow : false, // 去除阴影
		draggable : false, // 默认不可拖拽
		resizable : false,
		closable : true,
		closeAction : 'hide', // 默认关闭为隐藏
		autoHide : 3, // n秒后自动隐藏，为false时,不自动隐藏
		manager : tipsGroupMgr, // 设置window所属的组
		constructor : function(conf) {
			$.TipsWindow.superclass.constructor.call(this, conf);
			this.initPosition(true);
		},
		initEvents : function() {
			$.TipsWindow.superclass.initEvents.call(this);
			// 自动隐藏
			if (false !== this.autoHide) {
				hideTask = new Ext.util.DelayedTask(this.hide, this);
				delaySecond = (parseInt(this.autoHide) || 3) * 1000;
				this.on('beforeshow', function(self) {
					hideTask.delay(delaySecond);
				});
				this.on('afterrender', this.setDelayHideOnMouseover);
			}
			this.on('beforeshow', this.showTips);
			this.on('beforehide', this.hideTips);

			Ext.EventManager.onWindowResize(this.initPosition, this); // window大小改变时，重新设置坐标
			Ext.EventManager.on(window, 'scroll', this.initPosition, this); // window移动滚动条时，重新设置坐标
		},
		// 参数: flag - true时强制更新位置
		initPosition : function(flag) {
			if (true !== flag && this.hidden) { // 不可见时，不调整坐标
				return false;
			}
			var doc = document, bd = (doc.body || doc.documentElement);
			// ext取可视范围宽高(与上面方法取的值相同), 加上滚动坐标
			var left = bd.scrollLeft + Ext.lib.Dom.getViewWidth() - 4 - this.width;
			var top = bd.scrollTop + Ext.lib.Dom.getViewHeight() - 30 - this.height;
			this.setPosition(left, top);
		},
		showTips : function() {
			this.isHide = false;
			var self = this;
			if (!self.hidden) {
				return false;
			}
			self.initPosition(true); // 初始化坐标
			self.el.slideIn('b', {
				callback : function() {
					// 显示完成后,手动触发show事件,并将hidden属性设置false,否则将不能触发hide事件
					self.fireEvent('show', self);
					self.hidden = false;
				}
			});
			return false; // 不执行默认的show
		},
		hideTips : function() {
			this.isHide = true;
			var self = this;
			if (self.hidden) {
				return false;
			}

			self.el.slideOut('b', {
				callback : function() {
					// 渐隐动作执行完成时,手动触发hide事件,并将hidden属性设置true
					self.fireEvent('hide', self);
					self.hidden = true;
				}
			});
			return false; // 不执行默认的hide
		},
		setDelayHideOnMouseover : function(_thisWin) {
			_thisWin.mon(_thisWin.el, {
				mouseover : function() {
					hideTask.cancel(); // 鼠标悬停时不隐藏窗体
				},
				mouseout : function() {
					hideTask.delay(delaySecond); // 鼠标移开时开启延时隐藏窗体
				}
			});
		}
	});
})(Ext.ux);