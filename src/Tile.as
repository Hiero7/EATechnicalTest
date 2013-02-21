package  
{
	/**
	 * ...
	 * @author Bijan
	 */
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.net.URLRequest; 
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Tile extends Sprite
	{
		[Embed(source = "../assets/64x48.swf", mimeType = "application/octet-stream")] public var Explosion:Class;
		
		private var myWorld:World;
		public var locX:int;
		public var locY:int;
		private var gridHeight:int;
		private var gridWidth:int;
		private var color:uint = 0x000000;
		private var brighterColor:uint = 0xFFFFFF;
		public var active:Boolean = false;
		public var loader:Loader;
	
		private var move:Sound;
		private var destroy:Sound;
		private var explosion:MovieClip;
		
		public function Tile(startX:int, startY:int, height:int, width:int, w:World) 
		{
			myWorld = w;
			locX = startX;
			locY = startY;
			gridHeight = height;
			gridWidth = width;
			color = Math.random() * 0xCCCCCC;
			brighterColor = color + color / 4;
			this.graphics.beginFill(color);
			this.graphics.drawRect(startX, startY, gridHeight, gridWidth);
			this.graphics.endFill();
			
			var req:URLRequest = new URLRequest("../assets/move.mp3");
			move = new Sound(req);
			req = new URLRequest("../assets/destroy.mp3");
			destroy = new Sound(req);
			
			loader = new Loader();
			loader.loadBytes(new Explosion() as ByteArray);
            loader.contentLoaderInfo.addEventListener(Event.INIT, onSwfLoaded);
            //this.addChild(loader);
		}
		private function onSwfLoaded(e:Event):void 
        {
                explosion = loader.content as MovieClip;
				this.addChild(explosion);
				explosion.play();
        }
		//change color to indicate selected block is active
		public function changeColor():void
		{
			if (active)
			{
				this.graphics.clear();
				this.graphics.beginFill(brighterColor);
				this.graphics.drawRect(locX, locY, gridHeight, gridWidth);
				this.graphics.endFill();
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginFill(color);
				this.graphics.drawRect(locX, locY, gridHeight, gridWidth);
				this.graphics.endFill();
			}
		}
		
		public function moveTile(mouseX:Number, mouseY:Number):void
		{
			if (active)
			{
				//normalize mouse location to grid
				var gridX:int = (int)(mouseX/gridWidth)*gridWidth;
				var gridY:int = (int)(mouseY / gridHeight) * gridHeight;
				
				//check if desired position is already taken before moving
				var spaceTaken:Boolean = false;
				for (var i:int = 0; i < myWorld.tiles.length; i++)
				{
					if (gridX == myWorld.tiles[i].locX && gridY == myWorld.tiles[i].locY)
						spaceTaken = true;
				}
				//if it is, destroy this piece
				if (spaceTaken)
				{
					active = false;
					explosion.play();
					destroy.play();
					this.graphics.clear();
					myWorld.tiles.splice(getPosInWorldArray(), 1); //remove it from the tile array to clear up space
					stage.focus = myWorld;  //refocus so keyboard still works
				}
				//otherwise move it
				else
				{
					locX = gridX;
					locY = gridY;
				
					active = false;
					move.play();
					changeColor();
					stage.focus = myWorld;
				}
			}
		}
		
		private function getPosInWorldArray():int
		{
			for (var i:int = 0; i < myWorld.tiles.length; i++)
			{
				if (myWorld.tiles[i] == this)
					return i;
			}
			return 0;
		}
	}

}