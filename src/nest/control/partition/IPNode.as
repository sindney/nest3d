package nest.control.partition 
{
	import flash.geom.Vector3D;
	
	import nest.object.IMesh;
	import nest.view.Camera3D;
	
	/**
	 * IPNode
	 */
	public interface IPNode {
		
		function classify(camera:Camera3D):Boolean;
		function dispose():void;
		
		function get childs():Vector.<IPNode>;
		function get objects():Vector.<IMesh>;
		function set objects(value:Vector.<IMesh>):void;
		function get depth():int;
		function set depth(value:int):void;
		function get parent():IPNode;
		function set parent(value:IPNode):void;
		
	}
	
}