package nest.control.animation 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * TextureKeyFrame
	 */
	public class TextureKeyFrame extends KeyFrame 
	{
		public static const DIFFUSE:String = "diffuse";
		
		public static const SPECULAR:String = "specular";
		
		public static const NORMAL_MAP:String = "normalMap";
		
		public var color:uint;
		
		public var alpha:Number;
		
		public var diffuse:BitmapData;
		
		public var specular:BitmapData;
		
		public var normalMap:BitmapData;
		
		public function TextureKeyFrame() 
		{
			
		}
		
		public static function interpolate(k1:TextureKeyFrame, k2:TextureKeyFrame, w1:Number, w2:Number):TextureKeyFrame {
			if (!k2) return k1.clone() as TextureKeyFrame;
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = k1.time * w1 + w2 * k2.time;
			var r:uint = ((k1.color >> 16) & 0xff) * w1 + ((k2.color >> 16) & 0xff) * w2;
			var g:uint = ((k1.color >> 8) & 0xff) * w1 + ((k2.color >> 8) & 0xff) * w2;
			var b:uint = (k1.color & 0xff) * w1 + (k2.color & 0xff) * w2;
			result.color = (r << 16) | (g << 8) | b;
			result.alpha = k1.alpha * w1 + k2.alpha * w2;
			result.diffuse = k1.diffuse;
			result.specular = k1.specular;
			result.normalMap = k1.normalMap;
			return result;
		}
		
		public static function getFramesFromMovieClip(source:MovieClip, size:uint=128,type:String="diffuse"):AnimationTrack {
			var resultTrack:AnimationTrack = new AnimationTrack();
			
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
				resultTrack.addFrame(frame);
			}
			
			return resultTrack;
		}
		
		public static function getFramesFromSpriteSheet(source:BitmapData, tileWidth:Number = 100, tileHeight:Number = 100, startIndex:int = 0, endIndex:int = int.MAX_VALUE,type:String="diffuse"):AnimationTrack {
			var resultTrack:AnimationTrack = new AnimationTrack();
			
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
				resultTrack.addFrame(frame);
			}
			return resultTrack;
		}
		
		override public function clone():KeyFrame {
			var result:TextureKeyFrame = new TextureKeyFrame();
			result.time = time;
			result.name = name;
			result.next = next;
			result.color = color;
			result.alpha = alpha;
			result.diffuse = diffuse;
			result.specular = specular;
			result.normalMap = normalMap;
			return result;
		}
		
	}

}