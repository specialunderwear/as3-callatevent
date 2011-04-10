package utils
{	
	import flexunit.framework.AssertionFailedError;
	import utils.AssertionFailedErrorEvent;
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatch an event when an assertion fails, instead of an exception
	 * @param dispatcher The thing you want to let send the error events.
	 * @param assertion The assertion function, eg <code>Assert.assertTrue</code>.
	 * @param params The parameters for <code>assertion</code>.
	 * 
	 * This wouldn't be needed if synchronous events wouldn't be fucked up by the
	 * flex unit weird ass blocking stopper machinery. We need this because the
	 * thing we are testing is an event handler generator, so we can't use
	 * Async which also does something like that, because then the tests would
	 * nolonger be transparent.
	 */
	public function assertionAsEvent(dispatcher:IEventDispatcher, assertion:Function, ... params):void {
		try {
			assertion.apply(NaN, params);
		} catch (e:AssertionFailedError) {
			dispatcher.dispatchEvent( new AssertionFailedErrorEvent(e));
		}
	}
}