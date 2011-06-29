package cases
{
	import mocks.MethodEventHandlers;
	import org.flexunit.Assert;
	import flash.events.MouseEvent;
	import yagni.callAtEvent;
	import org.flexunit.async.Async;
	import utils.AssertionFailedErrorEvent;
	import flash.events.EventDispatcher;
	import utils.assertionAsEvent;
	
	public class CallClosureAtEventFactoryTest
	{
		public var meh:MethodEventHandlers;
		public var dispatcher:EventDispatcher;
		
		[Before]
		public function before():void
		{
			meh = new MethodEventHandlers();
			dispatcher = new EventDispatcher();
			
			Assert.assertEquals(
				"MethodEventHandlers constructor should set width and height to equal values",
				meh.width, meh.height
			);
			
			Assert.assertEquals(
				"MethodEventHandlers constructor should set width to 10",
				10, meh.width
			);
		}
		
		[Test]
		public function callAtEventCanMakeEventHandlersOutOfMethods():void
		{
			dispatcher.addEventListener(MouseEvent.CLICK,
				callAtEvent(function(width:Number, height:Number):void
				{
					this.width = width;
					this.height = height;
				})
				.on(meh)
				.using(200, 300)
			);
			
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			Assert.assertEquals(
				"The method turned into a click handler should have set the width to 200",
				200, meh.width
			);
			
			Assert.assertEquals(
				"The method turned into a click handler should have set the height to 300",
				300, meh.height
			);
			
		}
		
		[Test(async)]
		public function callAtEventPassesEventWhenUsingHasOneLessParameter():void
		{
			dispatcher.addEventListener(MouseEvent.CLICK, 
				callAtEvent(function(evt:MouseEvent, width:Number, height:Number):void
				{
					assertionAsEvent(meh, Assert.assertNotNull, evt);
					assertionAsEvent(meh, Assert.assertTrue, evt is MouseEvent);

					this.resize(width, height);
				})
				.on(meh)
				.using(200, 300)
			)
			
			Async.registerFailureEvent(this, meh, AssertionFailedErrorEvent.ASSERTION_FAILED);
			
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			Assert.assertEquals(
				"The click handler should have set the width to 200",
				200, meh.width
			);
			
			Assert.assertEquals(
				"The click handler should have set the height to 300",
				300, meh.height
			);
		}
		
		[Test(async)]
		public function callAtEventDoesNotIncreaseParameterCountOverMultipleMethodCalls():void
		{
			var count:int = 0;
			dispatcher.addEventListener(MouseEvent.CLICK, 
				callAtEvent(function(evt:MouseEvent, ... args):void
				{
					count+= args.length;
				})
				.on(meh).using()
			)
			
			// if the test fails, an exception is thrown on the second call.
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			Assert.assertEquals(
				"The event handler should never have received any more paramters but the event",
				0, count
			)
		}
		
		[Test]
		public function callAtEventDoesNotRequireUsingForMethodsWithoutParams():void
		{
			dispatcher.addEventListener(MouseEvent.CLICK, 
				callAtEvent(function():void
				{
					this.width = this.height = 10;
				})
				.on(meh)
			);
			
			meh.width = 100;
			meh.height = 30;
			
			dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			Assert.assertEquals(
				"MethodEventHandlers reset method should set width and height to equal values",
				meh.width, meh.height
			);
			
			Assert.assertEquals(
				"MethodEventHandlers reset method should set width to 10",
				10, meh.width
			);
		}
		
		[Test]
		public function withEventCanBeUsedWithOutOn():void
		{
			meh.addEventListener(MouseEvent.CLICK,
				callAtEvent(function(evt:MouseEvent):void {
					evt.target.width = 100
				})
				.withEvent
			);
			meh..dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Assert.assertEquals(
				"MethodEventHandlers should now be of width 100",
				100, meh.width
			);
		}
	}
}