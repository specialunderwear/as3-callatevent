package cases
{	
	import mocks.MethodEventHandlers;
	import org.flexunit.Assert;
	import flash.events.MouseEvent;
	import yagni.callAtEvent;
	import org.flexunit.async.Async;
	import utils.AssertionFailedErrorEvent;
	import flash.events.EventDispatcher;

	public class CallMethodAtEventFactoryTest
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
				callAtEvent(meh.resize)
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
				callAtEvent(meh.onClickResize)
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
		
		[Test]
		public function callAtEventDoesNotRequireUsingForMethodsWithoutParams():void
		{
			dispatcher.addEventListener(MouseEvent.CLICK, callAtEvent(meh.reset));
			
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
		
	}
}