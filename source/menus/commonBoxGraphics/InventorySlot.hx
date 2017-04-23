package menus.commonBoxGraphics;

import boxes.BoxCreator;
import boxes.VarSizedBox;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class InventorySlot extends FlxSprite implements VarSizedBox
{

	/**
	 * Variables to satisfy VarSizedBox interface.
	 * Specifies the qualities of the menu's box.
	 */
	public var cornerSize(default, never):Int		= 24;
	public var backgroundSize(default, never):Int	= 24;
	public var boxWidth(default, null):Int = 300 - 32;
	public var boxHeight(default, null):Int = 48;
	public var boxSpriteSheet(default, null):FlxGraphicAsset = AssetPaths.inv_slot__png;
	
	public var graphicOffset:Int = 4;
	
	public static var sharedGraphic:FlxSprite;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		if (sharedGraphic == null)
		{
			BoxCreator.setBoxType(boxSpriteSheet, cornerSize, backgroundSize);
			sharedGraphic = BoxCreator.createBox(boxWidth, boxHeight);
		}
		
		loadGraphicFromSprite(sharedGraphic);
		active = false;
		offset.y = graphicOffset;
	}
	
}