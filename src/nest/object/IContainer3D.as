package nest.object 
{
	import flash.geom.Matrix3D;
	
	/**
	 * Container3D Interface
	 */
	public interface IContainer3D extends IObject3D {
		
		function addChild(object:IObject3D):void;
		
		function removeChild(object:IObject3D):void;
		
		function removeChildAt(index:int):IObject3D;
		
		function getChildAt(index:int):IObject3D;
		
		function get invertMatrix():Matrix3D;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get numChildren():int;
		
	}
	
}