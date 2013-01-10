package nest.view.process 
{
	
	/**
	 * IRedrawProcess
	 */
	public interface IRedrawProcess extends IRenderProcess {
		
		function get containerProcess():IContainerProcess;
		function set containerProcess(value:IContainerProcess):void;
		
	}
	
}