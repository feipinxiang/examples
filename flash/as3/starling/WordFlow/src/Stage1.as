﻿package 
{
	
	
	import com.bedrock.extras.util.MathUtil;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Power3;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.imt.assets.Assets;
	import com.imt.framework.core.dispatcher.StarlingDispatcher;
	import com.imt.framework.display.AbstractStarlingDisplay;
	import com.imt.framework.display.IDisplay;
	import com.imt.framework.event.StarlingSiteEvent;
	import com.imt.game.gadgets.MemoryCardsManager;
	import com.imt.game.vehicles.Plane;
	import com.imt.objects.ParallaxBackground;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	
	public class Stage1 extends AbstractStarlingDisplay implements IDisplay
	{
		
		
		// Stage objects.
		private var bg:IDisplay;
		private var _rocket:IDisplay;
		private var _plane:IDisplay;
		// Game.
		private var _cardAtlas:TextureAtlas;
		private var _cardXML:XML;
		private var assets:Assets;
		private var _timeline:TimelineMax;

		
		// Constructor.
		public function Stage1()
		{
			super();
			name = "Stage1";
			addEventListener( starling.events.Event.ADDED_TO_STAGE, onEvent);
			
		}
		
		
		public function initialize($data:Object=null):void
		{
			
			if( !initialized ) 
			{
				
				trace(this + " : initialize");
				TweenPlugin.activate( [ AutoAlphaPlugin, ColorTransformPlugin, ScalePlugin ] );
				StarlingDispatcher.addEventListener( StarlingSiteEvent.START_GAME, onEvent );
				visible = false;
				// Assign assets to be loaded.
				var path:String = Assets.ASSETS_PATH + "media/graphics/games/memory_plane_game/stages/stage1/";
				Assets.showTraces( false );
				Assets.createLoader( name );
				// Load Sprite sheets.
				Assets.appendXML( name, new XMLLoader( path + "Stage1_0.xml", {  } ), "Stage1_0.xml" );
				Assets.appendXML( name, new XMLLoader( path + "Stage1_1.xml", {  } ), "Stage1_1.xml" );
				Assets.appendTexture( name, new ImageLoader( path + "Stage1_0.png", {  } ), "Stage1_0.png" );
				Assets.appendTexture( name, new ImageLoader( path + "Stage1_1.png", {  } ), "Stage1_1.png" );
				Assets.appendSfx( name, new MP3Loader( Assets.ASSETS_PATH + "media/sounds/memory_game/music/stages/City2.mp3", { autoPlay:false, volume:0.9, repeat:-1  } ), "Stage_1" );
				Assets.appendSfx( name, new MP3Loader( Assets.ASSETS_PATH + "media/sounds/memory_game/plane/PlaneStartup.mp3", { autoPlay:false, volume:0.6, repeat:0  } ), "PlaneStartup" );
				Assets.appendSfx( name, new MP3Loader( Assets.ASSETS_PATH + "media/sounds/memory_game/plane/PlaneTravel.mp3", { autoPlay:false, volume:.7, repeat:-1  } ), "PlaneTravel" );
				Assets.appendSfx( name, new MP3Loader( Assets.ASSETS_PATH + "media/sounds/memory_game/plane/PlaneTakeoff.mp3", { autoPlay:false, volume:0.9, repeat:0  } ), "PlaneTakeoff" );
				StarlingDispatcher.addEventListener( StarlingSiteEvent.ASSETS_LOADED, _onAssetsReady );
				Assets.load( name );
 				
			}
			
		}
		
		
		public function refresh():void
		{
			
			trace(this + " : refresh");
			if( !initialized ) initialize();
			// Event listeners.
			StarlingDispatcher.addEventListener( StarlingSiteEvent.PAUSE, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.RESUME, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.CARDS_MATCHED, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.WIN, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.LOSE, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.TIMER_COMPLETE, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.NO_MATCH, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.START_GAME, onEvent );
			StarlingDispatcher.addEventListener( StarlingSiteEvent.PLAY_AGAIN, onEvent );
			// Update the satege in app.
			StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.UPDATE_STAGE, { name:name } ) );
			// static MemoryCardsManager.
			( Assets.MEMORY_CARDS_MANAGER as MemoryCardsManager ).setCurrentStage( name );
			//
			//Assets.getSfx("PlaneTakeoff").pause();
			bg.refresh();
			// Visiblity.
			visible = true;
			// Plane stuff.
			with( _plane as Plane )
			{
				
				x = -500;
				y = groundY;
				rotation = 0;
				
			}
			// Call intro().
			intro();
			
		}
		
		
		public function clear():void
		{
			
			trace(this + " : clear");
			visible = false;
			// Event listeners.
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.PAUSE, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.RESUME, onEvent );
			StarlingDispatcher.removeEventListener( starling.events.Event.ENTER_FRAME, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.WIN, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.LOSE, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.TIMER_COMPLETE, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.NO_MATCH, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.START_GAME, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.PLAY_AGAIN, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.CARDS_MATCHED, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED, onEvent );
			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, onEvent );
			// Sound.
			Assets.getSfx( "Stage_1" ).pauseSound();
			Assets.getSfx( "PlaneStartup" ).pauseSound();
			Assets.getSfx( "PlaneTravel" ).pauseSound();
			Assets.getSfx( "PlaneTakeoff" ).pauseSound();
	/*		Assets.getSfx( "PLANE_OUTRO_SPUTTERS_SND" ).pauseSound();
			Assets.getSfx( "PLANE_COASTING_SND" ).pauseSound();
			Assets.getSfx( "PLANE_FLIES_OFF_SND" ).pauseSound();
			Assets.getSfx( "PLANE_IDLE_SND" ).pauseSound();*/
			// Parallax BG.
			bg.clear();
			// Plane.
			_plane.clear();
			( _plane as Plane ).x = -500;
			( _plane as Plane ).y = ( _plane as Plane ).groundY;
			
		}
		
		
		public function start():void{};
		
		
		public function intro():void
		{
			
			trace( this + " : intro()" );
			Assets.getSfx( "Stage_1" ).gotoSoundTime( 0, true );
			Assets.getSfx("PlaneStartup").gotoSoundTime(0, true);
			Assets.getSfx("PlaneTravel").gotoSoundTime(0, true);
		//	trace ("IM PUTTING THE PLANE TAKEOFF HERE SO GET READY TO TAKEOFF PLANE!");
			//Assets.getSfx("PlaneTakeoff").gotoSoundTime(0,false);
			//Assets.getSfx("PlaneTakeoff").pause();
			//Assets.getSfx( "PLANE_COASTING_SND" ).playSound();
			TweenMax.fromTo( _plane, 4, { x:-500, y:( _plane as Plane ).groundY, shortRotation:{ rotation:MathUtil.degreesToRadians( 0 ) } }, { x:( _plane as Plane ).centerX, ease:Power3.easeOut } );
			bg.intro();
			Assets.getSfx("PlaneTakeoff").pause();
		}
		
		
		public function outro():void
		{
			
			trace( this + " : outro()" );
			TweenMax.to( _plane, 2, { y:( _plane as Plane ).groundY, ease:Power3.easeOut, overwrite:2 } );
			TweenMax.to( _plane, 8, { x:-300, ease:Power3.easeOut, overwrite:2 } );
			bg.outro();
			
		}
		
		
		public function cancel():void{};
		public function destroy():void
		{
			
			trace( this + " : destroy()" );
			clear();
			//MonsterDebugger.trace( this, Assets.getLoader( name ) );
			//Assets.getLoader( name ).dispose( true );
			Assets.disposeLoader( name );
			Assets.getTextureAtlas( "Stage1_0" ).dispose();
			Assets.getTextureAtlas( "Stage1_1" ).dispose();
			// Destroy the sequences that weere created.
			( Assets.MEMORY_CARDS_MANAGER as MemoryCardsManager ).destroySequences( name );
			// Child display objects.
			removeChild( bg as Sprite );
			bg.destroy();
			removeChild( _plane as Sprite );
			_plane.destroy();
			// End.
			initialized = false;
			
		}
		
		
		protected function _onAssetsReady(event:StarlingSiteEvent):void
		{
			
			if( event.data.name == name )
			{
				
				trace(this + " : _onAssetsReady " + event.type + " : " + event.data.name);
				// Create atlases.
				Assets.createTextureAtlas( "Stage1_0", Assets.getTexture( "Stage1_0.png" ), Assets.getXML( "Stage1_0.xml" )  );
				Assets.createTextureAtlas( "Stage1_1", Assets.getTexture( "Stage1_1.png" ), Assets.getXML( "Stage1_1.xml" )  );
				// Event.
				StarlingDispatcher.removeEventListener( StarlingSiteEvent.ASSETS_LOADED, _onAssetsReady );
				// Add Bitmap as BG here.
				bg = new ParallaxBackground;
				bg.initialize();
				( bg as ParallaxBackground ).speed = 0;
				addChild( bg as Sprite );
				// Plane.
				_plane = new Plane;
				with( _plane as Plane )
				{
					
					x = -500;
					groundY = y = 540;//620;
					rotation = 0;
					centerX = 500;
					
				}
				addChild( _plane as Plane );
				// An instance of MemoryCardsManager is created in GameOverlay and saved into the Assets class as Assets.MEMORY_CARDS_MANAGER for other classes use.
				( Assets.MEMORY_CARDS_MANAGER as MemoryCardsManager ).setCurrentStage( name );
				//( Assets.MEMORY_CARDS_MANAGER as MemoryCardsManager ).createSequences( name, [ 4, 4 ] );
				( Assets.MEMORY_CARDS_MANAGER as MemoryCardsManager ).createSequences( name, [ 4, 4, 4, 4, 6, 6, 6, 6 ] );
				// Set initialized property.
				initialized = true;
				dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.INITIALIZE_COMLETE ) );
				
			}
			
		}	
		
		
		private function onPlaneComplete():void
		{
			
			trace(this + " : onPlaneComplete");
			//Assets.getSfx( "PLANE_IDLE_SND" ).playSound();
			
		}
		
		
		// Class event handler.
		private function onEvent(event:starling.events.Event):void
		{
			
			trace(this + " : " + event.type);
			var Y:String;
			var pb:ParallaxBackground = ( bg as ParallaxBackground );
			//var p:Rocket = ( _rocket as Rocket );
			
			switch( event.type )
			{
				
				case StarlingSiteEvent.PAUSE:
					bg.clear();
					Assets.getSfx( "Stage_1" ).pauseSound();
					Assets.getSfx( "PlaneStartup" ).pauseSound();
					Assets.getSfx( "PlaneTravel" ).pauseSound();
					Assets.getSfx( "PlaneTakeoff" ).pauseSound();
					break;
				
				case StarlingSiteEvent.RESUME:
					bg.refresh();
					Assets.getSfx( "Stage_1" ).playSound();
					Assets.getSfx( "PlaneStartup" ).playSound();
					Assets.getSfx( "PlaneTravel" ).playSound();
				  //Assets.getSfx( "PlaneTakeoff" ).playSound();
					break;
				
				case StarlingSiteEvent.LOSE:
					/*Assets.getSfx( "PLANE_COASTING_SND" ).pauseSound();
					Assets.getSfx( "PLANE_FLIES_OFF_SND" ).pauseSound();
					Assets.getSfx( "PLANE_IDLE_SND" ).pauseSound();
					Assets.getSfx( "PLANE_OUTRO_SPUTTERS_SND" ).playSound();*/
					outro();
					break;
				
				case StarlingSiteEvent.WIN:
					trace(this + " : " + event.type);
					TweenMax.to( _plane, 2.5, { x:1800, y:100, shortRotation:{ rotation:MathUtil.degreesToRadians( -30 ) }, ease:Power3.easeIn, onComplete:onPlaneComplete, overwrite:2 } );//overwrite:5, 
					TweenMax.delayedCall( 2, bg.outro );
					// Audio.
					/*Assets.getSfx( "PLANE_OUTRO_SPUTTERS_SND" ).pauseSound();
					Assets.getSfx( "PLANE_COASTING_SND" ).pauseSound();
					Assets.getSfx( "PLANE_FLIES_OFF_SND" ).playSound();*/
					Assets.getSfx( "PlaneStartup" ).pauseSound();
					Assets.getSfx( "PlaneTravel" ).pauseSound();
					Assets.getSfx("PlaneTakeoff").gotoSoundTime(0,false);
					Assets.getSfx( "PlaneTakeoff" ).playSound();
					break;
				
				case StarlingSiteEvent.NO_MATCH:
					trace( this + " : " + event.type );
					//Assets.getSfx( "PLANE_FLIES_OFF_SND" ).playSound();
					_swayVehicle( -80, -0.05 );
					break;
				
				case StarlingSiteEvent.MATCHED:
					trace( this + " : " + event.type );
					break;
				
				case StarlingSiteEvent.CARDS_MATCHED:
					trace( this + " : StarlingSiteEvent.CARDS_MATCHED" );
					pb.speed += 8;
					_swayVehicle( 100, 0.15 );
					break;
				
				case StarlingSiteEvent.MATCHED_SEQUENCE:
					trace( this + " : StarlingSiteEvent.MATCHED_SEQUENCE" );
					break;
				
				case StarlingSiteEvent.DONE:
					outro();
					break;
				
				case StarlingSiteEvent.PLAY_AGAIN:
					trace(this + " : " + event.type);
				//	Assets.getSfx("PlaneTakeoff").gotoSoundTime(0, false);
					refresh();
					break;
				
				case StarlingSiteEvent.PLAY_GAME:
					trace(this + " : " + event.type);
					break;
				
				case StarlingSiteEvent.START_GAME:
					trace(this + " : " + event.type);
					break;
				
				case starling.events.Event.ADDED_TO_STAGE:
					removeEventListener( starling.events.Event.ADDED_TO_STAGE, onEvent);
					if( !initialized ) initialize();
					break;
				
				case starling.events.Event.ENTER_FRAME:
					trace(this + " : " + event.type);
					break;
				
				default:
					trace(this + " : Unhandled event - " + event.type );
					
			}
			
		}
		
		
		private function  _swayVehicle( $x:int, $speed:Number ):void
		{
			
			trace(this + " : _swayVehicle " + $x );
			
			_timeline = new TimelineMax;
			/*
			var arr:Array = [];
			var c:int = ( _rocket as Rocket ).centerX;
			arr.push( new TweenMax( _rocket, 1, {  x:c + $x, overwrite:2 } ) );
			arr.push( new TweenMax( _rocket, 3, {  x:c, ease:Power2.easeInOut, overwrite:2 } ) );
			_timeline.appendMultiple( arr, 0, TweenAlign.SEQUENCE );
			*/
			
			
			//( _rocket as Rocket ).speed += $speed;
			//( _plane as Plane ).speed += $speed;
			
		}
		
		
	}
	
	
}