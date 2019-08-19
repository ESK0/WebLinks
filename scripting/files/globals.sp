#define TAG "[WebLinks]"
#define TAG_COLOR "{darkred}[WebLinks]{lightred}"

#define PLUGIN_NAME "WebLinks"
#define PLUGIN_VERSION "1.6"
#define PLUGIN_AUTHOR "ESK0"
#define PLUGIN_URL "https://forums.alliedmods.net/showthread.php?t=300313"
#define WEBLINKS_API "https://weblinks.hexa-core.eu"

ArrayList arList_WebLinks;
ArrayList arList_Param;
ArrayList arList_Address;

char sFallbackUrl[512];
char sFetchMethod[16];
char sConfigPath[PLATFORM_MAX_PATH];
bool bCSGO = false;