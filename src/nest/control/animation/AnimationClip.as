package nest.control.animation 
{
	import flash.utils.getTimer;
	
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.object.Mesh;
	import nest.object.Object3D;
	import nest.view.material.ColorMaterial;
	import nest.view.material.TextureMaterial;
	
	/**
	 * AnimationClip
	 */
	public class AnimationClip {
		
		public var target:*;
		public var tracks:Vector.<AnimationTrack>;
		
		private var _paused:Boolean;
		private var _time:Number = -1;
		private var _lastTime:int = -1;
		
		private var _length:Number = -1;
		private var _currentLoop:uint = 0;
		
		public var speed:Number = 1;
		public var loops:uint=0;
		
		public function AnimationClip() {
			tracks = new Vector.<AnimationTrack>();
			time = 0;
		}
		
		public function play():void {
			_paused = false;
			_currentLoop = 0;
			_lastTime = getTimer();
		}
		
		public function pause():void {
			_paused = true;
		}
		
		public function update():void {
			if (_paused || !target) return;
			
			var curTime:int = getTimer();
			var dt:Number = (curTime-_lastTime)/1000;
			_lastTime = curTime;
			_time += dt * speed;
			if (_time > _length) {
				_time-= _length;
				_currentLoop++;
				if (_currentLoop > loops) {
					pause();
				}
			}
			var t:Number = _time;
			var offsetTime:Number;
			var frame:KeyFrame;
			var weight1:Number;
			var weight2:Number;
			var l:uint, i:int, j:int;
			
			var mesh:IMesh;
			for each(var track:AnimationTrack in tracks) {
				frame = track.frameList;
				while (frame && t >= frame.time) {
					offsetTime = frame.time;
					frame = frame.next;
				}
				if (frame) {
					weight2 = (t - offsetTime) / (frame.time-offsetTime);
					weight1 = 1 - weight2;
					if (!weight1) {
						weight1 = 1;
						weight2 = 0;
					}
					if (frame is VertexKeyFrame && target is IMesh) {
						if (frame.next) {
							mesh = target as IMesh;
							var curVertices:Vector.<Number> = (frame as VertexKeyFrame).vertices;
							var nextVertices:Vector.<Number> = (frame.next as VertexKeyFrame).vertices;
							l = curVertices.length/3;
							for (i = 0, j = 0; i < l; i++, j += 3) {
								mesh.data.vertices[i].x = curVertices[j] * weight1 + nextVertices[j] * weight2;
								mesh.data.vertices[i].y = curVertices[j + 1] * weight1 + nextVertices[j + 1] * weight2;
								mesh.data.vertices[i].z = curVertices[j + 2] * weight1 + nextVertices[j + 2] * weight2;
							}
							mesh.data.update(false);
						}
					} else if (frame is UVKeyFrame && target is IMesh) {
						if (frame.next) {
							mesh = target as IMesh;
							var curUVs:Vector.<Number> = (frame as UVKeyFrame).uvs;
							var nextUVs:Vector.<Number> = (frame.next as UVKeyFrame).uvs;
							l = curVertices.length/2;
							for (i = 0; i < l; i++ ) {
								mesh.data.vertices[i].u = curUVs[i << 1] * weight1 + nextUVs[i << 1] * weight2;
								mesh.data.vertices[i].v = curUVs[(i << 1) + 1] * weight1 + nextUVs[(i << 1) + 1] * weight2;
							}
							mesh.data.update(false);
						}
					} else if (frame is TextureKeyFrame) {
						var textureFrame:TextureKeyFrame = frame as TextureKeyFrame;
						if (target is TextureMaterial) {
							var textureMat:TextureMaterial = target as TextureMaterial;
							
							if(textureFrame.diffuse) textureMat.diffuse.data = textureFrame.diffuse;
							if (textureFrame.specular) textureMat.specular.data = textureFrame.specular;
							if (textureFrame.normalMap) textureMat.normalmap.data = textureFrame.normalMap;
							
						} else if (target is ColorMaterial&&target is ColorMaterial&&frame.next) {
							var nextTextureFrame:TextureKeyFrame = frame.next as TextureKeyFrame;
							var colorMat:ColorMaterial = target as ColorMaterial;
							var r:uint = ((textureFrame.color >> 16) & 0xff) * weight1 + ((nextTextureFrame.color >> 16) & 0xff) * weight2;
							var g:uint = ((textureFrame.color >> 8) & 0xff) * weight1 + ((nextTextureFrame.color >> 8) & 0xff) * weight2;
							var b:uint = (textureFrame.color & 0xff) * weight1 + (nextTextureFrame.color & 0xff) * weight2;
							
							colorMat.color = (r << 16) | (g << 8) | b;
							colorMat.alpha = textureFrame.alpha * weight1 + nextTextureFrame.alpha * weight2;
						}
					}else if (frame is TransformKeyFrame) {
						if (frame.next) {
							var curTrans:TransformKeyFrame = frame as TransformKeyFrame;
							var nextTrans:TransformKeyFrame = frame.next as TransformKeyFrame;
							
							target.position.setTo(curTrans.position.x * weight1 + nextTrans.position.x * weight2,
												  curTrans.position.y * weight1 + nextTrans.position.y * weight2,
												  curTrans.position.z * weight1 + nextTrans.position.z * weight2);
												  
							target.rotation.setTo(curTrans.rotation.x * weight1 + nextTrans.rotation.x * weight2,
												  curTrans.rotation.y * weight1 + nextTrans.rotation.y * weight2,
												  curTrans.rotation.z * weight1 + nextTrans.rotation.z * weight2);
							if (target is IMesh) {
								(target as IMesh).scale.setTo(curTrans.scale.x * weight1 + nextTrans.scale.x * weight2,
												  curTrans.scale.y * weight1 + nextTrans.scale.y * weight2,
												  curTrans.scale.z * weight1 + nextTrans.scale.z * weight2);
							}
							target.recompose();
						}
					}
				}
			}
			
		}
		
		public function slice(startTime:Number = 0, endTime:Number = Number.MAX_VALUE):AnimationClip {
			var sliceClip:AnimationClip = new AnimationClip();
			endTime = Math.min(Math.max(0,endTime), _length);
			startTime = Math.min(Math.max(0, startTime), _length);
			var offsetTime:Number;
			for each(var track:AnimationTrack in tracks) {
				var frame:KeyFrame = track.frameList;
				var copyTrack:AnimationTrack = new AnimationTrack();
				while (startTime > frame.time) {
					offsetTime = frame.time;
					frame = frame.next;
				}
				if (frame) {
					var weight2:Number = (startTime-offsetTime) / (frame.time-offsetTime);
					var weight1:Number = 1 - weight2;
					var copy_frame:KeyFrame;
					if (frame is VertexKeyFrame) {
						copy_frame = VertexKeyFrame.interpolate(frame as VertexKeyFrame, frame.next as VertexKeyFrame, weight1, weight2);
						copy_frame.time-= offsetTime;
						copyTrack.addFrame(copy_frame);
					}else if (frame is UVKeyFrame) {
						copy_frame = UVKeyFrame.interpolate(frame as UVKeyFrame, frame.next as UVKeyFrame, weight1, weight2);
						copy_frame.time-= offsetTime;
						copyTrack.addFrame(copy_frame);
					}else if (frame is TextureKeyFrame) {
						copy_frame = TextureKeyFrame.interpolate(frame as TextureKeyFrame, frame.next as TextureKeyFrame, weight1, weight2);
						copy_frame.time-= offsetTime;
						copyTrack.addFrame(copy_frame);
					}else if (frame is TransformKeyFrame) {
						copy_frame = TransformKeyFrame.interpolate(frame as TransformKeyFrame, frame.next as TransformKeyFrame, weight1, weight2);
						copy_frame.time-= offsetTime;
						copyTrack.addFrame(copy_frame);
					}
					frame = frame.next;
					while (frame&&frame.time<endTime) {
						copy_frame = frame.clone();
						copy_frame.time-= offsetTime;
						copyTrack.addFrame(copy_frame);
						frame = frame.next;
					}
				}
				sliceClip.addTrack(copyTrack);
			}
			return sliceClip;
		}
		
		public function clone():AnimationClip {
			var result:AnimationClip = new AnimationClip();
			var l:uint = tracks.length;
			var copyTracks:Vector.<AnimationTrack> = new Vector.<AnimationTrack>(l);
			for (var i:int = 0; i < l;i++ ) {
				copyTracks[i] = tracks[i].clone();
			}
			result.tracks = copyTracks;
			return result;
		}
		
		public function addTrack(track:AnimationTrack):void {
			tracks.push(track);
			if (track.length>_length) {
				_length = track.length;
			}
		}
		
		public function removeTrack(track:AnimationTrack):void {
			var index:int = tracks.indexOf(track);
			var l:uint = tracks.length-1;
			if (index!=-1) {
				if (index!=l) {
					tracks[index] = tracks.pop();
				}else {
					tracks.pop();
				}
			}
			_length = -1;
			for each(var tempTrack:AnimationTrack in tracks) {
				if (tempTrack.length>_length) {
					_length = tempTrack.length;
				}
			}
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
			_lastTime = getTimer();
		}
		
		public function get length():Number {
			return _length;
		}
		
	}

}