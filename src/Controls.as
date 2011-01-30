package
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import com.bit101.components.HUISlider;
    import com.bit101.components.Window;

    import flash.display.DisplayObjectContainer;

    /**
     * @author dimitri
     */
    public class Controls extends Window
    {

        private var _sizeSlider : HUISlider;
        private var _columnsSlider : HUISlider;
        private var _cellsSlider : HUISlider;
        private var _offsetXSlider : HUISlider;
        private var _offsetYSlider : HUISlider;
        
        public function Controls(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, title : String = "Window")
        {
            super(parent, xpos, ypos, title);
            this.width = 200;
            this.height = 150;
            this.title = "Parameters";
            this.draggable = false;
            setupControls();
            setDefaults();
        }

        private function setDefaults() : void
        {
        	_sizeSlider.value = 50;
        	_columnsSlider.value = 10;
        	_cellsSlider.value = 40;
        	_offsetXSlider.value = 0;
        }

        private function setupControls() : void
        {
        	_sizeSlider = new HUISlider();
        	_sizeSlider.label = "Cell Size";
        	_sizeSlider.x = 10;
        	_sizeSlider.y = 50;
        	_sizeSlider.minimum = 50;
        	_sizeSlider.maximum = 150;
        	_sizeSlider.tick = 1;
        	
        	addChild(_sizeSlider);
        	
        	_columnsSlider = new HUISlider();
        	_columnsSlider.label = "Columns";
        	_columnsSlider.x = 10;
        	_columnsSlider.y = 35;
        	_columnsSlider.minimum = 2;
        	_columnsSlider.maximum = 10;        	
        	_columnsSlider.tick = 1;
        	
        	addChild(_columnsSlider);
        	
        	_cellsSlider = new HUISlider();
        	_cellsSlider.label = "Cells";
        	_cellsSlider.x = 10;
        	_cellsSlider.y = 20;
        	_cellsSlider.minimum = 1;
        	_cellsSlider.maximum = 100;
        	_cellsSlider.tick = 1;
        	
            addChild(_cellsSlider);
            
            _offsetXSlider = new HUISlider();
        	_offsetXSlider.label = "Offset X";
        	_offsetXSlider.x = 10;
        	_offsetXSlider.y = 65;
        	_offsetXSlider.minimum = -200;
        	_offsetXSlider.maximum = 200;
        	_offsetXSlider.tick = 1;
        	
            addChild(_offsetXSlider);
            
            _offsetYSlider = new HUISlider();
        	_offsetYSlider.label = "Offset Y";
        	_offsetYSlider.x = 10;
        	_offsetYSlider.y = 80;
        	_offsetYSlider.minimum = -200;
        	_offsetYSlider.maximum = 200;
        	_offsetYSlider.tick = 1;
        	
            addChild(_offsetYSlider);
            
            _columnsSlider.addEventListener(Event.CHANGE, onChange);
            _offsetXSlider.addEventListener(Event.CHANGE, onChange);
            _offsetYSlider.addEventListener(Event.CHANGE, onChange);
            _sizeSlider.addEventListener(Event.CHANGE, onChange);
            _cellsSlider.addEventListener(Event.CHANGE, onChange);
        }

        private function onChange(event : Event) : void
        {
        	dispatchEvent(new Event(Event.CHANGE));
        }

        public function get noOfCells():int
        {
        	return _cellsSlider.value;
        }
        
        public function get noOfColumns():int
        {
        	return _columnsSlider.value;
        }
        
        public function get cellSize():int
        {
        	return _sizeSlider.value;
        }
        
        public function get offsetX():int
        {
        	return _offsetXSlider.value;
        }
        
        public function get offsetY():int
        {
        	return _offsetYSlider.value;
        }
    }
}
