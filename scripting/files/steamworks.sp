public void WebLinks_Initialize(int client, char[] sz_Param, char[] sz_Address, int len)
{
    if (IsValidClient(client)) {

        char szClientIp[64];
        //char szBuffer[512];
        char szURLAddress[512];
        char szSteamId[128];
        
        GetClientAuthId(client, AuthId_SteamID64, szSteamId, sizeof(szSteamId));
        GetClientIP(client, szClientIp, sizeof(szClientIp));
        ReplaceTextVariables(client, sz_Address, len);
        
        Format(szURLAddress, sizeof(szURLAddress), "%s/api/v2/request/create", WEBLINKS_API);
       
        Handle hHTTPRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodPOST, szURLAddress);

        if (hHTTPRequest == INVALID_HANDLE) {

            LogError("ERROR hRequest(%i): %s", hHTTPRequest, sz_Address);
            return;
	    }

        SteamWorks_SetHTTPRequestGetOrPostParameter(hHTTPRequest, "steamId", szSteamId);
        SteamWorks_SetHTTPRequestGetOrPostParameter(hHTTPRequest, "playerIp", szClientIp);
        SteamWorks_SetHTTPRequestGetOrPostParameter(hHTTPRequest, "url", sz_Address);
        SteamWorks_SetHTTPRequestGetOrPostParameter(hHTTPRequest, "fetchMethod", sFetchMethod);
        SteamWorks_SetHTTPRequestGetOrPostParameter(hHTTPRequest, "customParams", sz_Param);

        bool bNetwork = SteamWorks_SetHTTPRequestNetworkActivityTimeout(hHTTPRequest, 20);
        bool bContext = SteamWorks_SetHTTPRequestContextValue(hHTTPRequest, GetClientUserId(client));
        bool bCallback = SteamWorks_SetHTTPCallbacks(hHTTPRequest, WebLinks_OpenWeb);
        
        if (bNetwork == false || bCallback == false || bContext == false) {
            
            delete hHTTPRequest;
            return;
        }

        bool bRequest = SteamWorks_SendHTTPRequest(hHTTPRequest);

        if (bRequest == false) {

            delete hHTTPRequest;
            return;
        }

        SteamWorks_PrioritizeHTTPRequest(hHTTPRequest);
    }
}

public int WebLinks_OpenWeb(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode, any userid)
{
    int client = GetClientOfUserId(userid);
    
    if (IsValidClient(client)) {

        if (bFailure || !bRequestSuccessful || eStatusCode != k_EHTTPStatusCode200OK) {

            PrintToChat(client, "%s Something went wrong > HTTP Code: %s", TAG, eStatusCode);
            
            delete hRequest;
            return;
        }
        
        int iBodySize;

        if (!SteamWorks_GetHTTPResponseBodySize(hRequest, iBodySize)) {
            
            delete hRequest;
            return;
        }

        char[] szBody = new char[iBodySize + 1];
        
        if (!SteamWorks_GetHTTPResponseBodyData(hRequest, szBody, iBodySize)) {
            
            delete hRequest;
            return;
        }

        KeyValues hKeyValues = new KeyValues("response");
        
        if (hKeyValues.ImportFromString(szBody)) {

            if (hKeyValues.GotoFirstSubKey()) {

                char szHttpCode[64];
                
                hKeyValues.GetString("http_code", szHttpCode, sizeof(szHttpCode));
                
                if (StrEqual(szHttpCode, "API_REQUEST_SUCCESS", false)) {

                    if (bCSGO) {

                        CPrintToChat(client, "%s %T", TAG_COLOR, "Chat CSGO Info", client);

                    } else {

                        char szBuffer[2048];
                        char szSteamId[128];

                        GetClientAuthId(client, AuthId_SteamID64, szSteamId, sizeof(szSteamId));
                        Format(szBuffer, sizeof(szBuffer), "%s/method/steamid/%s", WEBLINKS_API, szSteamId);
                        ShowMOTDPanel(client, "WebLinks by ESK0 & NOMIS", szBuffer, MOTDPANEL_TYPE_URL);
                    }

                } else {

                    PrintToChat(client, "%s Something went wrong > API Code: %s", TAG, szHttpCode);
                }
            }
        }
    }
}
