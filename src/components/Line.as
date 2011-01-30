package components
{
    import flash.display.Graphics;
    import flash.geom.Point;
    /**
     * @author dimitri
     */
    public class Line
    {
        private var _to : Point;
        private var _from : Point;
        
    	public function Line(from:Point, to:Point)
    	{
    		_from = from;
    		_to = to;
    	}
    	
    	public function drawLine(graphics:Graphics):void
    	{
    		graphics.clear();
    		graphics.lineStyle(2,0x7575ff,0.8);
    		graphics.moveTo(_from.x,_from.y);
            graphics.lineTo(_to.x, _to.y);
        }

        public function set to(to : Point) : void
        {
            _to = to;
        }

        public function get from() : Point
        {
            return _from;
        }

        public function get to() : Point
        {
            return _to;
        }
    }
}
