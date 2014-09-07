/-----/  /-----/  /-----/  /-----/  /-----/


Creating Custom Levels
for Clockwork Cat

          __         __
 ____    /  \       /  \    ____  
(____)  /_/\_\     /_/\_\  (____)
 ____           _           ____  
(____)         (_)         (____)



How to go about creating a level

1. Get Ogmo Editor from http://www.ogmoeditor.com/

		Ogmo is a nice and simple 2D tile-based level editor. I used it for Clockwork Cat because I was familiar with it, and the other 2D tile-based editors felt too complex for such a simple game. Unfortunately, unlike Tiled or DAME, Ogmo is Windows-only. I sincerely apologize if you wanted to play around with creating levels for the game but are on another platform. I didn't ever plan on anyone but me making a level. Have one on me. =u.u=

2. From Ogmo, open the project file, clockwork.oep.

3. Poke around and make a level!

		Tutorials for Ogmo can be found at http://www.ogmoeditor.com/tutorials.html . I think I may have watched these tutorials. Ogmo is super simple, but it takes a bit to get used to getting around and learn all its quirks.

		Go to Project -> Edit Project to browse how the layers and entities are set up. Be sure not to change anything though!
		
		Open up the sample level (which is the one used in the game) to see how all the level components are set up.
		
4. Save your level, and open up the .oel file with a text editor such as Notepad, and copy it to your clipboard.

5. Paste the level into the game and test it! Huzzah! Share the level code with others once you're done!


/-----/  /-----/  /-----/  /-----/  /-----/


Tips / Other

<> Levels must satisfy the following requirements:

		TODO: this
		Minimum dimensions: 
		Maximum dimensions:
		Maximum number of (tiles + entities): 
		Have exactly 1 PlayerStart entity
		Have at least one EndGrip entity
		
		The game outputs helpful error messages of which requirements weren't satisfied.
		
<> Ogmo can be quirky. Here are some tips for things that frustrated me a little: (some may have been fixed in later versions)

		F1 - F5 toggle the tool windows quickly, in case you close them accidentally.
		
		If the Selection window is too small and can't be resized, double click on it to fullscreen it. This looks to have been fixed in recent versions though.
		
		Every time you open Ogmo, make sure Undo and Redo work. Sometimes they don't, but restarting Ogmo should fix it.
		
		Memorize all the tool hotkeys for both tile and entity layer types early on.
		
		When switching back to a tile layer from an entity layer, remember to select a tile from the palette before you can paint.
		
		Even though Ogmo associates itself with .oel and .oep filetypes, you still have to open them manually from inside Ogmo. It doesn't open files from Explorer. May be fixed in the future.
		
		In the Selection window be sure to hit Enter when done editing the text field. Sometimes clicking outside can cause changes not to be registered, etc.
		
		Save often!
		
<> Documentation of attributes / fields:
		
		HintTrigger Entity - You can resize this guy if you want. Also, as for line breaks, Ogmo will generate them in standard Windows format (a carriage return character and a line feed character) shown as &#xD;&#xA; . But each of these characters is interpreted by the game as a separate line break. Open the level in a text editor and manually delete one of the two characters to avoid having an unwanted gap between lines.

		MovingBlock Entity - xdistance and ydistance are the number of pixels (not tiles!) the block will move in that direction over the course of the clock ticking down. Each tile is 16 pixels. ricketdirection determines which direction the gear-toothed bar decoration will extend from the block. 1 - top, 2 - bottom, 3 - right, 4 - left.
		
		Key Entity - "special" parameter is set to 1 if that key is the key that slides off the block in the standard level. The key's movement is hardcoded instead of dynamic, so unfortunately you can't use falling keys in levels. It probably wouldn't have been too hard to code key physics, but I think I decided at the time that would take too much brainpower. TODO: update this
		
		Go to Level -> Level Properties to change the credits text at the end of the level.
		
<> Only the Newgrounds and Kongregate versions of the game have been updated to support custom levels. (unless other sites that hosted the game for some reason update it)

<> Other changes in the update:

		In addition to supporting custom levels, the game update also fixes various small problems the first version had. The most notable change is that the annoyances of the player physics are fixed! Hooray! Before, the game would sometimes not correctly register a jump right after landing, and it would take 1 or 2 frames to finish landing. This should be fixed. Other changes include the ability to press 'T' to return to the title screen, fixing the glitchy flash during fade transitions, and adding a lot of robustness to the game to handle the variance of custom levels.
		
		The player physics tweaks only apply to playing custom levels; when playing the standard level ('X' from title screen) the old physics are used. I did this to avoid obsoleting speedrun times.


/-----/  /-----/  /-----/  /-----/  /-----/


conclusion here
also put contact info (skype)


/-----/  /-----/  /-----/  /-----/  /-----/