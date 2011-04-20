package
{	
	import flash.events.Event;
	import yagni.callAtEvent;
	import RotateMixin;
	
	public class Square
    {
		var color:uint = 0x000000;
		
        public function Square()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// call redraw with prdefined colour. Buttons could dispatch these events
			addEventListener('purple', callAtEvent(redraw).using(0x4A0399));
			addEventListener('green', callAtEvent(redraw).using(0x0D9900));
			
			// When square is clicked flip is 180 degrees.
			addEventListener(Event.CLICK, callAtEvent(RotateMixin.rotate).on(this).using(180));
        }
        
		private function onAddedToStage(evt:Event):void
		{
			// not that the color is always specified even if it is optional!!!
			stage.addEventListener(Event.RESIZE, callAtEvent(redraw).using(color));
			
			// when stage is clicked flip the entire stage 90 degrees
			stage.addEventListener(Event.Click, callAtEvent(RotateMixin.rotateTarget).on(stage).using(90));
		}
		
        public function redraw(color:uint=0x000000)
        {
			this.color = color;
			var size:Number = height < width ? height : width;
			
        	with (this.graphics) {
        		beginFill(color, 1);
				drawRect(0, 0 size, size);
				endFill();
				beginFill(1 - color, 0.3);
				drawCircle(size / 2, size / 2, size / 2);
        	}
        }
    }
}