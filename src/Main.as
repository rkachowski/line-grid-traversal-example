package
{
    import components.Cell;
    import components.Line;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * @author dimitri
     */
    [SWF(width="800", height="500", frameRate="60", backgroundColor="#FFFFFF")]
    public class Main extends Sprite
    {

        public static const WIDTH : int = 800;
        public static const HEIGHT : int = 500;
        private var cells : Vector.<Cell>;
        private var _controls : Controls;
        private var line : Line;
        private var startSet : Boolean;
        private var drawing : Boolean;
        private var drawingSprite : Sprite;

        public function Main()
        {
            cells = new Vector.<Cell>();
            drawingSprite = new Sprite();
            addChild(drawingSprite);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function mapPointToCell(mx : int, my : int) : int
        {
            
            var x : int = int((mx-_controls.offsetX) / _controls.cellSize);
            var y : int = int((my-_controls.offsetY) / _controls.cellSize) * _controls.noOfColumns;
            return x + y;
        }

        private function onAddedToStage(event : Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            var stageMask : Sprite = new Sprite();
            stageMask.graphics.beginFill(0x000000, 0);
            stageMask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
            stageMask.graphics.endFill();
            drawingSprite.addChild(stageMask);

            drawingSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            drawingSprite.addEventListener(MouseEvent.CLICK, onMouseClick);
            _controls = new Controls();
            _controls.x = 800 - _controls.width;
            _controls.addEventListener(Event.CHANGE, onUIChange);
            addChild(_controls);

            generateCells();
        }

        private function onMouseClick(event : MouseEvent) : void
        {
            if (!startSet)
            {
                line = new Line(new Point(event.stageX, event.stageY), new Point(event.stageX, event.stageY));
                startSet = true;
                drawing = true;
            }
            else
            {
                line.to = new Point(event.stageX, event.stageY);
                drawing = false;
                startSet = false;
            }
        }

        private function getCellIndexFromClick(event : MouseEvent) : int
        {
            // 2px offset to account for cell border

            if (event.stageX < 0 || event.stageX > (_controls.noOfColumns * _controls.cellSize - 2))
                return -1;

            if (event.stageY < 0 || event.stageY > ((_controls.noOfCells / _controls.noOfColumns) * _controls.cellSize) - 2)
                return -1;

            var cellIndex : int = mapPointToCell(event.stageX, event.stageY);

            if (cellIndex < 0 || cellIndex >= _controls.noOfCells)
                return -1;

            return cellIndex;
        }

        private function onMouseMove(event : MouseEvent) : void
        {
            if (drawing)
            {
                line.to = new Point(event.stageX, event.stageY);
                line.drawLine(drawingSprite.graphics);
                selectCellsUnderLine();
            }
        }

        private function selectCellsUnderLine() : void
        {
            var cellIndices : Vector.<int> = getCellsUnderLine();

            for (var i : int = 0;i < cells.length;i++)
            {
                if (cellIndices.indexOf(i) == -1)
                    cells[i].deselect();
                else
                    cells[i].select();
            }
        }

        private function getCellsUnderLine() : Vector.<int>
        {
            var startCell : int = mapPointToCell(line.from.x, line.from.y);
            var endCell : int = mapPointToCell(line.to.x, line.to.y);

			if(startCell < 0 || startCell > _controls.noOfCells || endCell < 0 || endCell > _controls.noOfCells)
				return new Vector.<int>();

            if (startCell == endCell)
                return Vector.<int>([startCell]);

			if(line.to.x % _controls.cellSize == 0 && line.to.y % _controls.cellSize == 0)
				trace("whooop");

            var result : Vector.<int> = new Vector.<int>();
			
			var lengthInX : Number = Math.abs(line.to.x - line.from.x);
			var lengthInY : Number = Math.abs(line.to.y - line.from.y);
			
			var lengthOfLine:Number = Math.sqrt( Math.pow(lengthInX,2)+Math.pow(lengthInY,2));
			
            var stepX : int = (line.from.x < line.to.x) ? 1 : (line.from.x > line.to.x) ? -1 : 0;
            var stepY : int = (line.from.y < line.to.y) ? 1 : (line.from.y > line.to.y) ? -1 : 0;

            var minX : Number = _controls.cellSize * Math.floor((line.from.x-_controls.offsetX) / _controls.cellSize);
            var maxX : Number = minX + _controls.cellSize;
            var minY : Number = _controls.cellSize * Math.floor((line.from.y - _controls.offsetY) / _controls.cellSize);
            var maxY : Number = minY + _controls.cellSize;

            var tx : Number = ((line.from.x > line.to.x) ? (line.from.x-_controls.offsetX) - minX : maxX - (line.from.x-_controls.offsetX))*(lengthOfLine / lengthInX);
            var ty : Number = ((line.from.y > line.to.y) ? (line.from.y -_controls.offsetY)- minY : maxY - (line.from.y -_controls.offsetY))*(lengthOfLine / lengthInY);

            var deltaX : Number = _controls.cellSize*(lengthOfLine / lengthInX);
            var deltaY : Number = _controls.cellSize*(lengthOfLine / lengthInY);

            var x : int = startCell % _controls.noOfColumns;
            var y : int = int(startCell / _controls.noOfColumns);
           
            while (true)
            {
                result.push(x + y * _controls.noOfColumns);

                if (tx <= ty)
                {
                    if (x + y * _controls.noOfColumns == endCell)
                        break;

                    tx += deltaX;
                    x += stepX;
                }
                else
                {
                    if (x + y * _controls.noOfColumns == endCell)
                        break;

                    ty += deltaY;
                    y += stepY;
                }

                if (x + y * _controls.noOfColumns > _controls.noOfCells || x + y * _controls.noOfColumns < 0)
                    throw new Error("loopin away");
            }

            return result;
        }

        private function onUIChange(event : Event) : void
        {
            generateCells();
        }

        private function generateCells() : void
        {
            for each (var c:Cell in cells)
            {
                c.removeEventListener(MouseEvent.CLICK, onMouseClick);
                removeChild(c);
            }

            cells = new Vector.<Cell>(_controls.noOfCells, true);

            for (var i : int = 0;i < _controls.noOfCells;i++)
            {
                var cell : Cell = new Cell(i.toString());
                cell.size = _controls.cellSize;
                cell.x = (_controls.cellSize / 2 + (i % _controls.noOfColumns) * _controls.cellSize) + _controls.offsetX;
                cell.y = (_controls.cellSize / 2 + int(i / _controls.noOfColumns) * _controls.cellSize) + _controls.offsetY;

                cells[i] = cell;

                addChild(cell);
            }

            setChildIndex(drawingSprite, numChildren - 1);
            setChildIndex(_controls, numChildren - 1);
        }
        
        private function floatEquals(val1:Number,val2:Number,tolerance:Number=0.00001):Boolean
        {
        	return (val1 > val2 - tolerance) && (val1 < val2+tolerance);
        }
    }
}
