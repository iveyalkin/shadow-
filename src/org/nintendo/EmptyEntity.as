package org.nintendo 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Basil Terkin
	 */
	public class EmptyEntity extends Entity 
	{
		
		public function EmptyEntity(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			
		}

		override public function update():void 
		{
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
		}
	}

}