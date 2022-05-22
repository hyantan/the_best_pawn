
#include <a_samp>
#include <sscanf2>
#include <a_mysql>
#include <Pawn.CMD>


new DBID, kvplay = 0, randomsum[5], ides[5], score[5], myid = -1, timer;
const COLOR_ORANGE = 0xFF7F0000; // Оранжевый цвет
main() {}

public OnGameModeInit()
{
	DBID = mysql_connect("127.0.0.1","gs156109", "gs156109", "1kVghx96bXbG");
	TestDB();
	return 1;
}

stock TestDB(){
	switch (mysql_errno()) {
	    case 0: print("Подключение к БД - Успешно!");
	    case 1044: printf("Подключение к БД - Ошибка!");
	    case 1045: printf("Подключение к БД - Ошибка!");
	    case 1049: printf("Подключение к БД - Ошибка!");
	    case 2003: printf("Подключение к БД - Ошибка!");
	    case 2005: printf("Подключение к БД - Ошибка!");
	    default: printf("АШИБКА");
	}
	return 1;
}


public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

CMD:casino(playerid, params[]) {
        SendClientMessage(playerid, COLOR_ORANGE, "Работает");
        fg_ShowPlayerDialog(playerid, 101, DIALOG_STYLE_MSGBOX, "Казино", "Вы дейтсвительно желаете попасть в лобби?", "Да", "Нет");
	    return 1;
}
stock UpdateDialog(apl) {
    		new med[2000];
            format(med, sizeof(med), "");
            for (new i = 0; i < kvplay; i++) {
                new abv[256];
                new namka[MAX_PLAYER_NAME + 1];
            	GetPlayerName(ides[i], namka, sizeof(namka));
	 			format(abv, sizeof(abv), "%d. %s. Ставка - %d. Очков - %d\n", i+1, namka, randomsum[i], score[i]);
	 			strcat(med, abv);
            }
			fg_ShowPlayerDialog(apl, 102, DIALOG_STYLE_MSGBOX, "Лобби", med, "Обновить", "Нет");
}
forward TimerFunc();
public TimerFunc() {
	new med[2000];
	new dima[5];
	new dimab = 0;
	while (dimab < kvplay) {
		new a = random(10)+1;
		for (new i = 0; i < dimab; i++) {
			if (a == dima[i]) {
				break;
				continue;
			}
		}
		dima[dimab] = a;
		dimab++;
	}
 	for (new i = 0; i < kvplay; i++) {
		format(med, sizeof(med), "Вам выпало число %d.", dima[i]);
		SendClientMessage(ides[i], COLOR_ORANGE, med);
   	}
	new maxim = 0;
	for (new i = 1; i < kvplay; i++) {
		if (dima[i] > dima[maxim]) maxim = i;
	}
   	new gString[95];
   	new namka[MAX_PLAYER_NAME];
   	GetPlayerName(ides[maxim], namka, sizeof(namka));
   	new hour, minute, second;
   	gettime(hour,minute,second);
   	new astring[10];
	format(astring, sizeof(astring), "%d:%d:%d", hour, minute, second);
	SendClientMessage(ides[maxim], COLOR_ORANGE, "Вы успешно выиграли!");
	format(gString, sizeof(gString), "INSERT INTO `logs` (`name`, `count`, `time`) VALUES ('%s', %d, '%s')", namka, randomsum[maxim], astring);
	mysql_function_query(DBID, gString, false, "", "");
	SetTimer("TimerFunc2",5*1000,false);
	
}
forward TimerFunc2();
public TimerFunc2() {
    for (new i = 0; i < kvplay; i++) {
    	ShowPlayerDialog(ides[i], -1, 0, " ", " ", " ", " ");
	}
	kvplay = 0;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid) {
		case 101: if (response) {
            SendClientMessage(playerid, COLOR_ORANGE, "Работает");
            ides[kvplay] = playerid;
            randomsum[kvplay] = random(100000)+1;
            score[kvplay] = 0;
            kvplay++;
            new med[2000];
            format(med, sizeof(med), "");
            for (new i = 0; i < kvplay; i++) {
                new abv[256];
                new namka[MAX_PLAYER_NAME + 1];
            	GetPlayerName(ides[i], namka, sizeof(namka));
	 			format(abv, sizeof(abv), "%d. %s. Ставка - %d. Очков - %d\n", i+1, namka, randomsum[i], score[i]);
	 			strcat(med, abv);
            }
            fg_ShowPlayerDialog(playerid, 102, DIALOG_STYLE_MSGBOX, "Лобби", med, "Обновить", "Нет");
            if (kvplay == 5) {
                timer = SetTimer("TimerFunc",5*1000,false);
            }

  		}
  		case 102: if (response) {
  		    UpdateDialog(playerid);
  		}
  		else {
  		    new check;
			for (new i = 0; i < kvplay; i++) {
			    if (ides[i] == playerid) {
					check = true;
			    }
			    if(check) {
			        ides[i] = ides[i+1];
			    }
			}
			kvplay = kvplay-1;
			KillTimer(timer);
  		}
    }

}
fg_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    return 1;
}
