package nest.view.partition 
{
	import nest.object.IMesh;
	
	/**
	 * IPNode
	 */
	public interface IPNode {
		
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