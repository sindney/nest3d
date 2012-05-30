package nest.view.effects 
{
	import flash.display3D.Context3D;
	
	/**
	 * IEffect
	 */
	public interface IEffect {
		
		/**
		 * <p>Upload fragmentConstants here if you need them.</p>
		 * <p>Note:You will need to use fc like fc18, fc17 ... </p>
		 */
		function update(context3D:Context3D):void;
		
		function get fragment():String;
		
	}
	
}