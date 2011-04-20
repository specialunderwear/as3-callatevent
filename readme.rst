callAtEvent
===========

``callAtEvent`` is designed to prevent pollution of class files with event handlers.
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

Why on earth is that extra method ``handleResetEvent`` needed?

``callAtEvent`` will generate event handlers for you from methods or other functions.
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
------

``callAtEvent`` has a very tiny little dsl for creating event handlers from existing functions::
    
    callAtEvent(aClosure).on(context).using(paramToAClosure, ... etc);
    
    // or when aClosure does not have any parameters:
    callAtEvent(aClosure).on(context);

When scope is fixed
+++++++++++++++++++

The ``on`` part is only available when the function passed to ``callAtEvent`` can be
rebound. If it can not be rebound it will generate an error. When ``callAtEvent``
is used on a method instead of a closure, you can not use ``on``, since 
methods are always bound to their instance, this makes it a bit simpler::

    callAtEvent(aMethod).using(paramToAMethod, ... etc)

    // or when aMethod does not have any parameters:
    callAtEvent(aMethod)

Where is the event
++++++++++++++++++

By default ``callAtEvent`` does not pass the event to your function or method anymore,
if you do need this, you can declare your function like this::

    // This event handler get's it's parameters from callAtEvent.
    // Handy when you need many similar event handlers that differ only on 1 parameter.
    public function parameterisedEventHandler(evt:MouseEvent, scale, duration)
    {
        TweenLite.to(evt.target, duration, {scaleX:scale, scaleY:scale});
    }
    
now you can just use it as::

    addEventListener(MouseEvent.MOUSE_OVER, callAtEvent(parameterisedEventHandler).using(2, 1.5));
    otherthingy.addEventListener(MouseEvent.MOUSE_OVER, callAtEvent(parameterisedEventHandler).using(0.5, 1));

Note that i did not pass the event in the ``using`` call, ``callAtEvent`` will do that for you when
it sees you are passing exactly 1 variable less than needed. The event must be the first parameter of
your function. You have to pass all parameters to ``using``, also the ones that have default values.

ofcourse the above code can be done far easier using::

    this.addEventListener(MouseEvent.MOUSE_OVER, callAtEvent(TweenLite.to).using(this, 1.5, {scaleX:2, scaleY:2}));

Sugar
+++++

For clarity, if you want to bind a function with only one variable, which is the event,
you can use the ``withEvent`` syntax::

    this.addEventListener(MouseEvent.MOUSE_OVER, 
        callAtEvent(function(evt:MouseEvent):void {
            evt.target.width = 100
        })
        .withEvent
    );
    // yes this is pretty pointless, you can also use the closure directly.

Of course you might still need ``this`` to be bound correctly in which case you can do::

    this.addEventListener(MouseEvent.MOUSE_OVER, 
        callAtEvent(function(evt:MouseEvent):void {
            // button gets same width as the thing that has the listener.
            this.width = evt.target.width;
        })
        .on(button)
        .withEvent
    );

Write less and Reuse more code
------------------------------

With ``callAtEvent`` you can write a class with methods that any function can call,
without the need for an event parameter. This way your class is filled with useful
methods instead of code that is only trigered once in a while by an event.

If you group common event handlers in ``mixin`` classes (https://github.com/specialunderwear/as3-mixin).
You can call them in the context of your class using ``callAtEvent``. Read the
mixin manual for details.

Examples
--------

First some closures, which can be rebound, which we can use with ``callAtEvent``::

    package
    {   
        import flash.geom.Point;
        import flash.geom.Matrix;

        /* A class like this is called a 'mixin' because it can be used to add
         * methods to existing objects, see https://github.com/specialunderwear/as3-mixin */
        public class RotateMixin
        {
            public static const rotate:Function = function(degrees:Number) {
                var center:Point = new Point(this.x + this.width / 2, this.y + this.height / 2);
                with (this.transform.matrix) {
                    tx -= center.x;
                    ty -= center.y;
                    rotate( degrees * (Math.PI / 180));
                    tx += center.x;
                    ty += center.y
                }
            };

            public static const rotateTarget:Function = function(evt:Event, degrees:Number) {
                rotate.call(evt.target, degrees);
            }
        }
    }

Next the class that shows different types of uses of ``callAtEvent``::

    package
    {   
        import flash.events.Event;
        import yagni.callAtEvent;
        import RotateMixin;

        public class Square
        {
            var color:uint = 0x000000;

            public function Square()
            {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

                // call redraw with prdefined colour. Buttons could dispatch these events
                addEventListener('purple', callAtEvent(redraw).using(0x4A0399));
                addEventListener('green', callAtEvent(redraw).using(0x0D9900));

                // When square is clicked flip is 180 degrees.
                addEventListener(Event.CLICK, callAtEvent(RotateMixin.rotate).on(this).using(180));
            }

            private function onAddedToStage(evt:Event):void
            {
                // not that the color is always specified even if it is optional!!!
                stage.addEventListener(Event.RESIZE, callAtEvent(redraw).using(color));

                // when stage is clicked flip the entire stage 90 degrees
                stage.addEventListener(Event.Click, callAtEvent(RotateMixin.rotateTarget).on(stage).using(90));
            }

            public function redraw(color:uint=0x000000)
            {
                this.color = color;
                var size:Number = height < width ? height : width;

                with (this.graphics) {
                    beginFill(color, 1);
                    drawRect(0, 0 size, size);
                    endFill();
                    beginFill(1 - color, 0.3);
                    drawCircle(size / 2, size / 2, size / 2);
                }
            }
        }
    }

Weak listeners
--------------

You can not use weak listeners with callAtEvent because the event handler that callAtEvent
creates for you will be garbage collected before it is triggered.

Run the test suite
------------------

check out the source code and in the root directory run::
    
    make test

Annoying warning
----------------

You might see the following warning when using ``callAtEvent`` source files
instead of the swc::

    Warning: Function value used where type * was expected.
    Possibly the parentheses () are missing after this function reference.

Add::

    <warn-unlikely-function-value>false</warn-unlikely-function-value>

To your config file to make it go away.
