package nest.view.effects 
{
	import flash.display3D.Context3D;
	
	/**
	 * IEffect
	 */
	public interface IEffect {
		
		/**
		 * <p>upload fragmentConstants here if you need them.</p>
		 * <p>note:You will need to use fc like fc19, fc18 ... </p>
		 */
		function update(context3D:Context3D):void;
		
		function get fragment():String;
		
	}
	
}