class CfgPatches
{
    class TMP_DayZMod
    {
        requiredVersion=0.1;
        requiredAddons[]=
        {
            "DZ_Scripts",
            "DZ_Data"
        };
        units[]={};
        weapons[]={};
    };
};
class CfgMods
{
    class TMP_DayZMod
    {
        dir = "TMP_DayZMod";
        picture = "";
        action = "";
        hideName = 1;
        hidePicture = 1;
        name="TMP_DayZMod";
        author = "DayZDev";     // 修改为你自己的昵称
        overview = "";
        authorID = "289986635"; // 修改为你自己的SteamID或者联系方式
        version = "1.0";
        extra = 0;
        type = "mod";
        inputs = "";
        description = "";

        dependencies[]= { "Game", "World", "Mission" };

        // 声明预编译变量, 通常用于其他mod中, 判断是否挂载了本模组
        defines[]= { "TMP_DAYZMOD" };
        class defs
        {
            class gameScriptModule
            {
                value="";
                files[]=
                {
                    "TMP_DayZMod/Scripts/3_Game"
                };
            };
            class worldScriptModule
            {
                value="";
                files[]=
                {
                    "TMP_DayZMod/Scripts/4_World"
                };
            };
            class missionScriptModule
            {
                value="";
                files[]=
                {
                    "TMP_DayZMod/Scripts/5_Mission"
                };
            };
        };
    };
};
