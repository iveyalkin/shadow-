package org.nintendo
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Math;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Box2D.Common.Math.b2Vec2;
	
	
	/**
	 * ...
	 * @author Basil Terkin
	 */
	public class Main extends Sprite 
	{
		private var _objects:Array/*b2PolygonShape*/ =  new Array(
				b2PolygonShape.AsArray(new Array(
					new b2Vec2(150, 150), 
					new b2Vec2(300, 100), 
					new b2Vec2(250, 250), 
					new b2Vec2(100, 300), 
					new b2Vec2(200, 200)), 
					5),
				b2PolygonShape.AsArray(new Array(
					new b2Vec2(400, 150),
					new b2Vec2(550, 150),
					new b2Vec2(550, 300),
					new b2Vec2(400, 300)),
					4),
				b2PolygonShape.AsArray(new Array(
					new b2Vec2(250, 450),
					new b2Vec2(350, 550),
					new b2Vec2(150, 600)),
					3));
		
		private var _lightPosition:b2Vec2 = new b2Vec2(50, 150);
		
		private var _shadows:Shape;
		private var _lightShape:Shape;
		
		public function Main() 
		{
			/*super(800, 600, 60, false); // flash punk goes here
			FP.world = new HelloWorld();*/
			if (stage)
			{
				init();
			}
			else
			{
				stage.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		/*override public function init():void // flash punk
		{
		}*/
		
		private function init(e:Event = null):void 
		{
			stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			_lightShape = new Shape();
				addChild(_lightShape)
					redrawLight(_lightShape.graphics, _lightPosition);
			
			_shadows = new Shape();			
				addChild(_shadows);
				
			var objectShape:Shape = new Shape();
				addChild(objectShape);
			
			drawObjects(objectShape);
			
			render();
			stage.addEventListener(MouseEvent.CLICK, pointLight);
		}
		
		private function pointLight(e:MouseEvent):void 
		{
			_lightPosition.Set(e.localX, e.localY);
			redrawLight(_lightShape.graphics, _lightPosition);
			render();
		}
		
		private function render():void 
		{
			drawShadow(_lightPosition, _objects);
		}
		
		private function projectPoint(ligh:b2Vec2, point:b2Vec2):b2Vec2
		{
			var lightToPoint:b2Vec2 = point.Copy();
			lightToPoint.Subtract(ligh);
			var projectedPoint:b2Vec2 = point.Copy();
			projectedPoint.Add(lightToPoint);
			return projectedPoint;
		}
		
		private function testShadowCasting(vertextA:b2Vec2, vertexB:b2Vec2, light:b2Vec2):Boolean
		{
			var startToEnd:b2Vec2 = vertexB.Copy();
			startToEnd.Subtract(vertextA);

			var normal:b2Vec2 = new b2Vec2(startToEnd.y, -1 * startToEnd.x);

			var lightToStart:b2Vec2 = light.Copy();
			lightToStart.Subtract(vertextA);
			
			return (b2Math.Dot(normal, lightToStart) < 0);
		}
		
		private function drawShadow(light:b2Vec2, objects:Array):void
		{
			var shadows:Graphics = _shadows.graphics;
			shadows.clear();
			shadows.lineStyle(1, 0, 0);
			
			_objects.forEach(function(object:b2PolygonShape, index:uint, objects:Array):void 
			{
				if (object.GetVertexCount() > 0) 
				{
					for (var currentVertext:uint = 0, 
							 verts:Array = object.GetVertices(), 
							 count:uint = verts.length, 
							 vertexA:b2Vec2 = verts[currentVertext], vertexB:b2Vec2, projectedPoint:b2Vec2; // used as a temp vars
						currentVertext < count;
						currentVertext++, vertexA = vertexB)
					{	
						vertexB = verts[currentVertext < count - 1 ? currentVertext + 1 : 0];
						
						if (testShadowCasting(vertexA, vertexB, light))
						{
							shadows.beginFill(0, 1);
							shadows.moveTo(vertexA.x, vertexA.y);
							projectedPoint = projectPoint(light, vertexA);
							shadows.lineTo(projectedPoint.x, projectedPoint.y);
							projectedPoint = projectPoint(light, vertexB);
							shadows.lineTo(projectedPoint.x, projectedPoint.y);
							shadows.lineTo(vertexB.x, vertexB.y);
							shadows.endFill();
						}
					}
				}
			});
		}
		
		private function redrawLight(light:Graphics, position:b2Vec2):void 
		{
			light.clear();
			light.beginFill(0xFF0000, 1);
			light.drawCircle(position.x, position.y, 5);
		}
		
		private function drawObjects(object:Shape):void 
		{
			var objectGrap:Graphics = object.graphics;
			_objects.forEach(function(object:b2PolygonShape, index:uint, objects:Array):void 
			{ 
				if (object.GetVertexCount() > 0)
				{
					objectGrap.lineStyle(0xFF0000, 0, 0);
					objectGrap.beginFill(0xFFFF00, 1);
					var verts:Array = object.GetVertices();
					var vertex:b2Vec2 = verts[verts.length - 1];
					objectGrap.moveTo(vertex.x, vertex.y);
					for each(vertex in verts)
					{
						objectGrap.lineTo(vertex.x, vertex.y);
					}
					objectGrap.endFill();
				}
			}, null);
		}
	}
}