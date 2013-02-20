package nest.view 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nest.control.animation.AnimationTrack;
	import nest.control.animation.TextureKeyFrame;
	
	/**
	 * TextureResource
	 */
	public class TextureResource {
		
		public static function uploadWithMipmaps(texture:TextureBase, bmd:BitmapData, side:int = -1):void {
			var width:int = bmd.width;
			var height:int = bmd.height;
			var leve:int = 0;
			var image:BitmapData = new BitmapData(bmd.width, bmd.height);
			var matrix:Matrix = new Matrix();
			
			while (width > 0 && height > 0) {
				image.draw(bmd, matrix, null, null, null, true);
				if (side == -1) {
					(texture as Texture).uploadFromBitmapData(image, leve);
				} else {
					(texture as CubeTexture).uploadFromBitmapData(image, side, leve);
				}
				matrix.scale(0.5, 0.5);
				leve++;
				width >>= 1;
				height >>= 1;
			}
			image.dispose();
		}
		
		public static function uploadToTexture(resource:TextureResource, data:BitmapData, mipmapping:Boolean):void {
			if (data) {
				if (resource.texture is CubeTexture || resource.width != data.width || resource.height != data.height) {
					if (resource.texture) resource.texture.dispose();
					resource.texture = ViewPort.context3d.createTexture(data.width, data.height, Context3DTextureFormat.BGRA, false);
				}
				mipmapping ? uploadWithMipmaps(resource.texture, data) : (resource.texture as Texture).uploadFromBitmapData(data);
				resource.width = data.width;
				resource.height = data.height;
			} else {
				if(resource.texture) resource.texture.dispose();
				resource.texture = null;
			}
		}
		
		public static function uploadToCubeTexture(resource:TextureResource, data:Vector.<BitmapData>):void {
			if (data) {
				if (resource.texture is Texture || resource.width != data[0].width || resource.height != data[0].height) {
					if (resource.texture) resource.texture.dispose();
					resource.texture = ViewPort.context3d.createCubeTexture(data[0].width, Context3DTextureFormat.BGRA, false);
				}
				uploadWithMipmaps(resource.texture, data[0], 0);
				uploadWithMipmaps(resource.texture, data[1], 1);
				uploadWithMipmaps(resource.texture, data[2], 2);
				uploadWithMipmaps(resource.texture, data[3], 3);
				uploadWithMipmaps(resource.texture, data[4], 4);
				uploadWithMipmaps(resource.texture, data[5], 5);
				resource.width = data[0].width;
				resource.height = data[1].height;
			} else {
				if(resource.texture) resource.texture.dispose();
				resource.texture = null;
			}
		}
		
		public static function getTrackFromMovieClip(index:int, source:MovieClip, size:uint = 128):AnimationTrack {
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
				frame.time = i;
				frame.data = bitmapData;
				frame.index = index;
				result.addChild(frame);
			}
			
			return result;
		}
		
		public static function getTrackFromSpriteSheet(index:int, source:BitmapData, tileWidth:Number = 100, tileHeight:Number = 100, startIndex:int = 0, endIndex:int = int.MAX_VALUE):AnimationTrack {
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
				frame.time = i - startIndex;
				frame.data = bitmapData;
				frame.index = index;
				result.addChild(frame);
			}
			return result;
		}
		
		public var name:String;
		public var texture:TextureBase;
		public var width:Number = 0;
		public var height:Number = 0;
		public var sampler:int;
		
		public function TextureResource(sampler:int, texture:TextureBase) {
			this.sampler = sampler;
			this.texture = texture;
		}
		
	}

}