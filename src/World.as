package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Bijan
	 */
	[SWF(width = "645", height = "645")]
	public class World extends Sprite
	{
		private var grid:Grid;
		private var gridCol:int = 8;
		private var gridRow:int = 8;
		private var gridWidth:int = 80;
		private var gridHeight:int = 80;
		private var numTiles:int = 3;
		public var tiles:Array;
			
		public function World():void 
		{
			stage.focus = this; //need to add this or keyboard doesn't work
			
			grid = new Grid(gridCol, gridRow, gridHeight, gridWidth);
			addChild(grid);
			
			tiles = new Array();
			for (var i:int = 0; i < numTiles; i++)
			{
				var spaceTaken:Boolean = true;
				
				var row:int = Math.random() * gridRow;
				var col:int = Math.random() * gridCol;
				//check if space is already taken (assume it is at first)
				while (spaceTaken && tiles.length <(gridRow*gridCol))
				{
					spaceTaken = false;
					//if the space is in fact taken, it will be reset to true, otherwise the loop will complete
					for (var j:int = 0; j < tiles.length; j++)
					{

						if (col*gridWidth == tiles[j].locX && row*gridHeight == tiles[j].locY)
						{
							spaceTaken = true;
							row = Math.random() * gridRow; //grab new spaces and check again
							col = Math.random() * gridCol;
						}
					}
				}
				//once a free space is found, create a tile there and add it to the list
				tiles.push(new Tile(col*gridWidth, row*gridHeight, gridHeight, gridWidth, this));
				addChild(tiles[i]);
			}
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onSpaceBar);
		}
		
		private function onClick(event:MouseEvent):void 
		{ 
			if (getQualifiedClassName(event.target) == "Tile")
			{
				//check if any other tiles are active. If one is, move/destroy the active tile.
				var anyOtherActive:Boolean = false;
				var activeTile:int = 0;
				for (var i:int = 0; i < tiles.length; i++)
				{
					if (tiles[i].active  && event.target != tiles[i])
					{
						anyOtherActive = true;
						activeTile = i;

					}
				}
				//if already active, set inactive, if inactive, set active
				if (event.target.active)
				{
					event.target.active = false;
					event.target.changeColor();
				}
				else if(!event.target.active && anyOtherActive == false)
				{
					event.target.active = true;
					event.target.changeColor();
				}
				else
				{
					//attempt to move active tile onto new tile so it destroys itself
					tiles[activeTile].moveTile(event.localX, event.localY); 
				}
			}
			else if (getQualifiedClassName(event.target) == "Grid")
			{
				for (i = 0; i < tiles.length; i++)
				{
					if (tiles[i].active)
					{
						tiles[i].moveTile(event.localX, event.localY);
					}
				}
			}
		}
		
		private function onSpaceBar(event:KeyboardEvent):void
		{
			//spawn new block when spacebar pressed
			//same tile generation code as above
			if (event.keyCode == 32 && tiles.length <(gridRow*gridCol)) //make sure it doesn't continue adding when the grid is full
			{
				trace(tiles.length);
				var spaceTaken:Boolean = true;
					
				var row:int = Math.random() * gridRow;
				var col:int = Math.random() * gridCol;

				while (spaceTaken && tiles.length <(gridRow*gridCol)) //make sure the program doesn't freeze when the grid is full
				{
					spaceTaken = false;
					for (var j:int = 0; j < tiles.length; j++)
					{

						if (col*gridWidth == tiles[j].locX && row*gridHeight == tiles[j].locY)
						{
							spaceTaken = true;
							row = Math.random() * gridRow;
							col = Math.random() * gridCol;
						}
					}
				}
				tiles.push(new Tile(col*gridWidth, row*gridHeight, gridHeight, gridWidth, this));
				addChild(tiles[tiles.length - 1]);
			}
		}
	}
}
		

	
