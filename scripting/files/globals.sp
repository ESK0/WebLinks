#define TAG "[WebLinks]"

#define PLUGIN_NAME "WebLinks"
#define PLUGIN_VERSION "1.5.1"
#define PLUGIN_AUTHOR "ESK0"
#define PLUGIN_URL "https://forums.alliedmods.net/showthread.php?t=300313"
#define PLUGIN_HASH "$2y$10$twIoD.T4VDZ2hY/yJ9ukQ.V6qU7N5pmR0pjNJv7igvTA.8e5YSft2"
#define API_KEY "e1b754d2baccaea944dc62419f67d86d90a657ec"
#define WEBLINKS_API "https://weblinks.hexa-core.eu"

ArrayList arList_WebLinks;
ArrayList arList_Param;
ArrayList arList_Address;

char sFallbackUrl[512];
char sFetchMethod[16];
char sConfigPath[PLATFORM_MAX_PATH];
bool bCSGO = false;