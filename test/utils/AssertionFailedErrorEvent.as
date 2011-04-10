package utils
{	
	import flash.events.Event;
	import flexunit.framework.AssertionFailedError;
	
	/**
	 * An event used by <code>utils.assertionAsEvent</code> to
	 * dispatch when an assertion error happened.
	 * 
	 * @see utils.assertionAsEvent;
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  10.04.2011
	 */
	
	public class AssertionFailedErrorEvent extends Event
	{
		public static const ASSERTION_FAILED:String = 'utils.AssertionFailedErrorEvent.ASSERTION_FAILED';
		
		protected var _error:AssertionFailedError;
		
		public function get error():AssertionFailedError
		{
			return _error;
		}
		
		public function AssertionFailedErrorEvent(error:AssertionFailedError)
		{
			super(ASSERTION_FAILED, false, false);
			this._error = error;
		}
		
		override public function clone():Event
		{
			return new AssertionFailedErrorEvent(this._error);
		}
		
		override public function toString():String
		{
			return _error.toString();
		}

	}
}