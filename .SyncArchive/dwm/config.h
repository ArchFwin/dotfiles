/* See LICENSE file for copyright and license details. */

/* appearance */

static const char font[]					= "Fira Mono 8";
static const char normbordercolor[]			= "#444444";
static const char normbgcolor[]				= "#272822";
static const char normfgcolor[]				= "#f8f8f2";
static const char selbordercolor[]			= "#057cfc";
static const char selbgcolor[]				= "#272822";
static const char selfgcolor[]				= "#0AA6CF";
static const char floatnormbordercolor[]	= "#1f1f1f";
static const char floatselbordercolor[]		= "#005577";
static const unsigned int borderpx			= 1;				/* border pixel of windows */
static const unsigned int snap				= 64;				/* snap pixel */
static const unsigned int systrayspacing	= 4;				/* Systray Spacing*/
static const Bool showsystray				= True;				/* False means no system tray */
static const Bool showbar					= True;				/* False means no bar */
static const Bool topbar					= True;				/* False means bottom bar */

/* tagging */

static const char *tags[] = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII" };

static const Rule rules[] = {
	/*	class							instance		title		tagsmask		isfloating?		monitor	*/
	{	"Gimp",							NULL,			NULL,		0,				True,			-1	},
	{	"Firefox",						NULL,			NULL,		1<<0,			False,			-1	},
	{	"Claws-mail",					NULL,			NULL,		1<<2,			False,			-1	},
	{	"Pidgin",						NULL,			NULL,		1<<2,			True,			-1	},
	{	"Sakura",						NULL,			NULL,		1<<1,			False,			-1	},
	{	"libreoffice-writer",			NULL,			NULL,		1<<4,			False,			-1	},
	{	"libreoffice-startcenter",		NULL,			NULL,		1<<4,			False,			-1	},
	{	"libreoffice-calc",				NULL,			NULL,		1<<4,			False,			-1	},
	{	"libreoffice-impress",			NULL,			NULL,		1<<4,			False,			-1	},
	{	NULL,							NULL,			"LibreOffice", 	1<<4,		True,			-1	},
	{	"Libreoffice",					NULL,			NULL,		1<<4,			True,			-1	},
	{	"Gummi", 						NULL,			NULL,		1<<5,			False,			-1	},
	{	"Sublime_text",					NULL,			NULL,		1<<5,			False,			-1	},
	{	"Gedit",						NULL,			NULL,		1<<5,			False,			-1	},
	{	"Spotify",						NULL,			NULL,		1<<3,			False,			-1	},
	{	"feh",							NULL,			NULL,		0,				True,			-1	},
	{	"mpv",							NULL,			NULL,		0,				True,			-1	},
};

/* layout(s) */

static const float mfact		= 0.55;	/* factor of master area size [0.05..0.95] */
static const int nmaster		= 1;	/* number of clients in master area */
static const Bool resizehints	= True;	/* True means respect size hints in tiled resizing */

static const Layout layouts[] = {
	/* symbol	arrange function */
	{ "⊞",		tile },	/* first entry is default */
	{ "◰"		},		/* no layout function means floating behaviour */
	{ "□",		monocle },
};

