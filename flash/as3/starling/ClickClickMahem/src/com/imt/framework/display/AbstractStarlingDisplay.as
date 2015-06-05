﻿package com.imt.framework.display{			import com.greensock.TweenMax;	import com.imt.framework.core.dispatcher.Dispatcher;	import com.imt.framework.core.event.SiteEvent;		import starling.display.Sprite;
		public class AbstractStarlingDisplay extends Sprite	{				public var t:TweenMax;		public var eventComplete:String = "";		public var initialized:Boolean = false;		public var autoPlay:Boolean = false;		public var targX:int = 0;		public var targY:int = 0;		public var origX:int = 0;		public var origY:int = 0;		public var targScaleX:Number = 1;		public var targScaleY:Number = 1;		public var origScaleX:Number = 0.05;		public var origScaleY:Number = 0.05;		public var data:Object;		public var index:uint;				public function AbstractStarlingDisplay()		{						super();			t = new TweenMax({},0,{});					}						public function stopTimer():AbstractStarlingDisplay		{						t.kill();			return this;					}								public function update($data:Object):AbstractStarlingDisplay		{						//trace( this + " : update" );						function doUpdate($prop:String):void 			{ 												if( $data[ $prop ] != null ) 				{										data[ $prop ] = $data[ $prop ];									}							}					doUpdate( "targX" );			doUpdate( "targY" );			doUpdate( "origX" );			doUpdate( "origY" );			doUpdate( "targScaleX" );			doUpdate( "targScaleY" );			doUpdate( "origScaleX" );			doUpdate( "origScaleY" );			doUpdate( "index" );					return this;					}						public function timed($seconds:Number):AbstractStarlingDisplay		{						//trace(this + " : timed : " + $seconds)			t.kill();			t = TweenMax.delayedCall( $seconds, timedComplete );			return this;					}						private function timedComplete():void		{						//GlobalDispatcher.dispatchEvent( new SiteEvent( SiteEvent.TIMER_COMPLETE, this, {} ) );			Dispatcher.dispatchEvent( new SiteEvent( SiteEvent.TIMER_COMPLETE ) );					}						public function close():AbstractStarlingDisplay		{						//GlobalDispatcher.dispatchEvent( new SiteEvent( SiteEvent.CLOSE_WINDOW, this, {} ) );			Dispatcher.dispatchEvent( new SiteEvent( SiteEvent.CLOSE_WINDOW ) );			return this;					}			}}