package  
{
	/**
	 * ...
	 * @author Bijan
	 */
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class Grid extends Sprite
	{
		
		public function Grid(numColumns:Number, numRows:Number, cellHeight:Number, cellWidth:Number) 
		{
				drawGrid(numColumns, numRows, cellHeight, cellWidth);
		}
		
		private function drawGrid(numColumns:Number, numRows:Number, cellHeight:Number, cellWidth:Number):void 
		{
			//draw a white square so that the entire grid is clickable
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, cellHeight*numRows, cellWidth*numColumns);
			this.graphics.endFill();
			
			this.graphics.lineStyle(2, 0x000000);

			for (var col:Number = 0; col <= numColumns; col++)
			{
				for (var row:Number = 0; row <= numRows; row++)
				{
					//iteratively draw lines to make up the grid. 
					//actual grid positions will be handled by clamped xy-coordinates
					this.graphics.moveTo(col * cellWidth, 0);
					this.graphics.lineTo(col * cellWidth, cellHeight * numRows);
					this.graphics.moveTo(0, row * cellHeight);
					this.graphics.lineTo(cellWidth * numColumns, row * cellHeight);
				}
			}

		}
	}

}