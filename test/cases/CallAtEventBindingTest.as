package cases
{	
	import org.flexunit.Assert;
	import yagni.callAtEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import utils.assertionAsEvent;
	import org.flexunit.async.Async;
	import utils.AssertionFailedErrorEvent;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	public class CallAtEventBindingTest
		extends EventDispatcher
	{
		[Test]
		public function closureReturnsFunctionWrapper():void
		{
			Assert.assertTrue(
				"callAtEvent returns FunctionWrapper when used with closures",
				getQualifiedClassName(callAtEvent(function():void{})).indexOf('FunctionWrapper') != -1
			);
		}
		
		[Test]
		public function methodReturnsMethodClosureWrapper():void
		{
			var a:Sprite = new Sprite();
			Assert.assertTrue(
				"callAtEvent returns MethodClosureWrapper when used with methods",
				getQualifiedClassName(callAtEvent(a.addChild)).indexOf('MethodClosureWrapper') != -1
			);
		}
		
		[Test]
		public function packageFunctionsReturnMethodClosures():void
		{
			Assert.assertTrue(
				"callAtEvent returns MethodClosureWrapper when used with package functions",
				getQualifiedClassName(callAtEvent(callAtEvent)).indexOf('MethodClosureWrapper') != -1
			);
		}
		
		[Test(async)]
		public function callAtEventCanBindClosuresToCurrentClass():void
		{
			var edp:EventDispatcher = new EventDispatcher();

			Async.registerFailureEvent(this, edp, AssertionFailedErrorEvent.ASSERTION_FAILED);
			
			edp.addEventListener('test', 
				callAtEvent(
					function(evt:Event):void {
						assertionAsEvent(edp, 
							Assert.assertTrue,
								"The event handler should have stated that the event \
								 handler was executed in the context of the unit test \
								 and not the EventDispatcher the handler was attached to.",
								this is CallAtEventBindingTest
						);
					})
				.on(this)
				.withEvent
			);
			
			edp.dispatchEvent(new Event('test'));
		}

		[Test(async)]
		public function callAtEventCanBindClosuresToForeignClass():void
		{
			var edp:EventDispatcher = new EventDispatcher();

			Async.registerFailureEvent(this, this, AssertionFailedErrorEvent.ASSERTION_FAILED);
			
			this.addEventListener('test', 
				callAtEvent(
					function(evt:Event):void {
						assertionAsEvent(this, 
							Assert.assertTrue,
								"The context of the event handler should be the EventDispatcher.",
								this is EventDispatcher
						);
						assertionAsEvent(this, 
							Assert.assertFalse,
								"The context of the event handler should not be CallAtEventTest.",
								this is CallAtEventBindingTest
						);
						
					})
				.on(edp)
				.withEvent
			);
			
			this.dispatchEvent(new Event('test'));
		}

	}
}