package nest.object
{
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nest.control.animation.AnimationClip;
	
	/**
	 * Object3D Interface
	 */
	public interface IObject3D extends IEventDispatcher {
		
		function decompose():void;
		function recompose():void;
		
		function translate(axis:Vector3D, value:Number):void;
		
		function localToGlobal(v:Vector3D):Vector3D;
		function globalToLocal(v:Vector3D):Vector3D;
		
		function lookAt(target:Vector3D, upAxis:Vector3D=null):void;
		
		function get parent():IContainer3D;
		function set parent(value:IContainer3D):void;
		
		function get orientation():String;
		function set orientation(value:String):void;
		
		function get changed():Boolean;
		function set changed(value:Boolean):void;
		
		function get rotation():Vector3D;
		
		function get position():Vector3D;
		
		function get matrix():Matrix3D;
		
		function get invertMatrix():Matrix3D;
		
		function get worldMatrix():Matrix3D;
		
		function get invertWorldMatrix():Matrix3D;
		
		function get clips():Vector.<AnimationClip>;
		
		function set clips(value:Vector.<AnimationClip>):void;
		
	}
	
}