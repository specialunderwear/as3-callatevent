package yagni
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Calls a specific method on a certain event.
	 *  
	 * Use like this:
	 * addEventListener( Event.CLICK, callAtEvent( someMethodName ).on( this ).using( arguments ) );
	 */
	
	public function callAtEvent( callBack: Function ): * {
		
		// for method closure return MethodClosureWrapper
		if (getQualifiedClassName(callBack) == 'builtin.as$0::MethodClosure') {
			
			var methodClosureWrapper:MethodClosureWrapper = new MethodClosureWrapper(callBack);
			
			// for callBack's witout parameters, no need to require a call to
			// using(); instead return the completed event handler immediately.
			if (callBack.length == 0) {
				return methodClosureWrapper.using();
			}
			
			return methodClosureWrapper;
		}
		
		// for function objects return FunctionWrapper
		return new FunctionWrapper(callBack);
	}
}

import flash.events.Event;

/**
 * @private
 */

internal class MethodClosureWrapper
{
	// the function which is called when the event occurs.
	protected var callBack: Function;
	// the context in which the function is evaluated (this).
	protected var context: Object = NaN;
	
	/**
	 * Create a new <code>EventHandlerWrapper</code> object with no <code>context</code> set yet.
	 * 
	 * @param callBack the callback that is executed when the event occurs.
	 * @constructor
	 * @private
	 */
	
	public function MethodClosureWrapper( callBack: Function ) {
		this.callBack = callBack;
	}
	
	/** 
	 * Add the parameters the <code>callBack</code> function requires.
	 * If the callback really expects exactly 1 more parameter then
	 * was passed by the <code>using()</code> call, the extra slot is flled with the
	 * event object. This is always the first slot.
	 * 
	 * @return The event handler that calls <code>callBack</code> for you.
	 * @private
	 */
	
	public function using( ...params ): Function
	{
		// If there is an extra slot, it is filled with the event
		// object. This is always the first slot.
		if (params.length + 1 == callBack.length) {
			return function( evt: Event = null ): void {
				callBack.apply( context, [evt].concat.apply(NaN, params) );
			};			
		}
		
		// return the event handler
		return function( evt: Event = null ): void {
			callBack.apply( context, params );
		};
	}
	
	/**
	 * Creates an event handler that also passes the event
	 * To the wrapped handler. Usefull for when callAtEvent is
	 * used only to disambiguate scope.
	 * 
	 * @private
	 */
	
	public function get withEvent():Function
	{
		return function( ... params ): void {
			callBack.apply( context, params );
		};
	}
}

internal class FunctionWrapper extends MethodClosureWrapper
{
	public function FunctionWrapper( callBack: Function ) {
		super( callBack );
	}
	
	/** 
	 * Defines the context of the <code>callBack</code>.
	 * 
	 * @return Self, for function call chaining.
	 * @private
	 */
	  
	public function on( context: Object ): *
	{
		this.context = context;
		
		// for callBack's witout parameters, no need to require a call to
		// using(); instead return the completed event handler immediately.
		if (this.callBack.length == 0) {
			return this.using();
		}
		
		return this;
	}
}
