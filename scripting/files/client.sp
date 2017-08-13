stock bool IsValidClient(int client, bool alive = false)
{
  if(0 < client && client <= MaxClients && IsClientInGame(client) && IsFakeClient(client) == false && (alive == false || IsPlayerAlive(client)))
  {
    return true;
  }
  return false;
}
