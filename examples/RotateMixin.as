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