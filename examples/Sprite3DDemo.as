package  
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import nest.object.Sprite3D;
	
	import nest.control.factories.PrimitiveFactory;
	import nest.object.data.*;
	import nest.object.Mesh;
	import nest.view.lights.*;
	import nest.view.materials.*;
	
	/**
	 * BasicDemo
	 */
	public class Sprite3DDemo extends DemoBase {
		[Embed(source = "assets/sprite_sheet.png")]
		private var SpriteSheet:Class;
		
		private var maxIteration:uint;
		private var index:uint;
		
		public function Sprite3DDemo() {
			super();
		}
		
		private var colorMat:ColorMaterial;
		private var colorMat1:ColorMaterial;
		private var movieMat:MovieMaterial;
		
		override public function init():void {
			maxIteration = 10;
			colorMat = new ColorMaterial(0xff0000);
			colorMat.update();
			colorMat1 = new ColorMaterial(0x00ff00);
			colorMat1.update();
			movieMat = new MovieMaterial(null);
			var sheets:Vector.<BitmapData> = MovieMaterial.getFramesFromSpriteSheet(new SpriteSheet().bitmapData, 96, 128, 10, 19);
			movieMat.frames = sheets;
			movieMat.frame = 0;
			movieMat.update();
			var sprite:Sprite3D;
			var i:int, j:int, k:int = 0;
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					for (k = 0; k < 10; k++) {
						sprite = new Sprite3D(movieMat,10,10);
						sprite.position.setTo(i * 40, j * 40, k * 40);
						sprite.changed = true;
						scene.addChild(sprite);
					}
				}
			}
			
			camera.position.z = -20;
			camera.changed = true;
		}
		
		override public function loop():void {
			movieMat.frame = index;
			index = (index + 1) % maxIteration;
		}
		
	}

}