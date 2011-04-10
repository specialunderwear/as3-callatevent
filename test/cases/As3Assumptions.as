package cases
{	
	import mocks.ViewChild;
	import mocks.ViewRoot;
	import flash.events.Event;
	import org.flexunit.async.Async;
	import utils.AssertionFailedErrorEvent;
	import flash.utils.getQualifiedClassName;
	import org.flexunit.Assert;
	import flash.display.Sprite;
	
	public class As3Assumptions
	{
		public var viewRoot:ViewRoot;
		
		[Before]
		public function before():void
		{
			viewRoot = new ViewRoot();
		}
		
		[Test(async)]
		public function scopeOfClosureIsPackageGlobalNamespace():void
		{
			// For assertions implemented, look inside ViewRoot.as
			for each (var item:ViewChild in viewRoot.gotchas) {
				Async.registerFailureEvent(this, item, AssertionFailedErrorEvent.ASSERTION_FAILED);
				item.dispatchEvent(new Event('gotcha'));
			}
		}
		
		[Test(async)]
		public function scopeOfMethodIsClass():void
		{
			// For assertions implemented, look inside ViewRoot.as
			Async.registerFailureEvent(this, viewRoot, AssertionFailedErrorEvent.ASSERTION_FAILED);
			for each (var item:ViewChild in viewRoot.gotchas) {
				item.dispatchEvent(new Event('gotcha'));
			}
		}
		
		[Test]
		public function qualifiedNameOfMethodClosureIsFixed():void
		{
			Assert.assertEquals( getQualifiedClassName(qualifiedNameOfMethodClosureIsFixed), 'builtin.as$0::MethodClosure');
			Assert.assertEquals( getQualifiedClassName(scopeOfMethodIsClass), 'builtin.as$0::MethodClosure');
			var a:Sprite = new Sprite();
			Assert.assertEquals( getQualifiedClassName(a.addChild), 'builtin.as$0::MethodClosure');
		}
	}
}