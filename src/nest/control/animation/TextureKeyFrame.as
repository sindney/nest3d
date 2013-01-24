package nest.control.animation 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nest.view.material.ColorMaterial;
	import nest.view.material.TextureMaterial;
	
	/**
	 * TextureKeyFrame
	 */
	public class TextureKeyFrame extends IKeyFrame {
		
		public static function getFromMovieClip(source:MovieClip, size:uint = 128, type:String = "diffuse"):AnimationTrack {
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
		
		public static function getFromSpriteSheet(source:BitmapData, tileWidth:Number = 100, tileHeight:Number = 100, startIndex:int = 0, endIndex:int = int.MAX_VALUE, type:String = "diffuse"):AnimationTrack {
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
		
		public static function interpolate(k1:IKeyFrame, k2:IKeyFrame, w1:Number, w2:Number):IKeyFrame {
			if (!k2) return k1.clone();
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
		
		public static function calculate(target:IAnimatable, root:IKeyFrame, time:Number):void {
			var frame:IKeyFrame = root;
			var timeOffset:Number;
			
			while (frame && time >= frame.time) {
				timeOffset = frame.time;
				frame = frame.next;
			}
			
			if (frame) {
				var weight2:Number = (time - timeOffset) / (frame.time - timeOffset);
				var weight1:Number = 1 - weight2;
				if (!weight1) {
					weight1 = 1;
					weight2 = 0;
				}
				if (frame.next) {
					var current:TextureKeyFrame = frame as TextureKeyFrame;
					if (target is TextureMaterial) {
						var textureMat:TextureMaterial = target as TextureMaterial;
						if (current.diffuse) textureMat.diffuse.data = current.diffuse;
						if (current.specular) textureMat.specular.data = current.specular;
						if (current.normalMap) textureMat.normalmap.data = current.normalMap;
					} else if (target is ColorMaterial) {
						var next:TextureKeyFrame = frame.next as TextureKeyFrame;
						var colorMat:ColorMaterial = target as ColorMaterial;
						var a:uint = ((current.color >> 24) & 0xff) * weight1 + ((next.color >> 24) & 0xff) * weight2;
						var r:uint = ((current.color >> 16) & 0xff) * weight1 + ((next.color >> 16) & 0xff) * weight2;
						var g:uint = ((current.color >> 8) & 0xff) * weight1 + ((next.color >> 8) & 0xff) * weight2;
						var b:uint = (current.color & 0xff) * weight1 + (next.color & 0xff) * weight2;
						colorMat.color = (a << 24) | (r << 16) | (g << 8) | b;
					}
				}
			}
		}
		
		public static const DIFFUSE:String = "diffuse";
		
		public static const SPECULAR:String = "specular";
		
		public static const NORMAL_MAP:String = "normalMap";
		
		public var color:uint;
		
		public var alpha:Number;
		
		public var diffuse:BitmapData;
		
		public var specular:BitmapData;
		
		public var normalMap:BitmapData;
		
		private var _time:Number;
		private var _name:String;
		private var _next:IKeyFrame;
		
		public function TextureKeyFrame() {
			
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get next():IKeyFrame {
			return _next;
		}
		
		public function set next(value:IKeyFrame):void {
			_next = value;
		}
		
	}

}