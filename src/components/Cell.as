package components
{
    import com.bit101.components.Label;

    import flash.display.Sprite;

    /**
     * @author dimitri
     */
    public class Cell extends Sprite
    {
		private var _id:Label;
		private var _size:int;
        public function Cell(id:String)
        {
       		_id = new Label(this);
       		_id.text = id;
       		addChild(_id);
       		drawCell(0x000000,0xffffff);
        }
        
        public function select():void
        {
        	drawCell(0xff4f4f,0xff4f4f);
        }
        
        public function deselect():void
        {
        	drawCell(0x000000,0xffffff);
        }
        
        private function drawCell(color:int,fill:int):void
        {
        	graphics.clear();
        	graphics.moveTo(-_size/2, -_size/2);
        	graphics.beginFill(fill,0.6);
        	graphics.lineStyle(2,color);
        	graphics.lineTo(-_size/2, _size/2);
        	graphics.lineTo(_size/2, _size/2);
        	graphics.lineTo(_size/2, -_size/2);
        	graphics.lineTo(-_size/2, -_size/2);
        	graphics.endFill();
        	
        }
        
        public function set size(size:int):void
        {
        	_size = size;
        	drawCell(0x000000,0xffffff);
        }
    }
}
