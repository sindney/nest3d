package nest.object
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * Object3D Interface
	 */
	public interface IObject3D extends IPlaceable {
		
		function recompose():void;
		
		function translate(axis:Vector3D, value:Number):void;
		
		function get changed():Boolean;
		function set changed(value:Boolean):void;
		
		function get orientation():String;
		function set orientation(value:String):void;
		
		function get components():Vector.<Vector3D>;
		
		function get rotation():Vector3D;
		
		function get scale():Vector3D;
		
		function get matrix():Matrix3D;
		
		function get invertMatrix():Matrix3D;
		
	}
	
}