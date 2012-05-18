package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import bloom.components.Button;
	import bloom.components.FlowContainer;
	import bloom.components.Label;
	import bloom.core.ThemeBase;
	import bloom.themes.BlueTheme;
	
	/**
	 * ModelPacker
	 */
	[SWF(backgroundColor = 0xffffff, frameRate = 40, width = 410, height = 50)]
	public class ModelPacker extends Sprite {
		
		private var file:FileReference;
		private var fileSave:FileReference;
		private var filter:FileFilter;
		
		private var source:ByteArray;
		
		private var saveButton:Button;
		private var loadButton:Button;
		
		public function ModelPacker() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			file = new FileReference();
			fileSave = new FileReference();
			filter = new FileFilter("Obj (*.obj)", "*.obj");
			
			file.addEventListener(Event.SELECT, onFileSelected);
			file.addEventListener(Event.COMPLETE, onComplete);
			
			ThemeBase.initialize(stage);
			ThemeBase.theme = new BlueTheme();
			
			var container:FlowContainer = new FlowContainer(this);
			container.direction = FlowContainer.HORIZONTALLY;
			
			var label:Label = new Label(container.content, "Obj Compresser For Nest3D");
			label.margin.top = 15;
			loadButton = new Button(container.content, "Load");
			loadButton.mouseClick.add(browse);
			loadButton.size(100, 40);
			saveButton = new Button(container.content, "Save");
			saveButton.mouseClick.add(save);
			saveButton.enabled = false;
			saveButton.size(100, 40);
			
			container.size(410, 50);
			container.update();
		}
		
		private function onComplete(e:Event):void {
			if (source) source.clear();
			source = file.data;
			saveButton.enabled = true;
		}
		
		private function onFileSelected(e:Event):void {
			file.load();
		}
		
		private function browse(e:MouseEvent):void {
			file.browse([filter]);
		}
		
		private function save(e:MouseEvent):void {
			if (source) {
				source.uncompress();
				fileSave.save(source, "compressed.obj");
				source.clear();
				source = null;
				saveButton.enabled = false;
			}
		}
	}

}