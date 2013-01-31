package nest.control.animation 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nest.view.material.ColorMaterial;
	import nest.view.material.TextureMaterial;
	
	/**
	 * TextureModifier
	 */
	public class TextureModifier implements IAnimationModifier {
		
		public const DIFFUSE:String = "diffuse";
		
		public const SPECULAR:String = "specular";
		
		public const NORMAL_MAP:String = "normalMap";
		
		public function getFromMovieClip(source:MovieClip, size:uint = 128, type:String = "diffuse"):AnimationTrack {
			var result:AnimationTrack = new AnimationTrack();
			
			var bitmapData:BitmapData;
			var frame:TextureKeyFrame;
			var totalFrames:uint = source.totalFrames;
			
			for (var i:int = 0; i < totalFrames; i++) {
				bitmapData = new BitmapData(size, size, true, 0);
				bitmapData.lock();
				source.gotoAndStop(i);
				bitmapData.draw(source);
				bitmapData.unlock();
				
				frame = new TextureKeyFrame();
				switch(type) {
					case DIFFUSE:
						frame.diffuse = bitmapData;
						break;
					case SPECULAR:
						frame.specular = bitmapData;
						break;
					case NORMAL_MAP:
						frame.normalMap = bitmapData;
						break;
				}
				frame.time = i;
				result.addChild(frame);
			}
			
			return result;
		}
		
		public function getFromSpriteSheet(source:BitmapData, tileWidth:Number = 100, tileHeight:Number = 100, startIndex:int = 0, endIndex:int = int.MAX_VALUE, type:String = "diffuse"):AnimationTrack {
			var result:AnimationTrack = new AnimationTrack();
			
			var bitmapData:BitmapData;
			var frame:TextureKeyFrame;
			var w:int = Math.ceil(source.width / tileWidth);
			var h:int = Math.ceil(source.height / tileHeight);
			var xIndex:int;
			var yIndex:int;
			endIndex = Math.min(endIndex, w * h);
			var offsets:Point = new Point();
			var rectangle:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			var size:Number = 1;
			while (size < tileWidth || size < tileHeight) {
				size *= 2;
			}
			for (var i:int = startIndex; i <= endIndex; i++) {
				bitmapData = new BitmapData(size, size, true, 0);
				bitmapData.lock();
				xIndex = i % w;
				yIndex = Math.floor(i / w);
				rectangle.x = xIndex * tileWidth;
				rectangle.y = yIndex * tileHeight;
				bitmapData.copyPixels(source, rectangle, offsets);
				bitmapData.unlock();
				frame = new TextureKeyFrame();
				switch(type) {
					case DIFFUSE:
						frame.diffuse = bitmapData;
						break;
					case SPECULAR:
						frame.specular = bitmapData;
						break;
					case NORMAL_MAP:
						frame.normalMap = bitmapData;
						break;
				}
				frame.time = i - startIndex;
				result.addChild(frame);
			}
			return result;
		}
		
		public function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
			var tmp:TextureKeyFrame = k2 as TextureKeyFrame;
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			var a:uint = ((k1.color >> 24) & 0xff) * w1 + ((tmp.color >> 24) & 0xff) * w2;
			var r:uint = ((k1.color >> 16) & 0xff) * w1 + ((tmp.color >> 16) & 0xff) * w2;
			var g:uint = ((k1.color >> 8) & 0xff) * w1 + ((tmp.color >> 8) & 0xff) * w2;
			var b:uint = (k1.color & 0xff) * w1 + (tmp.color & 0xff) * w2;
			result.color = (a << 24) | (r << 16) | (g << 8) | b;
			result.diffuse = k1.diffuse;
			result.specular = k1.specular;
			result.normalMap = k1.normalMap;
			return result;
		}
		
		public function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var offset:Number = root.next.time;
			
			while (time >= frame.next.time) {
				frame = frame.next;
				offset = frame.next.time;
			}
			
			var w1:Number = (offset - time) / (offset - frame.time);
			var w2:Number = 1 - w1;
			
			var current:TextureKeyFrame = frame as TextureKeyFrame;
			if (target is TextureMaterial) {
				var textureMat:TextureMaterial = target as TextureMaterial;
				if (current.diffuse) textureMat.diffuse.data = current.diffuse;
				if (current.specular) textureMat.specular.data = current.specular;
				if (current.normalMap) textureMat.normalmap.data = current.normalMap;
			} else if (target is ColorMaterial) {
				var next:TextureKeyFrame = frame.next as TextureKeyFrame;
				var colorMat:ColorMaterial = target as ColorMaterial;
				var a:uint = ((current.color >> 24) & 0xff) * w1 + ((next.color >> 24) & 0xff) * w2;
				var r:uint = ((current.color >> 16) & 0xff) * w1 + ((next.color >> 16) & 0xff) * w2;
				var g:uint = ((current.color >> 8) & 0xff) * w1 + ((next.color >> 8) & 0xff) * w2;
				var b:uint = (current.color & 0xff) * w1 + (next.color & 0xff) * w2;
				colorMat.color = (a << 24) | (r << 16) | (g << 8) | b;
			}
		}
		
	}

}