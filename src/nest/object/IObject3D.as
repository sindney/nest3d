package nest.object
{
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * Object3D Interface
	 */
	public interface IObject3D extends IEventDispatcher {
		
		function decompose():void;
		function recompose():void;
		
		function get parent():IContainer3D;
		function set parent(value:IContainer3D):void;
		
		function get orientation():String;
		function set orientation(value:String):void;
		
		function get rotation():Vector3D;
		
		function get position():Vector3D;
		
		function get scale():Vector3D;
		
		function get matrix():Matrix3D;
		
		function get invertMatrix():Matrix3D;
		
		function get worldMatrix():Matrix3D;
		
		function get invertWorldMatrix():Matrix3D;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get castShadows():Boolean;
		function set castShadows(value:Boolean):void;
		
	}
	
}