package nest.view.process 
{	
	/**
	 * IRenderProcess
	 */
	public interface IRenderProcess {
		
		function calculate():void;
		
		function dispose():void;
		
		function get renderTarget():RenderTarget;
		
		function get color():uint;
		function set color(value:uint):void;
		
	}
	
}