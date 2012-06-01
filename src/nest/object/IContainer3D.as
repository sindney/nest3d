package nest.object 
{
	import flash.geom.Matrix3D;
	
	/**
	 * Container3D Interface
	 */
	public interface IContainer3D extends IObject3D {
		
		function addChild(object:IPlaceable):void;
		
		function removeChild(object:IPlaceable):void;
		
		function removeChildAt(index:int):IPlaceable;
		
		function getChildAt(index:int):IPlaceable;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get numChildren():int;
		
	}
	
}