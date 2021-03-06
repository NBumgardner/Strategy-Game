package utilities;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import missions.TerrainTypes;

/**
 * Small extension of the FlxOgmoLoader class that has additional capabilities
 * 	that this particular game needs when loading data from an ogmo editor level
 * 	file (.oel).
 * @author Samuel Bumgardner
 */
class StrategyOgmoLoader extends FlxOgmoLoader
{
	/**
	 * Generates a 2-D array of integers reflecting what type each of the map's tiles
	 * 	is in a strategic sense, rather than a visual one.
	 * 
	 * Uses array generated by loadTerrainTypesTranslator() to convert the tile numbers
	 * 	in the level's CSV list to match the values found in the TerrainTypes enum.
	 * 
	 * @param	TileLayer	The name of the tile layer that should be read.
	 * @param	tileSize	The size of the map's tiles (assumed to be square).
	 * @return	2-D array of integers that represent the tactical tile information of the level.
	 */
	public function loadTerrainArray(TileLayer:String, tileSize:Int = 64):Array<Array<Int>>
	{
		// The text must be split by \n, then resulting strings must be split by a comma.
		var fullTextArray:Array<String> = _fastXml.node.resolve(TileLayer).innerData.split("\n");
		var lineTextArray:Array<String>;
		
		var terrainArray:Array<Array<Int>> = new Array<Array<Int>>();
		
		var typeTranslator:Array<Int> = loadTerrainTypesTranslator();
		
		var rows:Int = Math.floor(height / tileSize);
		var cols:Int = Math.floor(width / tileSize);
		for (row in 0...rows)
		{
			lineTextArray = fullTextArray[row].split(",");
			terrainArray.push(new Array<Int>());
			for (col in 0...cols)
			{
				terrainArray[row].push(typeTranslator[Std.parseInt(lineTextArray[col])]);
			}
		}
		
		return terrainArray;
	}
	
	/**
	 * Creates array that can be used to translate a tile number found in a level's terrain 
	 * 	array into a number that matches its terrain entry in the TerrainTypes enum.
	 * 
	 * Depends on the level's terrain_type_tile_(insert_num_here) properties to link
	 * 	the terrain array's number (which just matches the posiiton of that tile in the sprite
	 * 	sheet of strategic terrain tiles) to the terrain type it's supposed to represent.
	 * 
	 * 	To give a quick example, consider a level with three kinds of terrain: plains, wreckage,
	 * 		and river tiles. The spritesheet used when laying out the tiles in Ogmo Editor follows
	 * 		the same order. It starts with a blank tile and then has plains, wreckage, and river.
	 * 
	 * 	To make it possible for the game to interpret the level's strategic terrain, the level's
	 * 		properties should be set as follows:
	 * 			number_of_terrain_types = 3
	 * 			terrain_type_tile_1 = 0
	 * 			terrain_type_tile_2 = 3
	 * 			terrain_type_tile_3 = 6
	 * 			terrain_type_tile_4 = -1
	 * 			... etc.
	 * 		The number_of_terrain_types was set to 3 because there were three distinct terrain
	 * 			tiles in the sprite sheet that was used to draw the level.
	 * 		The terrain_type_tile variables were set according to the values found in the 
	 * 			TerrainTypes enum. terrain_type_tile_1 was set to 0 because the plains entry in 
	 * 			the TerrainTypes enum is 0.  terrain_type_tile_2 was set to 3 because the wreckage
	 * 			entry in the TerrainTypes enum is 3, and so on.
	 * 
	 * @return	Array of integers that maps the provided index (the number of tile in the level file) to the terrain type (from TerrainTypes enum).
	 */
	public function loadTerrainTypesTranslator():Array<Int>
	{
		var terrainTypesArray:Array<Int> = new Array<Int>();
		
		// Tile #0 is never used in a level, so push a NONE terrain type first.
		terrainTypesArray.push(TerrainTypes.NONE);
		
		for (i in 1...Std.parseInt(getProperty("number_of_terrain_types")) + 1)
		{
			terrainTypesArray.push(Std.parseInt(
				getProperty("terrain_type_tile_" + Std.string(i))));
		}
		
		return terrainTypesArray;
	}
	
}