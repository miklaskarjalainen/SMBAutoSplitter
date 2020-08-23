state("nestopia")
{
	byte State : 0x001AE0C8 , 0x9C , 0x828;
	byte Level : 0x001AE0C8 , 0x9C , 0x818; //Level = curLevel - 1
	byte World : 0x001AE0C8 , 0x9C , 0x817; //World = curWorld - 1
	byte BowserHP : 0x001AE0C8 , 0xA0 , 0x53B; //Use to check if bowser is on screen
	//byte FrameCount : 0x001AE0C8 , 0x9C , 0x24; //frame count if you want you could make a calculation for the time, i think that it would work that well tho.
	
	byte loadDone : 0x001AE0C8,0xA0,0x82A; //equals two when should split in warpzone. Also used on titlescreen!
	byte onScreenX : 0x001AE0C8,0xA0,0x2BF;
}

init
{
	refreshRate = 120;
	vars.levelChanged = false; //on level change, change this.
	vars.LastCastle = false; //LastCastle trigger (8bowser and -3 will trigger)
	vars.GameOver = false; //is Player gameovered recently
	vars.doWarpzoneSplit = false;
}

reset
{
	//Player didn't continue after restarting
	if (current.State==1 && vars.GameOver && current.Level == 0 && current.World == 0)
	{
		vars.GameOver=false;
		return true;
	}
}

update
{
	
	if (current.State==3)                       {vars.GameOver  =true;} //Player has gameOvered
	if (current.World==7 && current.BowserHP>0) {vars.LastCastle=true;} //Bowser Trigger
	if (current.World==35 && current.Level==2)  {vars.LastCastle=true;} //-3 world Trigger
}

split
{
	byte o = old.World;
	byte c = current.World;
	
	//Check if level has changed.
	if (old.World != current.World || old.Level != current.Level) 
	{ 
		
		
		if ((c==0 || c==3) && current.Level==2) //Checks if we're in 1-2 4-2 (warpzones)
		{
			vars.doWarpzoneSplit=true;
		} 
		
		//Cutscenes are they're own levels so they would activate a split.
		if ((o==0 || o==1 || o==3 || o==6) && old.Level==1) //If has cutscene
		{
			vars.levelChanged = false;
			return false;
		}
		
		//Player continued after dying, autosplitters cant undo splits, have to make a workaround
		else if (vars.GameOver && current.State==1 && c!=0) 
		{
			vars.levelChanged = false;
			vars.GameOver=false;
			return false;
		}
		
		vars.levelChanged = true;
	}

	//SPLIT
	if (vars.levelChanged)
	{
		if (current.State != 1) {return false;} //Prevent "Ghost Splits" when resetting.
		if (vars.doWarpzoneSplit) //Split later if warpzone pipe entered
		{
			if (current.loadDone==2)
			{
				vars.levelChanged = false;
				vars.doWarpzoneSplit=false;
				return true;
			}
			return false;
		}
		vars.levelChanged = false;
		return true;
	}
	
	//if in -3 or 8-4 and screen is scrolled far enough to hit the axe.
	if (vars.LastCastle == true && current.onScreenX > 210)
	{
		vars.LastCastle = false;
		vars.levelChanged = false;
		return true;
	}
	
}

start //checked only when the timer is not already running
{	
	if (current.State==1 && current.World == 0 && current.Level == 0 && current.loadDone==2)
	{
		vars.LastCastle = false;
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