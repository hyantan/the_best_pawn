forward SendChakMessage(playerid, string[]);
public SendChakMessage(playerid, string[])
{
    for(new i = 0; i < GetMaxPlayers(); i++)
	{
        if(IsPlayerConnected(i))
        {
			if (pInfo[playerid][pAvtobusnik] == 1)//1 ?????? ?? ???? ???????????.
			{
 				SendClientMessage(i, COLOR_GREEN, string);
  			}
        }
    }
}
forward spawned_bus(playerid);
public spawned_bus(playerid) {
	DisablePlayerRaceCheckpoint(playerid);
	SetVehicleToRespawn(GetPVarInt(playerid, #busID));
	DeletePVar(playerid, #busID);
	if(pInfo[playerid][Text3dAvt] != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(pInfo[playerid][Text3dAvt]);
	pInfo[playerid][Text3dAvt] = Text3D:INVALID_3DTEXT_ID;
	pInfo[playerid][bus_timer] = false;
	return 1;
}
CMD:rv(playerid, params[])// boris,br ?????? ?? ???? ???????
    {
        if(IsPlayerConnected(playerid))
        {
            if(!strlen(params))
            {
                SendClientMessage(playerid, COLOR_GREEN, "Èñïîëüçóéòå: /rv [òåêñò]");
            }
            else {
          		new string[144];
				format(string, sizeof(string), "{8b00ff}[×ÀÊ] %s[%d]: {ffffff}%s", GetName(playerid), playerid, params);
            	if (pInfo[playerid][pAvtobusnik] == 1)
            	{
                	SendChakMessage(playerid, mysql_query_string);//????
            	}
			}
        }
        return 1;
	}
public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == qw1)
	{
 		SetPlayerPos(playerid,2764.4094,994.0613,1941.1071);
 		SetPlayerInterior(playerid, 99);
 		SetPlayerVirtualWorld(playerid, 120);
 		SetPlayerFacingAngle(playerid, 267.6637);
        SetCameraBehindPlayer(playerid);
	}
	if(pickupid == qw2)
	{
 		SetPlayerPos(playerid,2814.7959,971.3642,10.7500);
 		SetPlayerInterior(playerid, 0);
 		SetPlayerVirtualWorld(playerid, 0);
 		SetPlayerFacingAngle(playerid, 179.8066);
        SetCameraBehindPlayer(playerid);
	}
	if(pickupid == qw3)
	{
		mysql_tquery(dbHandle, "SELECT * FROM chak", "@ChakInf", "i", playerid);
	}
	if(pickupid == qw4 && !pInfo[playerid][AvtobusMetka])
	{
	    if (!pInfo[playerid][naRaboteAvt]) {
		OpenRazdevalka(playerid);
		}
		else CloseRazdevalka(playerid);
	}
	if(pickupid == qw5 && !pInfo[playerid][AvtobusMetka])
	{
        OpenAvtobus2(playerid);
	}
	if(pickupid == qw6 && !pInfo[playerid][AvtobusMetka])
	{
        OpenAvtobus(playerid);
	}
 	if(pickupid == qw7)
	{
	
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	for(new i; i < strlen(inputtext); i++)
	{
     	if(inputtext[i] == '%') inputtext[i] = '#';
     	else if(inputtext[i] == '\\') inputtext[i] = '#';
     	else if(inputtext[i] == '{' && inputtext[i+7] == '}') strdel(inputtext, i, i+8);
	}
	if(GetPVarInt(playerid,"USEDIALOGID") != dialogid) return 1;
	SetPVarInt(playerid, "USEDIALOGID", -1);
	switch(dialogid)
	{
	    case ChakInf:
		{
			if(!response) {OpenAvtobus(playerid); return 1;}
			else return SetTimerEx("ExitAvtobus", 2000, false, "d", playerid);
		}
		
	    case 8007:
	    {
	        if(!response) return SetTimerEx("ExitAvtobus", 2000, false, "d", playerid);
			switch(listitem)
			{
				case 0:
				{
				    mysql_tquery(dbHandle, "SELECT * FROM chak", "@ChakInf", "i", playerid);
				}
				case 1:
				{
			 		mysql_query_string[0] = EOS;
					format(mysql_query_string, 200, "UPDATE accounts SET avtobus = 1 WHERE name = '%s'", GetName(playerid));
					pInfo[playerid][pAvtobusnik] = 1;
					mysql_tquery(dbHandle, mysql_query_string, "", "");
					SendClientMessage(playerid,COLOR_GREEN,"Âû óñïåøíî óñòðîèëèñü íà ðàáîòó!");
					SetTimerEx("ExitAvtobus", 2000, false, "d", playerid);
				}
			}
		}
		case 5432:
		{
		    if(!response) return SetTimerEx("ExitAvtobus", 2250, false, "d", playerid);
			else {
				SetPlayerSkin(playerid, 8);
				pInfo[playerid][naRaboteAvt] = true;
				pInfo[playerid][AvtobusMetka] = false;
			}
		}
		case 5433:
		{
		    if(!response) return SetTimerEx("ExitAvtobus", 2250, false, "d", playerid);
			else {
				SetPlayerSkin(playerid, pInfo[playerid][pModel]);
				pInfo[playerid][naRaboteAvt] = false;
				pInfo[playerid][AvtobusMetka] = false;
			}
		}
		case ChakVlad:
		{
		    if(!response) return SetTimerEx("ExitAvtobus", 2500, false, "d", playerid);
			switch(listitem)
			{
				case 0:
				{
				    ShowPlayerDialog(playerid, ChakUpravArend, DIALOG_STYLE_INPUT, "{ffd700}×ÀÊ |{ffffff} Óïðàâëåíèå ñòîèìîñòüþ àðåíäû", "{ffffff}Ââåäèòå ñòîèìîñòü ñòîèìîñòü àðåíäû çà àâòîáóñ:", "Îòïðàâèòü", "Îòìåíèòü");
				}
				case 1:
				{
				    return SetTimerEx("ExitAvtobus", 2500, false, "d", playerid);
				}
				case 2:
				{
					ShowPlayerDialog(playerid, 5532, DIALOG_STYLE_LIST, "{ffd700}×ÀÊ |{ffffff} Óïðàâëåíèå àâòîïàðêîì", "{{ffd700}1. {ffffff}Ïîäðîáíàÿ ñòàòèñòèêà àâòîïàðêà\n{ffd700}2. {ffffff}Óëó÷øåíèÿ àâòîïàðêà\n{ffd700}3. {ffffff}Ðàçðåøåíèÿ â àâòîïàðêå", "Âûáðàòü", "Íàçàä");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, 5537, DIALOG_STYLE_LIST, "{ffd700}×ÀÊ |{ffffff} Óïðàâëåíèå ðàöèåé", "{ffd700}1. {ffffff}Èçìåíåíèå öâåòà ðàöèè\nÌÅÔ", "Âûáðàòü", "Íàçàä");
				}
			}
		}
		case 5532:
		{
		    if(!response) {
				OpenAvtobus2(playerid);
				return 1;
			}
			else return SetTimerEx("ExitAvtobus", 2500, false, "d", playerid);
		}
		case ChakUpravArend:
		{
  			if(!response) return SetTimerEx("ExitAvtobus", 2500, false, "d", playerid);
			else return SetTimerEx("ExitAvtobus", 2500, false, "d", playerid);
		}
		case avtInf:
	    {
	        if(!response) return 1;
		}
		case avtArent:
	    {
	        if(!response) {
	            SendClientMessage(playerid, COLOR_RED, "Âû îòêàçàëèñü îò àðåíäû àâòîáóñà");
	            RemovePlayerFromVehicle(playerid);
	        }
			else {
			    new string[32];
   				SendClientMessage(playerid, 0xFFFFFFAA, string);
			    if (pInfo[playerid][pCash] < 250) {
			        SendClientMessage(playerid, COLOR_RED, "Ó Âàñ íåäîñòàòî÷íî ñðåäñòâ");
			        RemovePlayerFromVehicle(playerid);
			        return 1;
			    }
			    else {
				SendClientMessage(playerid, COLOR_GREEN, "Âû óñïåøíî àðåíäîâàëè àâòîáóñ!");
			    pInfo[playerid][pCash] -= 250;
			    ShowPlayerDialog(playerid, 4312, DIALOG_STYLE_LIST, "{ffd700}×ÀÊ | {ffffff}Âûáîð ìàðøðóòà", "{ffd700}1. {ffffff}Âíóòðèãîðîäñêîé ËÂ\n{ffd700}2. {ffffff}Îêîëîãîðîäíèé ËÑ", "Âûáðàòü", "Îòêëîíèòü");
			    }
			}
		}
		case 4312:
	    {
	        if(!response) {
	            SendClientMessage(playerid, COLOR_RED, "Âû îòêàçàëèñü îò àðåíäû àâòîáóñà");
	            RemovePlayerFromVehicle(playerid);
	        }
			switch(listitem)
			{
				case 0:
				{
				    pInfo[playerid][AvtobusTochka] = 0;
				    pInfo[playerid][AvtobusTochka2] = 1;
				    pInfo[playerid][AvtobusTochkaInf] = 0;
				    SetPVarInt(playerid, #busID, GetPlayerVehicleID(playerid));
					SetPlayerRaceCheckpoint(playerid, 0, AvtobusCoords[0][0], AvtobusCoords[0][1], AvtobusCoords[0][2], AvtobusCoords[1][0], AvtobusCoords[1][1], AvtobusCoords[1][2], 7.0);
					pInfo[playerid][Text3dAvt] = Create3DTextLabel("{ffd700}---Âíóòðèãîðîäñêîé LV---\n{ffffff}Öåíà çà ïðîåçä: {ffd700}Áåñïëàòíî", 0x000000FF, 9999.0, 9999.0, 9999.0, 50.0, 0, 0);
                 	Attach3DTextLabelToVehicle(pInfo[playerid][Text3dAvt], GetPlayerVehicleID(playerid), 0.0, 0.0, 3.0);
				}
				case 1:
				{
				    pInfo[playerid][AvtobusTochka] = 0;
				    pInfo[playerid][AvtobusTochka2] = 1;
				    pInfo[playerid][AvtobusTochkaInf] = 1;
				    SetPVarInt(playerid, #busID, GetPlayerVehicleID(playerid));
					SetPlayerRaceCheckpoint(playerid, 0, AvtobusCoords2[0][0], AvtobusCoords2[0][1], AvtobusCoords2[0][2], AvtobusCoords2[1][0], AvtobusCoords2[1][1], AvtobusCoords2[1][2], 7.0);
					pInfo[playerid][Text3dAvt] = Create3DTextLabel("{ffd700}---Îêîëîãîðîäíèé LS---\n{ffffff}Öåíà çà ïðîåçä: {ffd700}Áåñïëàòíî", 0x000000FF, 9999.0, 9999.0, 9999.0, 50.0, 0, 0);
                 	Attach3DTextLabelToVehicle(pInfo[playerid][Text3dAvt], GetPlayerVehicleID(playerid), 0.0, 0.0, 3.0);
					return 1;
				}
			}
		}
	}
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(GetPVarInt(playerid, #busID) == GetPlayerVehicleID(playerid) && pInfo[playerid][AvtobusTochkaInf] == 0) {
		if(pInfo[playerid][AvtobusTochka] == 15 || pInfo[playerid][AvtobusTochka] == 4 || pInfo[playerid][AvtobusTochka] == 8 || pInfo[playerid][AvtobusTochka] == 11 || pInfo[playerid][AvtobusTochka] == 13) {
			if(Counting[playerid] == false) {
				new ii = 30;
				Counting[playerid] = true;
	   			SendClientMessage(playerid, COLOR_GREEN, "{ffd700}Îñòàíîâêà!{ffffff} Ïîäîæäèòå {ffd700}10 ñåêóíä{ffffff} è ïðîäîëæèòå ïóòü");
				SetTimerEx("CountDown", 10 * 1000, false, "iiii", ii, pInfo[playerid][AvtobusTochka], pInfo[playerid][AvtobusTochka2], playerid);
			}
		}
		else {
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerRaceCheckpoint(playerid, 0, AvtobusCoords[pInfo[playerid][AvtobusTochka]][0], AvtobusCoords[pInfo[playerid][AvtobusTochka]][1], AvtobusCoords[pInfo[playerid][AvtobusTochka]][2], AvtobusCoords[pInfo[playerid][AvtobusTochka2]][0], AvtobusCoords[pInfo[playerid][AvtobusTochka2]][1], AvtobusCoords[pInfo[playerid][AvtobusTochka2]][2], 7.0);
			pInfo[playerid][AvtobusTochka]++;
			pInfo[playerid][AvtobusTochka2] = pInfo[playerid][AvtobusTochka] + 1;
			pInfo[playerid][pCash] += 75;
			GivePlayerMoney(playerid,75);
		}
    }
    
    if(GetPVarInt(playerid, #busID) == GetPlayerVehicleID(playerid) && pInfo[playerid][AvtobusTochkaInf] == 1) {
     	DisablePlayerRaceCheckpoint(playerid);
		pInfo[playerid][AvtobusTochka]++;
		pInfo[playerid][AvtobusTochka2] = pInfo[playerid][AvtobusTochka] + 1;
		pInfo[playerid][pCash] += 75;
		GivePlayerMoney(playerid,75);
		//if(pInfo[playerid][AvtobusTochka] == 14) {
		//SetTimerEx("Ostanovka",1000*30,false,"iii",pInfo[playerid][AvtobusTochka],pInfo[playerid][AvtobusTochka2],playerid);
		//}
		SetPlayerRaceCheckpoint(playerid, 0, AvtobusCoords2[pInfo[playerid][AvtobusTochka]][0], AvtobusCoords2[pInfo[playerid][AvtobusTochka]][1], AvtobusCoords2[pInfo[playerid][AvtobusTochka]][2], AvtobusCoords2[pInfo[playerid][AvtobusTochka2]][0], AvtobusCoords2[pInfo[playerid][AvtobusTochka2]][1], AvtobusCoords2[pInfo[playerid][AvtobusTochka2]][2], 7.0);

    }
}
@CheckAvto(playerid);
@CheckAvto(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
	{
	    //cache_get_row(0, 2, VladChak, dbHandle, MAX_PLAYER_NAME);
		pInfo[playerid][pAvtobusnik] = cache_get_row_int(0, 116); // rmbank
  		if(pInfo[playerid][pAvtobusnik] == 0) {
			RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, COLOR_RED, "Âû íå ðàáîòàåòå â {ffd700}×ÀÊ!");
		}
		else if (!pInfo[playerid][naRaboteAvt]) {
		    RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, COLOR_RED, "Âû íå ïåðåîäåëèñü â ðàáî÷óþ ôîðìó");
		}
		else ShowPlayerDialog(playerid, avtArent, DIALOG_STYLE_MSGBOX, "{ffffff}Àðåíäîâàòü àâòîáóñ", "{ffffff}Âû äåéñòâèòåëüíî æåëàåòå àðåíäîâàòü àâòîáóñ?\nÑòîèìîñòü àðåíäû: {ffd700}250$", "Ïðèíÿòü", "Îòêëîíèòü");
	}
	return 1;
}
@ChakChat(playerid);
@ChakChat(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
 	{
	    pInfo[playerid][pAvtobusnik] = cache_get_row_int(0, 116); 
	}
	return 1;
}
@ChakInf(playerid);
@ChakInf(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields);
	if(rows)
	{
	    //cache_get_row(0, 2, VladChak, dbHandle, MAX_PLAYER_NAME);
		kvAvt = cache_get_row_int(0, 2); // rmbank
		kvSotr = cache_get_row_int(0, 3); // yakuzadrugs
  		new string[256];
  		format(string,sizeof(string),"{ffd700}1. {ffffff}Âëàäåëåö: {ffd700}Andrey_Antonov\n{ffd700}2. {ffffff}Êîëè÷åñòâî àâòîáóñîâ: {ffd700}%d\n{ffd700}3. {ffffff}Êîëè÷åñòâî ñîòðóäíèêîâ: {ffd700}%d", kvAvt, kvSotr);
		ShowPlayerDialog(playerid, ChakInf,DIALOG_STYLE_MSGBOX,"{ffd700}×ÀÊ |{ffffff} Îñíîâíàÿ èíôîðìàöèÿ",string,"ÎÊ","Íàçàä");
	}
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	pTemp[playerid][pAbletoGun] = 2;
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(inAvt(GetPlayerVehicleID(playerid))) {
	        if(pInfo[playerid][bus_timer] == true) KillTimer(pInfo[playerid][busik_timer]);
        	else {
				mysql_query_string[0] = EOS;
				format(mysql_query_string, 200, "SELECT * FROM accounts WHERE name = '%s'", GetName(playerid));
	        	mysql_tquery(dbHandle, mysql_query_string, "@CheckAvto", "i", playerid);
			}
		}
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		if(GetPVarInt(playerid, #busID) != 0) {
		pInfo[playerid][bus_timer] = true;
		pInfo[playerid][busik_timer] = SetTimerEx("spawned_bus",30000,false,"i",playerid);
		SendClientMessage(playerid, COLOR_RED, "Åñëè âû íå âåðí¸òåñü â àâòîáóñ â òå÷åíèè {ffd700}30 ñåêóíä,{ff0000} îí áóäåò ýâàêóèðîâàí."); }

	}
	if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
	{
		if(inAvt(GetPlayerVehicleID(playerid))) {
			SendClientMessage(playerid, COLOR_GREY, "Âû ïîêèíóëè àâòîáóñ ñ áåñïëàòíûì ïðîåçäîì. Óäà÷è.");
		}
	}
}