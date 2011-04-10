package mocks
{	
	import flash.display.Sprite;
	import mocks.ViewChild;
	import org.flexunit.Assert;
	import flash.events.Event;
	import flexunit.framework.AssertionFailedError;
	import flash.utils.describeType;
	import utils.assertionAsEvent;
	
	public class ViewRoot extends Sprite
	{
		public var gotchas:Array = [];
		
		public function ViewRoot()
		{
			super();
			for (var i:int = 0; i < 4; i++) {
				var vc:ViewChild = new ViewChild();
				
				// bind eventhandler method, where this is fixed to the class instance.
				vc.addEventListener('gotcha', handleGotcha);
				
				// bind eventhandler closure, where this is bound to the package global namespace.
				vc.addEventListener('gotcha', function(evt:Event):void {
					assertionAsEvent(vc, 
						Assert.assertFalse, 
							"In a closure 'this' will nolonger point to the class instance \
							 at the point the closure is evaluated.",
							this is ViewRoot
					);
					
					assertionAsEvent(vc, 
						Assert.assertEquals, 
							"In a closure 'this' should be bound to the package global namespace", 
							this.toString(), "[object global]");
				});
				
				this.addChild(vc);
				gotchas.push(vc);
			}
		}
		
		public function handleGotcha(evt:Event):void
		{
			assertionAsEvent(this, 
				Assert.assertTrue,
					"Class methods will always point to the class instance and can \
					 never ever be rebound to anything else not even by accident. (in as3 mode)",
					this is ViewRoot);
		}

	}
}