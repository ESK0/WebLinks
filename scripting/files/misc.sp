public void ReplaceTextVariables(int client, char[] text, int len)
{
  char szBuffer[256];
  if(StrContains(text , "{NAME}") != -1)
  {
    Format(szBuffer, sizeof(szBuffer), "%N", client);
    ReplaceString(text, len, "{NAME}", szBuffer);
  }
  if(StrContains(text , "{STEAMID}") != -1)
  {
    GetClientAuthId(client, AuthId_Steam2, szBuffer, sizeof(szBuffer));
    ReplaceString(text, len, "{STEAMID}", szBuffer);
  }
  if(StrContains(text , "{STEAMID64}") != -1)
  {
    GetClientAuthId(client, AuthId_SteamID64, szBuffer, sizeof(szBuffer));
    ReplaceString(text, len, "{STEAMID64}", szBuffer);
  }
  if(StrContains(text , "{SERVER_IP}") != -1)
  {
    GetServerIP(szBuffer, sizeof(szBuffer));
    ReplaceString(text, len, "{SERVER_IP}", szBuffer);
  }
  if(StrContains(text , "{SERVER_PORT}") != -1)
  {
    int port = GetConVarInt(FindConVar("hostport"));
    IntToString(port, szBuffer, sizeof(szBuffer));
    ReplaceString(text, len, "{SERVER_PORT}", szBuffer);
  }
  if(StrContains(text, "{CURRENTMAP}") != -1)
  {
    char sTempMap[256];
    GetCurrentMap(sTempMap, sizeof(sTempMap));
    GetMapDisplayName(sTempMap, szBuffer, sizeof(szBuffer));
    ReplaceString(text, len, "{CURRENTMAP}", szBuffer);
  }
}
public void LoadWebLinks()
{
  arList_WebLinks.Clear();
  arList_Param.Clear();
  arList_Address.Clear();

  char sz_Buffer[1024];
  BuildPath(Path_SM, sz_Buffer, sizeof(sz_Buffer), "configs/weblinks.txt");
  if(FileExists(sz_Buffer))
  {
    File file = OpenFile(sz_Buffer, "r");
    if(file != null)
    {
      char sz_Key[32];
      char sz_Param[64];
      char sz_Address[512];
      while(!file.EndOfFile() && file.ReadLine(sz_Buffer, sizeof(sz_Buffer)))
      {
        TrimString(sz_Buffer);
        if(sz_Buffer[0] != '\0' || (sz_Buffer[0] != '/' && sz_Buffer[1] != '/'))
        {
          int iKeyPos = BreakString(sz_Buffer, sz_Key, sizeof(sz_Key));
          if(iKeyPos == -1)
          {
            continue;
          }
          int iParam = BreakString(sz_Buffer[iKeyPos], sz_Param, sizeof(sz_Param));
          if(iParam == -1)
          {
            continue;
          }
          strcopy(sz_Address, sizeof(sz_Address), sz_Buffer[iKeyPos+iParam]);
          TrimString(sz_Address);
          arList_WebLinks.PushString(sz_Key);
          arList_Param.PushString(sz_Param);
          arList_Address.PushString(sz_Address);
        }
      }
    }
    file.Close();
  }
}
stock void GetServerIP(char[] buffer, int len)
{
  int ips[4];
  int ip = GetConVarInt(FindConVar("hostip"));
  ips[0] = (ip >> 24) & 0x000000FF;
  ips[1] = (ip >> 16) & 0x000000FF;
  ips[2] = (ip >> 8) & 0x000000FF;
  ips[3] = ip & 0x000000FF;
  Format(buffer, len, "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3]);
}
stock void URLEncode(char[] str, int len)
{
    char[] str2 = new char[len*3+1];
    Format(str2,len*3+1,"%s",str);
    char ReplaceThis[20][] = {"%", " ", "!", "*", "'", "(", ")", ";", ":", "@", "&", "=", "+", "$", ",", "/", "?", "#", "[", "]"};
    char ReplaceWith[20][] = {"%25", "%20", "%21", "%2A", "%27", "%28", "%29", "%3B", "%3A", "%40", "%26", "%3D", "%2B", "%24", "%2C", "%2F", "%3F", "%23", "%5B", "%5D"};
    for(int x = 0; x < 20 ; x++)
    {
      ReplaceString(str2, len, ReplaceThis[x], ReplaceWith[x]);
    }
    Format(str, len, "%s", str2);
}
