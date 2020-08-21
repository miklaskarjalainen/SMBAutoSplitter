state("nestopia")
{
	byte State : 0x001B1300 , 0x84 , 0x7D8;
	byte Level : 0x001B1300 , 0x34 , 0x7C8;
	byte World : 0x001B1300 , 0x5C , 0x7C7;
	byte BowserHP : 0x001AE0C8 , 0xA0 , 0x53B; //Use to check if bowser is on screen
	//byte FrameCount : 0x001AE0C8 , 0x9C , 0x24; //frame count if you want you could make a calculation for the time, i think that it would work that well tho.
	
	//byte loadDone : 0x001AE0C8,0xA0,0x82A; equals two when should split in warpzone
	byte onScreenX : 0x001AE0C8,0xA0,0x2BF;
}

init
{
	vars.levelChanged = false; //on level change, change this.
	vars.EightBowser = false; //8 bowser trigger
}

split
{
	if (old.World != current.World || old.Level != current.Level) //if level changed
	{ 
		if (old.World == 0 && old.Level == 1) //1-2 cutscene
		{
			vars.levelChanged = false;
			return false;
		}
		else if (old.World == 1 && old.Level == 1) //2-2 cutscene
		{
			vars.levelChanged = false;
			return false;
		}
		else if (old.World == 3 && old.Level == 1) //4-2 cutscene
		{
			vars.levelChanged = false;
			return false;
		}
		else if (old.World == 6 && old.Level == 1) //7-2 cutscene
		{
			vars.levelChanged = false;
			return false;
		}
		
		vars.levelChanged = true;
	}
	
	
	if (current.World == 7 && current.BowserHP > 0) //if world 8 and bowser on screen
	{
		vars.EightBowser = true;
	}	
	
	
	//SPLIT
	if (vars.levelChanged==true)
	{
		print("World: "+current.World.ToString());
		print("Level: "+current.Level.ToString());
		if (current.World==0 && current.Level == 0) {return false;} //Prevent "Ghost Splits" when resetting.
		vars.levelChanged = false;
		return true;
	}
	
	if (vars.EightBowser == true && current.onScreenX > 210)
	{
		vars.EightBowser = false;
		vars.levelChanged = false;
		return true;
	}
	
}

start
{	
	if (current.State==1 && current.World == 0 && current.Level == 0 && current.loadDone==2){
		vars.EightBowser = false;
		vars.levelChanged = false;
		vars.levelChanged = false;
		return true;
	}
}

/*            GNU GENERAL PUBLIC LICENSE
                 Version 2, June 1991

 Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
*/