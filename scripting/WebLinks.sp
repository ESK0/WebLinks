#include <sourcemod>
#include <steamworks>

#pragma semicolon 1
#pragma newdecls required

#include "files/globals.sp"
#include "files/client.sp"
#include "files/misc.sp"
#include "files/steamworks.sp"

public Plugin myinfo =
{
    name = PLUGIN_NAME,
    version = PLUGIN_VERSION,
    author = PLUGIN_AUTHOR,
    description = "WebLinks is a Web Shortcuts replacement",
    url = PLUGIN_URL
};

public void OnPluginStart()
{
    arList_WebLinks = new ArrayList(64);
    arList_Param = new ArrayList(64);
    arList_Address = new ArrayList(1024);

    EngineVersion engine = GetEngineVersion();
    bCSGO = (engine == Engine_CSGO);

    BuildPath(Path_SM, sConfigPath, sizeof(sConfigPath), "configs/WebLinks.cfg");
    LoadTranslations("e_weblinks.phrases");
}

public void OnMapStart()
{
    AddServerToTracker();
    LoadConfig();
    LoadWebLinks();
}

public void OnMapEnd()
{
    if (bCSGO)
        LoadConfig();
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
    if (IsValidClient(client)) {

        if (StrEqual(command, "say") || StrEqual(command, "say_team")) {

            if (StrEqual(sArgs, "motd"))
                return Plugin_Handled;

            int iWebLinks = arList_WebLinks.FindString(sArgs);

            if (iWebLinks != -1) {

                char sz_Param[64];
                char sz_Address[1024];

                arList_Param.GetString(iWebLinks, sz_Param, sizeof(sz_Param));
                arList_Address.GetString(iWebLinks, sz_Address, sizeof(sz_Address));

                WebLinks_Initialize(client, sz_Param, sz_Address, sizeof(sz_Address));

                return Plugin_Handled;
            }
        }
    }

    return Plugin_Continue;
}
