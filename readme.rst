callAtEvent
===========

CallAtEvent is designed to prevent pollution of class files with event handlers.
Also it will help you separate the code that deals with the event, from the code
that deals with your object.

Take a look at the following code::

    class VeryTypical
    {
        public function VeryTypical()
        {
            addEventListener(ResetEvent.RESET, handleResetEvent);
        }
        
        public function reset():void
        {
            x = 0;
            y = 0;
        }
        
        private function handleResetEvent(evt:ResetEvent):void
        {
            this.reset()
        }
    }

Why on earth is that extra method handleResetEvent needed?

callAtEvent will generate event handlers for you from methods or other functions.
Also it will help you with executing closures in the correct context::

    class VeryStrangeErrors
    {
        public function VeryStrangeErrors()
        {
            var btn:Button = addChild( new Button ) as Button;
            btn.addEventListener(MouseEvent.Hover, function(){
                // what is 'this' pointing to? And where do we need it to point?
                this.scaleX = this.scaleY = 1.5;
            })
        }
    }

Syntax
======

callAtEvent has a very tiny little dsl for creating event handlers from existing functions::
    
    callAtEvent(aClosure).on(context).using([paramToAClosure, ...]);
    
    // or when aClosure does not need any parameters:
    callAtEvent(aClosure).on(context);
    
When callAtEvent is working with a method, instead of a closure it gets even
simpler because methods cannot be rebound to anything else but it's instance::

    callAtEvent(aMethod).using([paramToAMethod, ...])

    // or when aMethod does not need any parameters:
    callAtEvent(aMethod)

By default callAtEvent does not pass the event to your function or method anymore,
if you do need this, you can declare your function like this::

    public function reusableEventHandler(evt:MouseEvent, scale, duration)
    {
        TweenLite.to(evt.target, duration, {scaleX:scale, scaleY:scale});
    }
    
now you can just use it as::

    addEventListener(MouseEvent.MOUSE_OVER, callAtEvent(reusableEventHandler).using(2, 1.5));

Note that i did not pass the event in the `using` call, callAtEvent will do that for you when
it sees you are passing exactly 1 variable less than needed.

ofcaourse the above code can be done far easier using::

    this.addEventListener(MouseEvent.MOUSE_OVER, callAtEvent(TweenLite.to).using(this, 1.5, {scaleX:scale, scaleY:scale}));

For clarity, if you want to bind a function with only one variable which is the event, you can use::

    this.addEventListener(MouseEvent.MOUSE_OVER, 
        callAtEvent(function(evt:MouseEvent):void {
            evt.target.width = 100
        })
        .withEvent
    );

Of course you might still need `this` to be bound correctly in which case you can do::

    this.addEventListener(MouseEvent.MOUSE_OVER, 
        callAtEvent(function(evt:MouseEvent):void {
            evt.target.width = 100
        })
        .on(this)
        .withEvent
    );
    

Write less and Reuse more code
==============================

With callAtEvent you can write a class with methods that any function can call,
without the need for an event parameter. This way your class is filled with useful
methods instead of code that is only trigered once in a while by an event.

If you group common event handlers in mixin classes (https://github.com/specialunderwear/as3-mixin).
You can call them in the context of your class using callAtEvent.

Weak listeners
==============

You can not use weak listeners with callAtEvent because the event handler that callAtEvent
creates for you will be garbage collected before it is triggered.