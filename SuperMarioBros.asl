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
	vars.levelChanged = false; //on level change, change this.
	vars.LastCastle = false; //LastCastle trigger (8bowser and -3 can trigger)
	//vars.EightBowser = false; //8 bowser trigger
	vars.GameOver = false; //is Player gameovered recently
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
	if (current.State==3) {vars.GameOver=true;} //Player has gameOvered
	if (current.World == 35 && current.Level == 2){vars.LastCastle = true;} //-3 world trigger
}

split
{
	//Check if level has changed.
	if (old.World != current.World || old.Level != current.Level) 
	{ 
		//Cutscenes are it's own levels so they would activate a split.
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
		else if (vars.GameOver && current.State==1 && current.World!=0) //Player continued after dying, autosplitter cant undo splits, have to make a workaround
		{
			vars.levelChanged = false;
			vars.GameOver=false;
			return false;
		}
		
		vars.levelChanged = true;
	}

	//SPLIT
	if (vars.levelChanged==true)
	{
		if (current.State != 1) {return false;} //Prevent "Ghost Splits" when resetting.
		vars.levelChanged = false;
		return true;
	}
	
	if (vars.LastCastle == true && current.onScreenX > 210)
	{
		vars.LastCastle = false;
		vars.levelChanged = false;
		return true;
	}
	
}

start //checked only when the timer is not already running
{	
	//For level enter
	if (current.State==1 && current.World == 0 && current.Level == 0 && current.loadDone==2){
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