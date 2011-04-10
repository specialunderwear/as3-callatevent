package mocks
{	
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import utils.assertionAsEvent;
	import org.flexunit.Assert;
	import flash.events.MouseEvent;
	
	public class MethodEventHandlers extends Sprite
	{

		public function MethodEventHandlers()
		{
			super();
			with (this.graphics) {
				beginFill(0x000000,1);
				drawRect(0, 0, 10, 10);
				endFill();
			}
		}
		
		public function onClickResize(evt:MouseEvent, width:Number, height:Number):void
		{
			assertionAsEvent(this, Assert.assertNotNull, evt);
			assertionAsEvent(this, Assert.assertTrue, evt is MouseEvent);
			
			this.resize(width, height);
		}
		
		public function resize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
		
		public function reset():void
		{
			this.width = this.height = 10;
		}

	}
}