/* key definitions */

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,						KEY,		toggleview,		{.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask, 			KEY,		view,			{.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,				KEY,		tag,			{.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask,	KEY,		toggletag,		{.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/zsh", "-c", cmd, NULL } }

/* commands */

static const char *dmenucmd[]		= { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]		= { "sakura", NULL };
static const char *upvol[]			= { "amixer", "set", "Master", "2%+", NULL };
static const char *downvol[]		= { "amixer", "set", "Master", "2%-", NULL };
static const char *lock[]			= { "slock", NULL };
static const char *screenshot[]		= { "import", "-window", "root", "/home/andrew/Pictures/fullscreen.png", NULL };
static const char *areashot[]		= { "import", "/home/andrew/Pictures/screenshot.png", NULL };
static const char *mute[]			= { "amixer", "set", "Master", "toggle", NULL };
static const char *shutdown[]		= { "systemctl", "poweroff", NULL };
static const char *reboot[]			= { "systemctl", "reboot", NULL };
static Key keys[] = {
	/* modifier						key				function		argument */
	{	MODKEY,						XK_r,			spawn,			{.v = dmenucmd } },
	{	MODKEY|ShiftMask,			XK_Return,		spawn,			{.v = termcmd } },
	{	MODKEY|ShiftMask,			XK_r,			spawn,			{.v = reboot } },
	{	MODKEY,						XK_b,			togglebar,		{0} },
	{	MODKEY,						XK_j,			focusstack,		{.i = +1 } },
	{	MODKEY,						XK_k,			focusstack,		{.i = -1 } },
	{	MODKEY,						XK_i,			incnmaster,		{.i = +1 } },
	{	MODKEY,						XK_d,			incnmaster,		{.i = -1 } },
	{	MODKEY,						XK_h,			setmfact,		{.f = -0.05} },
	{	MODKEY,						XK_l,			setmfact,		{.f = +0.05} },
	{	MODKEY|ShiftMask,			XK_l,			spawn,			{.v = lock } },
	{	MODKEY,						XK_Return,		zoom,			{0} },
	{	MODKEY,						XK_Tab,			view,			{0} },
	{	MODKEY|ShiftMask,			XK_c,			killclient,		{0} },
	{	MODKEY,						XK_t,			setlayout,		{.v = &layouts[0]} },
	{	MODKEY,						XK_f,			setlayout,		{.v = &layouts[1]} },
	{	MODKEY,						XK_m,			setlayout,		{.v = &layouts[2]} },
	{	MODKEY,						XK_space,		setlayout,		{0} },
	{	MODKEY|ShiftMask,			XK_space,		togglefloating,	{0} },
	{	MODKEY,						XK_0,			view,			{.ui = ~0 } },
	{	MODKEY|ShiftMask,			XK_0,			tag,			{.ui = ~0 } },
	{	MODKEY,						XK_comma,		focusmon,		{.i = -1 } },
	{	MODKEY,						XK_period,		focusmon,		{.i = +1 } },
	{	MODKEY|ShiftMask,			XK_comma,		tagmon,			{.i = -1 } },
	{	MODKEY|ShiftMask,			XK_period,		tagmon,			{.i = +1 } },
	{	0,							0x1008ff13,		spawn,			{.v = upvol } },
	{	0,							0x1008ff11,		spawn,			{.v = downvol } },
	{	0,							XK_Print,		spawn,			{.v = screenshot } },
	{	0|ShiftMask,				XK_Print,		spawn,			{.v = areashot } },
	{	0,							0x1008ff12,		spawn,			{.v = mute } },
	{	MODKEY|ShiftMask,			XK_s,			spawn,			{.v = shutdown} },
	TAGKEYS(						XK_1,							0)
	TAGKEYS(						XK_2,							1)
	TAGKEYS(						XK_3,							2)
	TAGKEYS(						XK_4,							3)
	TAGKEYS(						XK_5,							4)
	TAGKEYS(						XK_6,							5)
	TAGKEYS(						XK_7,							6)
	TAGKEYS(						XK_8,							7)
	TAGKEYS(						XK_9,							8)
	{ MODKEY|ShiftMask,				XK_q,			quit,			{0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */

static Button buttons[] = {
	/* click				event mask		button			function			argument */
	{ ClkLtSymbol,			0,				Button1,		setlayout,			{0} },
	{ ClkLtSymbol,			0,				Button3,		setlayout,			{.v = &layouts[2]} },
	{ ClkWinTitle,			0,				Button2,		zoom,				{0} },
	{ ClkStatusText,		0,				Button2,		spawn,				{.v = termcmd } },
	{ ClkClientWin,			MODKEY,			Button1,		movemouse,			{0} },
	{ ClkClientWin,			MODKEY,			Button2,		togglefloating,		{0} },
	{ ClkClientWin,			MODKEY,			Button3,		resizemouse,		{0} },
	{ ClkTagBar,			0,				Button1,		toggleview,			{0} },
	{ ClkTagBar,			0,				Button3,		view,				{0} },
	{ ClkTagBar,			MODKEY,			Button1,		tag,				{0} },
	{ ClkTagBar,			MODKEY,			Button3,		toggletag,			{0} },
};
